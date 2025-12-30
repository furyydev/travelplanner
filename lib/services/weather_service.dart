import '../models/weather.dart';
import '../utils/constants.dart';
import 'api_service.dart';

class WeatherService {
  Future<Weather> getWeatherByCoordinates(
      double latitude, double longitude) async {
    try {
      final url =
          '${ApiConstants.weatherBaseUrl}/weather?lat=$latitude&lon=$longitude&appid=${ApiConstants.weatherApiKey}&units=metric';

      final data = await ApiService.get(url);
      return Weather.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch weather: $e');
    }
  }

  Future<Weather> getWeatherByCity(String cityName) async {
    try {
      final url =
          '${ApiConstants.weatherBaseUrl}/weather?q=$cityName&appid=${ApiConstants.weatherApiKey}&units=metric';

      final data = await ApiService.get(url);
      return Weather.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch weather: $e');
    }
  }
}



