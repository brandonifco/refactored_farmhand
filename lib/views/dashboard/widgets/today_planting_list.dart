import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/planting_provider.dart';
import '../../details/crop_detail_view.dart';

class TodayPlantingList extends ConsumerWidget {
  const TodayPlantingList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plantingState = ref.watch(plantingProvider);
    final today = DateTime.now();

    return plantingState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text("Error loading crops: $err")),
      data: (allCrops) {
        // Filter for active, selected crops
        final activeCrops = allCrops.where((crop) {
          if (!crop.isSelected || crop.start == null || crop.end == null) return false;
          return (today.isAfter(crop.start!) || today.isAtSameMomentAs(crop.start!)) &&
                 (today.isBefore(crop.end!) || today.isAtSameMomentAs(crop.end!));
        }).toList();

        if (activeCrops.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Nothing to plant today. Check the full calendar and make sure you have crops selected!',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: activeCrops.length,
          itemBuilder: (context, index) {
            final crop = activeCrops[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.grass, color: Colors.green),
                title: Text(crop.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(crop.method),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CropDetailView(crop: crop),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}