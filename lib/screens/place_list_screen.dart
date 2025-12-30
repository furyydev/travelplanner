import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/trip_provider.dart';
import '../widgets/place_card.dart';
import 'place_detail_screen.dart';

class PlaceListScreen extends StatelessWidget {
  const PlaceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<TripProvider>(
          builder: (context, tripProvider, _) {
            return Text(
              tripProvider.currentTrip?.name ?? 'Places',
            );
          },
        ),
        actions: [
          Consumer<TripProvider>(
            builder: (context, tripProvider, _) {
              if (tripProvider.currentTrip != null) {
                return IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () async {
                    await tripProvider.saveCurrentTrip();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Trip saved successfully!')),
                      );
                    }
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<TripProvider>(
        builder: (context, tripProvider, _) {
          if (tripProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (tripProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    tripProvider.error!,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }

          final trip = tripProvider.currentTrip;
          final places = trip?.places ?? [];

          if (places.isEmpty) {
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (trip?.imageUrl != null) ...[
                      Container(
                        margin: const EdgeInsets.all(16),
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: trip!.imageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[300],
                              child: const Center(child: CircularProgressIndicator()),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.image_not_supported, size: 64),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    const Icon(Icons.place, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      trip?.name ?? 'Destination',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('No places found'),
                    const SizedBox(height: 8),
                    Text(
                      'OpenTripMap service is currently unavailable.\nThe destination image is displayed above.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: places.length,
            itemBuilder: (context, index) {
              final place = places[index];
              return PlaceCard(
                place: place,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlaceDetailScreen(place: place),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}


