import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive_ce/hive.dart';
import '../../models/crop.dart';

class CropRepository {
  // Access the box we opened in main.dart
  final Box<Crop> _box = Hive.box<Crop>('crops_box');

  /// Loads the raw list of crops from the JSON asset and sanitizes types
  Future<List<Crop>> loadRawCrops() async {
    final String response = await rootBundle.loadString('assets/crops.json');
    final List<dynamic> data = json.decode(response);
    
    return data.map((item) {
      // Helper to safely parse integers from String or Num
      int parseInt(dynamic value, int defaultValue) {
        if (value == null) return defaultValue;
        return int.tryParse(value.toString()) ?? defaultValue;
      }

      // Helper to safely parse doubles (for spaceRequired)
      double parseDouble(dynamic value, double defaultValue) {
        if (value == null) return defaultValue;
        return double.tryParse(value.toString()) ?? defaultValue;
      }

      return Crop(
        name: item['name'],
        hardiness: item['hardiness'] ?? 'Unknown',
        criticalTemp: parseInt(item['criticalTemp'], 32),
        pivot: item['pivot'],
        relativeStart: parseInt(item['relativeStart'], 0),
        relativeEnd: parseInt(item['relativeEnd'], 0),
        daysToHarvest: parseInt(item['daysToHarvest'], 60),
        method: item['method'],
        notes: item['notes'] ?? '',
        isSelected: item['isSelected'] ?? false,
        // New Fields from your spreadsheet work
        family: item['family'] ?? 'Unknown',
        gddBase: parseInt(item['gddBase'], 45),
        waterIntensity: parseInt(item['waterIntensity'], 3),
        spaceRequired: parseDouble(item['spaceRequired'], 1.0),
        successionDays: parseInt(item['successionDays'], 0),
        // traits can be parsed from a string into a map if needed later, 
        // for now we'll pass an empty map or handle as string
        traits: {}, 
      );
    }).toList();
  }

  /// The main entry point: Returns saved crops or seeds from JSON.
  Future<List<Crop>> getAllCrops() async {
    // If you've updated your JSON and want to force a refresh of the Hive box,
    // you might want to temporarily clear the box: // await _box.clear();
    
    if (_box.isEmpty) {
      final rawCrops = await loadRawCrops();
      final Map<String, Crop> cropMap = {
        for (var crop in rawCrops) crop.name: crop
      };
      await _box.putAll(cropMap);
    }
    return _box.values.toList();
  }

  Future<void> updateCrop(Crop crop) async {
    await _box.put(crop.name, crop);
  }

  Future<void> saveAllCrops(List<Crop> crops) async {
    final Map<String, Crop> cropMap = {
      for (var crop in crops) crop.name: crop
    };
    await _box.putAll(cropMap);
  }
}