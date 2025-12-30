import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/trip_provider.dart';
import '../models/itinerary.dart';
import '../widgets/itinerary_item.dart';

class ItineraryScreen extends StatefulWidget {
  const ItineraryScreen({super.key});

  @override
  State<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  int _totalDays = 1;

  @override
  void initState() {
    super.initState();
    final tripProvider = Provider.of<TripProvider>(context, listen: false);
    if (tripProvider.currentTrip?.itinerary != null) {
      final itinerary = tripProvider.currentTrip!.itinerary!;
      _startDate = itinerary.startDate;
      _endDate = itinerary.endDate;
      _totalDays = itinerary.totalDays;
    } else {
      _startDate = DateTime.now();
      _endDate = DateTime.now().add(const Duration(days: 1));
      _totalDays = 1;
    }
  }

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(picked)) {
          _endDate = picked.add(const Duration(days: 1));
        }
        _calculateDays();
      });
    }
  }

  Future<void> _selectEndDate() async {
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select start date first')),
      );
      return;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate!.add(const Duration(days: 1)),
      firstDate: _startDate!,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
        _calculateDays();
      });
    }
  }

  void _calculateDays() {
    if (_startDate != null && _endDate != null) {
      _totalDays = _endDate!.difference(_startDate!).inDays + 1;
    }
  }

  void _addPlaceToDay(int day, String placeId, String placeName) {
    final tripProvider = Provider.of<TripProvider>(context, listen: false);
    final currentTrip = tripProvider.currentTrip;
    
    if (currentTrip == null || _startDate == null || _endDate == null) {
      return;
    }

    final existingItinerary = currentTrip.itinerary;
    final items = existingItinerary?.items ?? [];
    
    final dayItems = items.where((item) => item.day == day).toList();
    final maxOrder = dayItems.isEmpty
        ? 0
        : dayItems.map((item) => item.order).reduce((a, b) => a > b ? a : b);

    final newItem = ItineraryItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      placeId: placeId,
      placeName: placeName,
      date: _startDate!.add(Duration(days: day - 1)),
      day: day,
      order: maxOrder + 1,
    );

    items.add(newItem);

    final itinerary = Itinerary(
      id: existingItinerary?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      tripId: currentTrip.id,
      items: items,
      startDate: _startDate!,
      endDate: _endDate!,
      totalDays: _totalDays,
    );

    tripProvider.setItinerary(itinerary);
  }

  void _removeItem(String itemId) {
    final tripProvider = Provider.of<TripProvider>(context, listen: false);
    final currentTrip = tripProvider.currentTrip;
    
    if (currentTrip?.itinerary == null || _startDate == null || _endDate == null) {
      return;
    }

    final items = currentTrip!.itinerary!.items
        .where((item) => item.id != itemId)
        .toList();

    final itinerary = Itinerary(
      id: currentTrip.itinerary!.id,
      tripId: currentTrip.id,
      items: items,
      startDate: _startDate!,
      endDate: _endDate!,
      totalDays: _totalDays,
    );

    tripProvider.setItinerary(itinerary);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Itinerary'),
        actions: [
          Consumer<TripProvider>(
            builder: (context, tripProvider, _) {
              return IconButton(
                icon: const Icon(Icons.save),
                onPressed: () async {
                  await tripProvider.saveCurrentTrip();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Itinerary saved!')),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<TripProvider>(
        builder: (context, tripProvider, _) {
          final trip = tripProvider.currentTrip;
          if (trip == null) {
            return const Center(
              child: Text('No trip selected. Please search for a destination first.'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.calendar_today),
                          title: const Text('Start Date'),
                          subtitle: Text(
                            _startDate != null
                                ? DateFormat('MMM dd, yyyy').format(_startDate!)
                                : 'Not selected',
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: _selectStartDate,
                        ),
                        ListTile(
                          leading: const Icon(Icons.event),
                          title: const Text('End Date'),
                          subtitle: Text(
                            _endDate != null
                                ? DateFormat('MMM dd, yyyy').format(_endDate!)
                                : 'Not selected',
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: _selectEndDate,
                        ),
                        if (_totalDays > 0)
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              'Total Days: $_totalDays',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ...List.generate(_totalDays, (index) {
                  final day = index + 1;
                  final dayItems = trip.itinerary?.getItemsForDay(day) ?? [];
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'Day $day',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (dayItems.isEmpty)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                const Icon(Icons.add_circle_outline),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Add places from your trip',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  onSelected: (placeId) {
                                    final place = trip.places
                                        .firstWhere((p) => p.id == placeId);
                                    _addPlaceToDay(day, place.id, place.name);
                                  },
                                  itemBuilder: (context) {
                                    return trip.places.map((place) {
                                      return PopupMenuItem(
                                        value: place.id,
                                        child: Text(place.name),
                                      );
                                    }).toList();
                                  },
                                  child: const Icon(Icons.more_vert),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ...dayItems.map((item) {
                          return ItineraryItemWidget(
                            item: item,
                            onDelete: () => _removeItem(item.id),
                          );
                        }),
                      const SizedBox(height: 16),
                    ],
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}


