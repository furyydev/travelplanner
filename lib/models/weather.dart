class Weather {
  final String description;
  final String main;
  final double temperature;
  final double feelsLike;
  final double minTemp;
  final double maxTemp;
  final int humidity;
  final double windSpeed;
  final String icon;

  Weather({
    required this.description,
    required this.main,
    required this.temperature,
    required this.feelsLike,
    required this.minTemp,
    required this.maxTemp,
    required this.humidity,
    required this.windSpeed,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final main = json['main'] ?? {};
    final weather = (json['weather'] as List?)?[0] ?? {};
    
    return Weather(
      description: weather['description'] ?? '',
      main: weather['main'] ?? '',
      temperature: (main['temp'] ?? 0.0).toDouble(),
      feelsLike: (main['feels_like'] ?? 0.0).toDouble(),
      minTemp: (main['temp_min'] ?? 0.0).toDouble(),
      maxTemp: (main['temp_max'] ?? 0.0).toDouble(),
      humidity: main['humidity'] ?? 0,
      windSpeed: (json['wind']?['speed'] ?? 0.0).toDouble(),
      icon: weather['icon'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'main': main,
      'temperature': temperature,
      'feelsLike': feelsLike,
      'minTemp': minTemp,
      'maxTemp': maxTemp,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'icon': icon,
    };
  }

  String get iconUrl => 'https://openweathermap.org/img/wn/$icon@2x.png';
}



