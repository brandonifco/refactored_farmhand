import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/crop.dart';
import '../services/crop_repository.dart';
import '../../settings/providers/config_provider.dart';

// Provides the repository instance
final cropRepositoryProvider = Provider((ref) => CropRepository());

// The main provider for the Full Calendar (Alphabetical by default)
final plantingProvider = AsyncNotifierProvider<PlantingNotifier, List<Crop>>(
  () {
    return PlantingNotifier();
  },
);

class PlantingNotifier extends AsyncNotifier<List<Crop>> {
  @override
  FutureOr<List<Crop>> build() async {
    // 1. Wait for config and repository
    final config = await ref.watch(configProvider.future);
    final repo = ref.read(cropRepositoryProvider);

    // 2. Load raw data from Hive
    final cropsFromStorage = await repo.getAllCrops();

    // 3. Logic Isolation: Move parsing and calculation into a single map operation
    final lastFrost = DateTime.parse(config.lastFrostDate);
    final firstFrost = DateTime.parse(config.firstFrostDate);

    final list = cropsFromStorage.map((crop) {
      return crop.withCalculatedDates(lastFrost, firstFrost);
    }).toList();

    // 4. Isolation: Move sorting to a dedicated private helper
    return _applyDefaultSort(list);
  }

  // Private helper to keep the build pipeline clean
  List<Crop> _applyDefaultSort(List<Crop> list) {
    return list..sort((a, b) => a.name.compareTo(b.name));
  }

  /// Logic Isolation: Centralized handler for state updates and persistence
  Future<void> _updateCropState(
    String cropName,
    Crop Function(Crop) transform,
  ) async {
    if (!state.hasValue) return;

    final repo = ref.read(cropRepositoryProvider);
    final currentCrops = state.value!;

    final updatedList = currentCrops.map((crop) {
      if (crop.name == cropName) {
        final updatedCrop = transform(crop);
        repo.updateCrop(updatedCrop);
        return updatedCrop;
      }
      return crop;
    }).toList();

    state = AsyncValue.data(updatedList);
  }

  Future<void> updateCropQuantity(String cropName, int quantity) async {
    await _updateCropState(
      cropName,
      (crop) => crop.copyWith(quantity: quantity),
    );
  }

  Future<void> togglePlantedStatus(String cropName, bool isPlanted) async {
    await _updateCropState(
      cropName,
      (crop) => crop.copyWith(
        isPlanted: isPlanted,
        datePlanted: isPlanted ? DateTime.now() : null,
      ),
    );
  }

  Future<void> updatePlantingDate(String cropName, DateTime date) async {
    await _updateCropState(
      cropName,
      (crop) => crop.copyWith(isPlanted: true, datePlanted: date),
    );
  }

  Future<void> toggleCropSelection(String cropName, bool isSelected) async {
    await _updateCropState(
      cropName,
      (crop) => crop.copyWith(isSelected: isSelected),
    );
  }
} // <--- This is the end of the class

/// Specialized provider for the Dashboard.
final dashboardCropsProvider = Provider<AsyncValue<List<Crop>>>((ref) {
  final cropsAsync = ref.watch(plantingProvider);

  return cropsAsync.whenData((crops) {
    // Logic Isolation: The provider just watches data,
    // the helper function handles the business rules.
    return _sortCropsForDashboard(crops);
  });
});

/// Isolated Domain Logic: Defines how the Dashboard prioritizes crops
List<Crop> _sortCropsForDashboard(List<Crop> crops) {
  final sortedList = List<Crop>.from(crops);

  sortedList.sort((a, b) {
    // 1. Priority: Selection status
    if (a.isSelected != b.isSelected) {
      return a.isSelected ? -1 : 1;
    }

    // 2. Priority: Planting Order (Chronological)
    if (a.start == null) return 1;
    if (b.start == null) return -1;
    return a.start!.compareTo(b.start!);
  });

  return sortedList;
}
