import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/crop.dart';
import '../services/storage/crop_repository.dart';
import 'config_provider.dart';

// Provides the repository
final cropRepositoryProvider = Provider((ref) => CropRepository());

// The main provider the UI listens to for the list of crops
final plantingProvider = AsyncNotifierProvider<PlantingNotifier, List<Crop>>(() {
  return PlantingNotifier();
});

class PlantingNotifier extends AsyncNotifier<List<Crop>> {
  @override
  FutureOr<List<Crop>> build() async {
    // 1. Wait for the configuration to load (gives us the active frost dates)
    final config = await ref.watch(configProvider.future);
    final repo = ref.read(cropRepositoryProvider);

    // 2. Load the raw crops and the user's saved selections
    final rawCrops = await repo.loadRawCrops();
    final selectedNames = await repo.getSelectedCropNames();

    // 3. Parse the dates from the config
    final lastFrost = DateTime.parse(config.lastFrostDate);
    final firstFrost = DateTime.parse(config.firstFrostDate);

    // 4. Map the raw data into calculated, state-aware models
    return rawCrops.map((crop) {
      final isSelected = selectedNames.contains(crop.name);
      // Calculate dates and set the selection state
      return crop
          .withCalculatedDates(lastFrost, firstFrost)
          .copyWith(isSelected: isSelected);
    }).toList();
  }

  // The UI calls this to check/uncheck a crop on the calendar
  Future<void> toggleCropSelection(String cropName, bool isSelected) async {
    final repo = ref.read(cropRepositoryProvider);
    
    // 1. Get the current list of names
    final selectedNames = await repo.getSelectedCropNames();
    
    // 2. Add or remove the name
    if (isSelected && !selectedNames.contains(cropName)) {
      selectedNames.add(cropName);
    } else if (!isSelected) {
      selectedNames.remove(cropName);
    }
    
    // 3. Save to disk
    await repo.saveSelectedCropNames(selectedNames);
    
    // 4. Update the in-memory state so the UI redraws instantly
    if (state.hasValue) {
      final currentCrops = state.value!;
      state = AsyncValue.data([
        for (final crop in currentCrops)
          if (crop.name == cropName)
            crop.copyWith(isSelected: isSelected)
          else
            crop
      ]);
    }
  }
}