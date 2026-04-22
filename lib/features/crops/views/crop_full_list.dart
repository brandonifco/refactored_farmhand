import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/crop_provider.dart';
// Note: Extracted the Card into this new file
import '../../../shared/components/crop_list_tile.dart'; 

class FullCropsList extends ConsumerWidget {
  const FullCropsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plantingState = ref.watch(plantingProvider);
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Crops List'),
        backgroundColor: Colors.blueGrey[700],
        foregroundColor: Colors.white,
      ),
      body: plantingState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
        data: (allCrops) {
          return ListView.builder(
            itemCount: allCrops.length,
            itemBuilder: (context, index) {
              // The UI is now highly modular and readable
              return CropListTile(
                crop: allCrops[index],
                currentTime: now,
              );
            },
          );
        },
      ),
    );
  }
}