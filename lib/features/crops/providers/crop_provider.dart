import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/crop.dart';
import '../services/crop_repository.dart';
import '../../settings/providers/config_provider.dart';

// Provides the repository instance
final cropRepositoryProvider = Provider((ref) => CropRepository());

// The main provider for the Full Calendar (Alphabetical by default)
final plantingProvider = AsyncNotifierProvider<PlantingNotifier, List<Crop>>(() {
  return PlantingNotifier();
});

class PlantingNotifier extends AsyncNotifier<List<Crop>> {
  @override
  FutureOr<List<Crop>> build() async {
    // 1. Wait for the configuration to load (gives us the active frost dates)
    final config = await ref.watch(configProvider.future);
    final repo = ref.read(cropRepositoryProvider);

    // 2. Load crops from Hive (handles seeding from JSON if Hive is empty)
    final cropsFromStorage = await repo.getAllCrops();

    // 3. Parse the dates from the config
    final lastFrost = DateTime.parse(config.lastFrostDate);
    final firstFrost = DateTime.parse(config.firstFrostDate);

    // 4. Map the stored data into calculated models
    final list = cropsFromStorage.map((crop) {
      return crop.withCalculatedDates(lastFrost, firstFrost);
    }).toList();

    // 5. Default Sort: Alphabetical for the Full Calendar View
    list.sort((a, b) => a.name.compareTo(b.name));

    return list;
  }
/// Updates the numerical quantity for a specific crop and persists to Hive
  Future<void> updateCropQuantity(String cropName, int quantity) async {
    if (!state.hasValue) return;

    final repo = ref.read(cropRepositoryProvider);
    final currentCrops = state.value!;

    // 1. Find the crop and update its quantity
    final updatedCrops = currentCrops.map((crop) {
      if (crop.name == cropName) {
        final updatedCrop = crop.copyWith(quantity: quantity);
        
        // 2. Persist the change to Hive
        repo.updateCrop(updatedCrop);
        
        return updatedCrop;
      }
      return crop;
    }).toList();

    // 3. Update the in-memory state for UI reactivity
    state = AsyncValue.data(updatedCrops);
  }
  /// Toggles the isPlanted status for a specific crop and persists to Hive
  Future<void> togglePlantedStatus(String cropName, bool isPlanted) async {
    if (!state.hasValue) return;

    final repo = ref.read(cropRepositoryProvider);
    final currentCrops = state.value!;

    final updatedCrops = currentCrops.map((crop) {
      if (crop.name == cropName) {
        // Automatically set the date to NOW if true, or NULL if unchecked
        final updatedCrop = crop.copyWith(
          isPlanted: isPlanted,
          datePlanted: isPlanted ? DateTime.now() : null,
        );
        
        repo.updateCrop(updatedCrop);
        return updatedCrop;
      }
      return crop;
    }).toList();

    state = AsyncValue.data(updatedCrops);
  }
  // The UI calls this to check/uncheck a crop
  Future<void> toggleCropSelection(String cropName, bool isSelected) async {
    if (!state.hasValue) return;

    final repo = ref.read(cropRepositoryProvider);
    final currentCrops = state.value!;

    // 1. Find the crop and update its state
    final updatedCrops = currentCrops.map((crop) {
      if (crop.name == cropName) {
        final updatedCrop = crop.copyWith(isSelected: isSelected);
        
        // 2. Persist the individual change to Hive instantly
        repo.updateCrop(updatedCrop);
        
        return updatedCrop;
      }
      return crop;
    }).toList();

    // 3. Update the in-memory state so the UI redraws
    state = AsyncValue.data(updatedCrops);
  }
}

/// Specialized provider for the Dashboard.
/// Watches [plantingProvider] and sorts by:
/// 1. Selected crops first.
/// 2. Chronological planting order (start date).
final dashboardCropsProvider = Provider<AsyncValue<List<Crop>>>((ref) {
  final cropsAsync = ref.watch(plantingProvider);

  return cropsAsync.whenData((crops) {
    // Create a copy to avoid mutating the base provider's list
    final sortedList = List<Crop>.from(crops);

    sortedList.sort((a, b) {
      // Priority 1: Selection status
      if (a.isSelected != b.isSelected) {
        return a.isSelected ? -1 : 1;
      }
      
      // Priority 2: Planting Order (Chronological)
      if (a.start == null) return 1;
      if (b.start == null) return -1;
      return a.start!.compareTo(b.start!);
    });

    return sortedList;
  });
});