class Place {
  final String id;
  final String name;
  final String? description;
  final double latitude;
  final double longitude;
  final String? imageUrl;
  final List<String>? categories;
  final double? rating;
  final String? wikipedia;

  Place({
    required this.id,
    required this.name,
    this.description,
    required this.latitude,
    required this.longitude,
    this.imageUrl,
    this.categories,
    this.rating,
    this.wikipedia,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    // Handle both GeoJSON feature format and direct object format
    final isGeoJson = json['geometry'] != null;
    final properties = isGeoJson ? json['properties'] ?? {} : json;
    
    // Extract coordinates from GeoJSON or point object
    double lat = 0.0;
    double lon = 0.0;
    if (isGeoJson && json['geometry']?['coordinates'] != null) {
      final coords = json['geometry']!['coordinates'] as List;
      lon = (coords[0] ?? 0.0).toDouble();
      lat = (coords[1] ?? 0.0).toDouble();
    } else {
      lat = (properties['point']?['lat'] ?? properties['lat'] ?? 0.0).toDouble();
      lon = (properties['point']?['lon'] ?? properties['lon'] ?? 0.0).toDouble();
    }

    return Place(
      id: properties['xid'] ?? json['xid'] ?? '',
      name: properties['name'] ?? json['name'] ?? '',
      description: properties['wikipedia_extracts']?['text'] ?? 
                   properties['description'] ?? 
                   json['wikipedia_extracts']?['text'] ?? 
                   json['description'],
      latitude: lat,
      longitude: lon,
      imageUrl: properties['preview']?['source'] ?? 
                properties['imageUrl'] ?? 
                json['preview']?['source'] ?? 
                json['imageUrl'],
      categories: (properties['kinds'] ?? json['kinds'])
          ?.toString()
          .split(',')
          .map((e) => e.trim())
          .toList(),
      rating: (properties['rate'] ?? json['rate'])?.toDouble(),
      wikipedia: properties['wikipedia'] ?? json['wikipedia'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'imageUrl': imageUrl,
      'categories': categories,
      'rating': rating,
      'wikipedia': wikipedia,
    };
  }
}

