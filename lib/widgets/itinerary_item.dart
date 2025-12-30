import 'package:flutter/material.dart';
import '../models/itinerary.dart';

class ItineraryItemWidget extends StatelessWidget {
  final ItineraryItem item;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const ItineraryItemWidget({
    super.key,
    required this.item,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text(
            '${item.order}',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          item.placeName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Day ${item.day}'),
            if (item.notes != null && item.notes!.isNotEmpty)
              Text(
                item.notes!,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
          ],
        ),
        trailing: onDelete != null
            ? IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: onDelete,
                color: Colors.red,
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}



