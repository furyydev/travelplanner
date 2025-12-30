import 'package:flutter/foundation.dart';
import '../models/trip.dart';
import '../models/place.dart';
import '../models/weather.dart';
import '../models/itinerary.dart';
import '../models/destination.dart';
import '../services/storage_service.dart';
import '../services/open_trip_map_service.dart';
import '../services/weather_service.dart';
import '../services/unsplash_service.dart';

class TripProvider with ChangeNotifier {
  Trip? _currentTrip;
  List<Trip> _savedTrips = [];
  bool _isLoading = false;
  String? _error;

  Trip? get currentTrip => _currentTrip;
  List<Trip> get savedTrips => _savedTrips;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final OpenTripMapService _placeService = OpenTripMapService();
  final WeatherService _weatherService = WeatherService();
  final UnsplashService _unsplashService = UnsplashService();

  TripProvider() {
    _loadSavedTrips();
  }

  Future<void> _loadSavedTrips() async {
    try {
      _savedTrips = await StorageService.getSavedTrips();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load saved trips: $e';
      notifyListeners();
    }
  }

  Future<void> searchDestination(String cityName) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Get image first (works independently)
      final imageUrl = await _unsplashService.getDestinationImage(cityName);

      // Try to get destination info from OpenTripMap (optional)
      Destination? destination;
      List<Place> places = [];
      Weather? weather;

      try {
        destination = await _placeService.getDestinationByCity(cityName);
        
        // Try to get places
        try {
          places = await _placeService.searchPlacesByCity(cityName);
        } catch (e) {
          // Places are optional, continue without them
          print('Could not fetch places: $e');
        }
        
        // Try to get weather if we have coordinates
        if (destination.latitude != 0.0 && destination.longitude != 0.0) {
          try {
            weather = await _weatherService.getWeatherByCoordinates(
              destination.latitude,
              destination.longitude,
            );
          } catch (e) {
            // Weather is optional
            print('Could not fetch weather: $e');
          }
        }
      } catch (e) {
        // OpenTripMap failed, create default destination
        print('OpenTripMap unavailable, using default destination: $e');
        destination = Destination(
          name: cityName,
          latitude: 0.0,
          longitude: 0.0,
        );
      }

      // Create new trip (works even if OpenTripMap fails)
      _currentTrip = Trip(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: cityName,
        destination: destination,
        places: places,
        weather: weather,
        createdAt: DateTime.now(),
        imageUrl: imageUrl,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to search destination: $e';
      notifyListeners();
    }
  }

  void addPlaceToTrip(Place place) {
    if (_currentTrip != null) {
      final places = List<Place>.from(_currentTrip!.places);
      if (!places.any((p) => p.id == place.id)) {
        places.add(place);
        _currentTrip = _currentTrip!.copyWith(places: places);
        notifyListeners();
      }
    }
  }

  void removePlaceFromTrip(String placeId) {
    if (_currentTrip != null) {
      final places = _currentTrip!.places.where((p) => p.id != placeId).toList();
      _currentTrip = _currentTrip!.copyWith(places: places);
      notifyListeners();
    }
  }

  void setItinerary(Itinerary itinerary) {
    if (_currentTrip != null) {
      _currentTrip = _currentTrip!.copyWith(itinerary: itinerary);
      notifyListeners();
    }
  }

  Future<void> saveCurrentTrip() async {
    if (_currentTrip != null) {
      try {
        await StorageService.saveTrip(_currentTrip!);
        await _loadSavedTrips();
        notifyListeners();
      } catch (e) {
        _error = 'Failed to save trip: $e';
        notifyListeners();
      }
    }
  }

  Future<void> loadTrip(String tripId) async {
    try {
      final trip = await StorageService.getTripById(tripId);
      if (trip != null) {
        _currentTrip = trip;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to load trip: $e';
      notifyListeners();
    }
  }

  Future<void> deleteTrip(String tripId) async {
    try {
      await StorageService.deleteTrip(tripId);
      if (_currentTrip?.id == tripId) {
        _currentTrip = null;
      }
      await _loadSavedTrips();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete trip: $e';
      notifyListeners();
    }
  }

  void clearCurrentTrip() {
    _currentTrip = null;
    _error = null;
    notifyListeners();
  }
}

