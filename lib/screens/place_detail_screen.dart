import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/place.dart';
import '../providers/trip_provider.dart';
import '../widgets/weather_card.dart';
import 'itinerary_screen.dart';

class PlaceDetailScreen extends StatelessWidget {
  final Place place;

  const PlaceDetailScreen({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: place.imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: place.imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[300],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported, size: 64),
                      ),
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.place, size: 64),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (place.rating != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          place.rating!.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                  if (place.description != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      place.description!,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                  if (place.categories != null && place.categories!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      children: place.categories!
                          .take(5)
                          .map((category) => Chip(
                                label: Text(category),
                                backgroundColor: Colors.blue[50],
                              ))
                          .toList(),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Consumer<TripProvider>(
                    builder: (context, tripProvider, _) {
                      if (tripProvider.currentTrip?.weather != null) {
                        return WeatherCard(
                          weather: tripProvider.currentTrip!.weather!,
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final tripProvider =
                                Provider.of<TripProvider>(context, listen: false);
                            tripProvider.addPlaceToTrip(place);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${place.name} added to trip'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Add to Trip'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ItineraryScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.calendar_today),
                          label: const Text('Itinerary'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


