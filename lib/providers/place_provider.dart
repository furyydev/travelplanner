import 'package:flutter/foundation.dart';
import '../models/place.dart';
import '../services/open_trip_map_service.dart';

class PlaceProvider with ChangeNotifier {
  List<Place> _places = [];
  bool _isLoading = false;
  String? _error;
  String? _currentSearchQuery;

  List<Place> get places => _places;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get currentSearchQuery => _currentSearchQuery;

  final OpenTripMapService _placeService = OpenTripMapService();

  Future<void> searchPlaces(String cityName) async {
    _isLoading = true;
    _error = null;
    _currentSearchQuery = cityName;
    notifyListeners();

    try {
      _places = await _placeService.searchPlacesByCity(cityName);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to search places: $e';
      _places = [];
      notifyListeners();
    }
  }

  void clearPlaces() {
    _places = [];
    _error = null;
    _currentSearchQuery = null;
    notifyListeners();
  }
}



