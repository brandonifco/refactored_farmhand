import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/planting_provider.dart';
import '../../utils/theme_helper.dart';
import '../details/crop_detail_view.dart';

class FullCalendarView extends ConsumerWidget {
  const FullCalendarView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the master list of crops
    final plantingState = ref.watch(plantingProvider);
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Full 2026 Season'),
        backgroundColor: Colors.blueGrey[700],
        foregroundColor: Colors.white,
      ),
      // Handle the loading/error/data states natively
      body: plantingState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
        data: (allCrops) {
          return ListView.builder(
            itemCount: allCrops.length,
            itemBuilder: (context, index) {
              final crop = allCrops[index];
              final status = crop.getStatus(now);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: Checkbox(
                    activeColor: Colors.green[700],
                    value: crop.isSelected,
                    onChanged: (value) {
                      // Fire a command to the provider. No local state needed!
                      ref.read(plantingProvider.notifier)
                         .toggleCropSelection(crop.name, value ?? false);
                    },
                  ),
                  title: Text(crop.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Window: ${crop.start?.month}/${crop.start?.day} - ${crop.end?.month}/${crop.end?.day}'),
                  trailing: Chip(
                    label: Text(status, style: const TextStyle(color: Colors.white, fontSize: 12)),
                    backgroundColor: AppTheme.getStatusColor(status),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CropDetailView(crop: crop)),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}