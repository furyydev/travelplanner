import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../providers/trip_provider.dart';
import 'place_list_screen.dart';

class SavedTripsScreen extends StatelessWidget {
  const SavedTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Trips'),
      ),
      body: Consumer<TripProvider>(
        builder: (context, tripProvider, _) {
          final trips = tripProvider.savedTrips;

          if (trips.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bookmark_border, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'No saved trips',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Search for destinations and save your trips',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: trips.length,
            itemBuilder: (context, index) {
              final trip = trips[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () async {
                    await tripProvider.loadTrip(trip.id);
                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PlaceListScreen(),
                        ),
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: trip.imageUrl != null
                            ? CachedNetworkImage(
                                imageUrl: trip.imageUrl!,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  height: 200,
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  height: 200,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image_not_supported),
                                ),
                              )
                            : Container(
                                height: 200,
                                color: Colors.grey[300],
                                child: const Icon(Icons.place, size: 64),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trip.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  '${trip.destination.name}${trip.destination.country != null ? ', ${trip.destination.country}' : ''}',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.place, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  '${trip.places.length} places',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                const Spacer(),
                                Text(
                                  DateFormat('MMM dd, yyyy')
                                      .format(trip.createdAt),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            if (trip.itinerary != null) ...[
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${trip.itinerary!.totalDays} days planned',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ],
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  onPressed: () async {
                                    await tripProvider.deleteTrip(trip.id);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Trip deleted'),
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.delete_outline),
                                  label: const Text('Delete'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    await tripProvider.loadTrip(trip.id);
                                    if (context.mounted) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const PlaceListScreen(),
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.open_in_new),
                                  label: const Text('Open'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


