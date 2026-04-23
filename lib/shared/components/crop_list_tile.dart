import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // Use intl for consistency
import '../../features/crops/providers/crop_provider.dart';
import '../../features/crops/models/crop.dart'; // Use the real model
import '../utils/theme_helper.dart';

class CropListTile extends ConsumerWidget {
  final Crop crop; // No longer dynamic
  final DateTime currentTime;

  const CropListTile({
    super.key,
    required this.crop,
    required this.currentTime,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = crop.getStatus(currentTime);
    
    // Use a getter or a simple formatter here
    final windowText = crop.start != null && crop.end != null
        ? 'Window: ${DateFormat('M/d').format(crop.start!)} - ${DateFormat('M/d').format(crop.end!)}'
        : 'Window: TBD';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: Checkbox(
          activeColor: Colors.green[700],
          value: crop.isSelected,
          onChanged: (value) {
            ref.read(plantingProvider.notifier)
               .toggleCropSelection(crop.name, value ?? false);
          },
        ),
        title: Text(crop.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(windowText),
        trailing: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          children: [
            if (crop.quantity > 0)
              Text(
                'Qty: ${crop.quantity}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            
            if (crop.isPlanted) ...[
              const Icon(Icons.check_circle, color: Colors.green, size: 20),
              if (crop.datePlanted != null)
                Text(
                  DateFormat('M/d').format(crop.datePlanted!),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],

            Chip(
              label: Text(
                status, 
                style: const TextStyle(color: Colors.white, fontSize: 12)
              ),
              backgroundColor: AppTheme.getStatusColor(status),
            ),
          ],
        ),
      ),
    );
  }
}