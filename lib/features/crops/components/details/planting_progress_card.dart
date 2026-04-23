import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/crop.dart';
import '../../providers/crop_provider.dart';

class PlantingProgressCard extends ConsumerWidget {
  final Crop crop;

  const PlantingProgressCard({super.key, required this.crop});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateDisplay = crop.datePlanted != null
        ? DateFormat('MMMM d, y').format(crop.datePlanted!)
        : 'Not Set';

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Season Log',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            
            // 1. Status Toggle
            SwitchListTile(
              title: const Text('Marked as Planted'),
              value: crop.isPlanted,
              activeThumbColor: Colors.green,
              onChanged: (bool value) {
                ref.read(plantingProvider.notifier).togglePlantedStatus(crop.name, value);
              },
            ),


            // 2. Quantity Display/Edit
            ListTile(
              leading: const Icon(Icons.inventory_2, color: Colors.brown),
              title: const Text('Quantity Planned'),
              subtitle: const Text('Tap to edit count'),
              trailing: Text(
                '${crop.quantity}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                final TextEditingController controller = TextEditingController(text: crop.quantity.toString());
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Update Quantity'),
                    content: TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Number of plants/rows'),
                    ),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                      TextButton(
                        onPressed: () {
                          final int? val = int.tryParse(controller.text);
                          if (val != null) {
                            ref.read(plantingProvider.notifier).updateCropQuantity(crop.name, val);
                          }
                          Navigator.pop(context);
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                );
              },
            ),

            // 3. Date Selection
            ListTile(
              leading: const Icon(Icons.event, color: Colors.blue),
              title: const Text('Date Planted'),
              subtitle: Text(dateDisplay),
              trailing: const Icon(Icons.edit, size: 20),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: crop.datePlanted ?? DateTime.now(),
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2030),
                );
                if (picked != null) {
                  ref.read(plantingProvider.notifier).updatePlantingDate(crop.name, picked);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}