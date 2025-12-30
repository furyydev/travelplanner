class Destination {
  final String name;
  final double latitude;
  final double longitude;
  final String? country;
  final String? state;

  Destination({
    required this.name,
    required this.latitude,
    required this.longitude,
    this.country,
    this.state,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      name: json['name'] ?? '',
      latitude: (json['lat'] ?? json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['lon'] ?? json['longitude'] ?? 0.0).toDouble(),
      country: json['country'],
      state: json['state'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'country': country,
      'state': state,
    };
  }
}



