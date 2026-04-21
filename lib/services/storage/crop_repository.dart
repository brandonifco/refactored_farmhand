import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive_ce/hive.dart'; // Add this
import '../../models/crop.dart';

class CropRepository {
  // Access the box we opened in main.dart
  final Box<Crop> _box = Hive.box<Crop>('crops_box');

  /// Loads the raw list of crops from the JSON asset
  Future<List<Crop>> loadRawCrops() async {
    final String response = await rootBundle.loadString('assets/crops.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Crop.fromJson(json)).toList();
  }

  /// The main entry point for the Provider: 
  /// Returns saved crops if they exist, otherwise seeds from JSON.
  Future<List<Crop>> getAllCrops() async {
    if (_box.isEmpty) {
      final rawCrops = await loadRawCrops();
      // Use the crop name as the unique key in the box
      final Map<String, Crop> cropMap = {
        for (var crop in rawCrops) crop.name: crop
      };
      await _box.putAll(cropMap);
    }
    return _box.values.toList();
  }

  /// Updates a single crop (e.g., toggling isSelected or adding notes)
  Future<void> updateCrop(Crop crop) async {
    await _box.put(crop.name, crop);
  }

  /// Optional: Saves an entire list at once
  Future<void> saveAllCrops(List<Crop> crops) async {
    final Map<String, Crop> cropMap = {
      for (var crop in crops) crop.name: crop
    };
    await _box.putAll(cropMap);
  }
}