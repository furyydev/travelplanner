import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/weather.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;

  const WeatherCard({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weather.main,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      weather.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                if (weather.icon.isNotEmpty)
                  CachedNetworkImage(
                    imageUrl: weather.iconUrl,
                    width: 80,
                    height: 80,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.wb_sunny, size: 64),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeatherInfo(
                  icon: Icons.thermostat,
                  label: 'Temperature',
                  value: '${weather.temperature.toStringAsFixed(1)}°C',
                ),
                _buildWeatherInfo(
                  icon: Icons.air,
                  label: 'Feels Like',
                  value: '${weather.feelsLike.toStringAsFixed(1)}°C',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeatherInfo(
                  icon: Icons.water_drop,
                  label: 'Humidity',
                  value: '${weather.humidity}%',
                ),
                _buildWeatherInfo(
                  icon: Icons.wind_power,
                  label: 'Wind Speed',
                  value: '${weather.windSpeed.toStringAsFixed(1)} m/s',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeatherInfo(
                  icon: Icons.arrow_downward,
                  label: 'Min Temp',
                  value: '${weather.minTemp.toStringAsFixed(1)}°C',
                ),
                _buildWeatherInfo(
                  icon: Icons.arrow_upward,
                  label: 'Max Temp',
                  value: '${weather.maxTemp.toStringAsFixed(1)}°C',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherInfo({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.blue),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}



