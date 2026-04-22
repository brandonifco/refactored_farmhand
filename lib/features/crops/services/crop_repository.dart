import 'dart:convert';
import 'dart:developer' as dev;
import 'package:flutter/services.dart';
import 'package:hive_ce/hive.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Required for versioning
import '../models/crop.dart';

class CropRepository {
  final Box<Crop> _box = Hive.box<Crop>('crops_box');

  // FOOLPROOF VERSIONING: Increment this number when you change crops.json
  static const int _currentSchemaVersion = 4; 
  static const String _schemaKey = 'farm_data_schema_version';

  /// Loads the raw list of crops from the JSON asset and sanitizes types
  Future<List<Crop>> loadRawCrops() async {
    final String response = await rootBundle.loadString('assets/crops.json');
    final List<dynamic> data = json.decode(response);
    
    return data.map((item) {
      int parseInt(dynamic value, int defaultValue) {
        if (value == null) return defaultValue;
        return int.tryParse(value.toString()) ?? defaultValue;
      }

      double parseDouble(dynamic value, double defaultValue) {
        if (value == null) return defaultValue;
        return double.tryParse(value.toString()) ?? defaultValue;
      }

      Map<String, String> parseTraits(dynamic traitData) {
        if (traitData == null || traitData.toString().isEmpty) return {};
        Map<String, String> traitMap = {};
        try {
          List<String> pairs = traitData.toString().split(',');
          for (var pair in pairs) {
            List<String> kv = pair.split(':');
            if (kv.length == 2) {
              traitMap[kv[0].trim()] = kv[1].trim();
            }
          }
        } catch (_) {}
        return traitMap;
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
        family: item['family'] ?? 'Unknown',
        gddBase: parseInt(item['gddBase'] ?? item['gddbase'], 45),
        waterIntensity: parseInt(item['waterIntensity'] ?? item['waterintensity'], 3),
        spaceRequired: parseDouble(item['spaceRequired'] ?? item['spacerequired'], 1.0),
        successionDays: parseInt(item['successionDays'] ?? item['successiondays'], 0),
        traits: parseTraits(item['traits']),
        quantity: 0, 
        isPlanted: false,
      );
    }).toList();
  }

  /// The main entry point for the Dashboard
  Future<List<Crop>> getAllCrops() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // 1. Get the version currently stored in the browser/phone
    int lastSeenVersion = prefs.getInt(_schemaKey) ?? 0;

    // 2. Migration Check: If app version is newer, wipe the old data
    if (lastSeenVersion < _currentSchemaVersion) {
      dev.log("MIGRATION: Schema version $lastSeenVersion is old. Wiping Hive and updating to $_currentSchemaVersion.");
      await _box.clear();
      // Update the version in storage so we don't wipe next time
      await prefs.setInt(_schemaKey, _currentSchemaVersion);
    }

    // 3. Normal Loading: Only seed if the box was just wiped or is new
    if (_box.isEmpty) {
      final rawCrops = await loadRawCrops();
      final Map<String, Crop> cropMap = {
        for (var crop in rawCrops) crop.name: crop
      };
      await _box.putAll(cropMap);
      dev.log("SEEDING: Hive populated with ${rawCrops.length} crops.");
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