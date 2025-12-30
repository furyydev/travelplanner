import 'destination.dart';
import 'place.dart';
import 'weather.dart';
import 'itinerary.dart';

class Trip {
  final String id;
  final String name;
  final Destination destination;
  final List<Place> places;
  final Weather? weather;
  final Itinerary? itinerary;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? imageUrl;

  Trip({
    required this.id,
    required this.name,
    required this.destination,
    required this.places,
    this.weather,
    this.itinerary,
    required this.createdAt,
    this.updatedAt,
    this.imageUrl,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      destination: Destination.fromJson(json['destination']),
      places: (json['places'] as List?)
              ?.map((e) => Place.fromJson(e))
              .toList() ??
          [],
      weather: json['weather'] != null ? Weather.fromJson(json['weather']) : null,
      itinerary: json['itinerary'] != null
          ? Itinerary.fromJson(json['itinerary'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'destination': destination.toJson(),
      'places': places.map((e) => e.toJson()).toList(),
      'weather': weather?.toJson(),
      'itinerary': itinerary?.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'imageUrl': imageUrl,
    };
  }

  Trip copyWith({
    String? id,
    String? name,
    Destination? destination,
    List<Place>? places,
    Weather? weather,
    Itinerary? itinerary,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? imageUrl,
  }) {
    return Trip(
      id: id ?? this.id,
      name: name ?? this.name,
      destination: destination ?? this.destination,
      places: places ?? this.places,
      weather: weather ?? this.weather,
      itinerary: itinerary ?? this.itinerary,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}


