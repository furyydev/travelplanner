class ItineraryItem {
  final String id;
  final String placeId;
  final String placeName;
  final DateTime date;
  final int day;
  final String? notes;
  final int order;

  ItineraryItem({
    required this.id,
    required this.placeId,
    required this.placeName,
    required this.date,
    required this.day,
    this.notes,
    required this.order,
  });

  factory ItineraryItem.fromJson(Map<String, dynamic> json) {
    return ItineraryItem(
      id: json['id'] ?? '',
      placeId: json['placeId'] ?? '',
      placeName: json['placeName'] ?? '',
      date: DateTime.parse(json['date']),
      day: json['day'] ?? 1,
      notes: json['notes'],
      order: json['order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'placeId': placeId,
      'placeName': placeName,
      'date': date.toIso8601String(),
      'day': day,
      'notes': notes,
      'order': order,
    };
  }
}

class Itinerary {
  final String id;
  final String tripId;
  final List<ItineraryItem> items;
  final DateTime startDate;
  final DateTime endDate;
  final int totalDays;

  Itinerary({
    required this.id,
    required this.tripId,
    required this.items,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
  });

  factory Itinerary.fromJson(Map<String, dynamic> json) {
    return Itinerary(
      id: json['id'] ?? '',
      tripId: json['tripId'] ?? '',
      items: (json['items'] as List?)
              ?.map((e) => ItineraryItem.fromJson(e))
              .toList() ??
          [],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      totalDays: json['totalDays'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tripId': tripId,
      'items': items.map((e) => e.toJson()).toList(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'totalDays': totalDays,
    };
  }

  List<ItineraryItem> getItemsForDay(int day) {
    return items.where((item) => item.day == day).toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }
}


