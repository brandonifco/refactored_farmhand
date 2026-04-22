import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/crops/providers/crop_provider.dart';
import '../utils/theme_helper.dart';
import '../../features/crops/views/crop_detail_view.dart';

class CropListTile extends ConsumerWidget {
  final dynamic crop; // Replace 'dynamic' with your actual Crop model class
  final DateTime currentTime;

  const CropListTile({
    super.key,
    required this.crop,
    required this.currentTime,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = crop.getStatus(currentTime);
    
    // Safely handle potential null dates
    final windowText = (crop.start != null && crop.end != null) 
        ? 'Window: ${crop.start!.month}/${crop.start!.day} - ${crop.end!.month}/${crop.end!.day}'
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
            // 1. Quantity Display
            if (crop.quantity > 0)
              Text(
                'Qty: ${crop.quantity}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            
            // 2. Planted Status Icon
            if (crop.isPlanted)
              const Icon(Icons.check_circle, color: Colors.green, size: 20),

            // 3. NEW: Automated Date Display (MM/DD)
            if (crop.isPlanted && crop.datePlanted != null)
              Text(
                '${crop.datePlanted!.month}/${crop.datePlanted!.day}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),

            // 4. Existing Status Chip
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