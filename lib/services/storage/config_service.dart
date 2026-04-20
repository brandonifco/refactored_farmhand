import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/farm_config.dart';
import '../../utils/constants.dart';

class ConfigService {
  // Load config from disk or fallback to defaults
  Future<FarmConfig> loadConfig() async {
    String? rawJson;

    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      rawJson = prefs.getString(AppConstants.configWebKey);
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/${AppConstants.configFileName}');
      if (await file.exists()) {
        rawJson = await file.readAsString();
      }
    }

    if (rawJson != null) {
      return FarmConfig.fromJson(json.decode(rawJson));
    }

    // Fallback if no local config exists
    return FarmConfig(); 
  }

  // Save config to disk
  Future<void> saveConfig(FarmConfig config) async {
    final String jsonString = json.encode(config.toJson());

    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.configWebKey, jsonString);
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/${AppConstants.configFileName}');
      await file.writeAsString(jsonString);
    }
  }

  // Look up frost dates from zones.json
  Future<Map<String, String>> getFrostDatesForZone(String zone) async {
    final String zoneDataString = await rootBundle.loadString('assets/zones.json');
    final Map<String, dynamic> zoneMap = json.decode(zoneDataString);
    
    if (zoneMap.containsKey(zone)) {
      return {
        'lastFrost': zoneMap[zone]['lastFrost'],
        'firstFrost': zoneMap[zone]['firstFrost'],
      };
    }
    // Safe default if zone isn't found
    return {'lastFrost': '2026-05-10', 'firstFrost': '2026-10-15'};
  }
}