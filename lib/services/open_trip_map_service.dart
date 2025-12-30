import '../models/place.dart';
import '../models/destination.dart';
import '../utils/constants.dart';
import 'api_service.dart';
import 'dart:convert';

class OpenTripMapService {
  Future<void> _debugLog({
    required String hypothesisId,
    required String location,
    required String message,
    required Map<String, dynamic> data,
    String runId = 'run1',
  }) async {
    final payload = {
      'sessionId': 'debug-session',
      'runId': runId,
      'hypothesisId': hypothesisId,
      'location': location,
      'message': message,
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    print('DEBUG: ${jsonEncode(payload)}');
  }

  Future<Destination> getDestinationByCity(String cityName, {String? countryParam}) async {
    try {
      final apiKey = ApiConstants.openTripMapApiKey;
      
      if (apiKey.contains('YOUR_') || apiKey.isEmpty) {
        throw Exception('OpenTripMap API key not configured. Please set OPENTRIPMAP_API_KEY in .env file');
      }
      
      final encodedCityName = Uri.encodeComponent(cityName);
      var geocodeUrl =
          '${ApiConstants.openTripMapBaseUrl}/${ApiConstants.openTripMapLang}/places/geoname?name=$encodedCityName&apikey=$apiKey';
      
      if (countryParam != null && countryParam.isNotEmpty) {
        final encodedCountry = Uri.encodeComponent(countryParam);
        geocodeUrl += '&country=$encodedCountry';
      }
      await _debugLog(
        hypothesisId: 'H1',
        location: 'open_trip_map_service.dart:40',
        message: 'geoname start',
        data: {
          'city': cityName,
          'country': countryParam,
          'url': geocodeUrl,
          'apiKeyPresent': apiKey.isNotEmpty && !apiKey.contains('YOUR_'),
          'apiKeyLength': apiKey.length,
        },
      );
      
      final data = await ApiService.get(geocodeUrl);
      
      await _debugLog(
        hypothesisId: 'H1',
        location: 'open_trip_map_service.dart:67',
        message: 'geoname raw response',
        data: {
          'responseKeys': data.keys.toList(),
          'responseData': data,
        },
      );
      
      final name = data['name'] as String?;
      final lat = data['lat'];
      final lon = data['lon'];
      final country = data['country'] as String?;
      final state = data['state'] as String?;
      
      await _debugLog(
        hypothesisId: 'H1',
        location: 'open_trip_map_service.dart:80',
        message: 'geoname parsed',
        data: {
          'name': name,
          'lat': lat,
          'lon': lon,
          'country': country,
          'state': state,
        },
      );
      
      if (lat == null || lon == null) {
        throw Exception('API returned invalid coordinates. Response: ${data.toString()}');
      }
      
      return Destination(
        name: name ?? cityName,
        latitude: (lat is num ? lat.toDouble() : double.tryParse(lat.toString()) ?? 0.0),
        longitude: (lon is num ? lon.toDouble() : double.tryParse(lon.toString()) ?? 0.0),
        country: country,
        state: state,
      );
    } catch (e) {
      await _debugLog(
        hypothesisId: 'H1',
        location: 'open_trip_map_service.dart:69',
        message: 'geoname error',
        data: {'error': e.toString()},
      );
      throw Exception('Failed to fetch destination: $e');
    }
  }

  Future<List<Place>> searchPlacesByCity(String cityName, {String? countryParam}) async {
    try {
      final destination = await getDestinationByCity(cityName, countryParam: countryParam);
      final lat = destination.latitude;
      final lon = destination.longitude;

      if (lat == 0.0 && lon == 0.0) {
        throw Exception('Invalid coordinates for city: $cityName');
      }

      final apiKey = ApiConstants.openTripMapApiKey;
      if (apiKey.contains('YOUR_') || apiKey.isEmpty) {
        throw Exception('OpenTripMap API key not configured');
      }
      
      final radius = 5000;
      final placesUrl =
          '${ApiConstants.openTripMapBaseUrl}/${ApiConstants.openTripMapLang}/places/radius?radius=$radius&lon=$lon&lat=$lat&kinds=tourist_attraction&limit=20&apikey=$apiKey';

      final placesData = await ApiService.get(placesUrl);
      final features = placesData['features'] as List? ?? [];
      await _debugLog(
        hypothesisId: 'H2',
        location: 'open_trip_map_service.dart:98',
        message: 'places radius response',
        data: {
          'city': cityName,
          'country': countryParam,
          'lat': lat,
          'lon': lon,
          'count': features.length,
        },
      );

      final places = <Place>[];
      for (var feature in features) {
        final xid = feature['properties']?['xid'];
        if (xid != null) {
          try {
            final apiKey = ApiConstants.openTripMapApiKey;
            final detailUrl =
                '${ApiConstants.openTripMapBaseUrl}/${ApiConstants.openTripMapLang}/places/xid/$xid?apikey=$apiKey';
            final placeDetail = await ApiService.get(detailUrl);
            places.add(Place.fromJson(placeDetail));
          } catch (e) {
            final props = feature['properties'] ?? {};
            final coords = feature['geometry']?['coordinates'] ?? [];
            places.add(Place(
              id: xid,
              name: props['name'] ?? '',
              latitude: coords.isNotEmpty ? (coords[1] ?? 0.0).toDouble() : 0.0,
              longitude: coords.isNotEmpty ? (coords[0] ?? 0.0).toDouble() : 0.0,
            ));
          }
        }
      }

      return places;
    } catch (e) {
      throw Exception('Failed to fetch places: $e');
    }
  }

  Future<List<Place>> autosuggestPlaces(String query) async {
    try {
      final apiKey = ApiConstants.openTripMapApiKey;
      final encodedQuery = Uri.encodeComponent(query);
      final url =
          '${ApiConstants.openTripMapBaseUrl}/${ApiConstants.openTripMapLang}/places/autosuggest?name=$encodedQuery&apikey=$apiKey';
      
      final data = await ApiService.get(url);
      final features = data['features'] as List? ?? [];
      
      return features.map((feature) {
        final props = feature['properties'] ?? {};
        final coords = feature['geometry']?['coordinates'] ?? [];
        return Place(
          id: props['xid'] ?? '',
          name: props['name'] ?? '',
          latitude: coords.isNotEmpty ? (coords[1] ?? 0.0).toDouble() : 0.0,
          longitude: coords.isNotEmpty ? (coords[0] ?? 0.0).toDouble() : 0.0,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to autosuggest places: $e');
    }
  }
}

