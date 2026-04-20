import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/farm_config.dart';
import '../services/storage/config_service.dart';

// Create a global instance of the service
final _configService = ConfigService();

// This is the actual Provider you will use in your UI
final configProvider = AsyncNotifierProvider<ConfigNotifier, FarmConfig>(() {
  return ConfigNotifier();
});

class ConfigNotifier extends AsyncNotifier<FarmConfig> {
  @override
  FutureOr<FarmConfig> build() async {
    // This runs automatically when the app starts
    return await _configService.loadConfig();
  }

  // The UI calls this method to save new data
  Future<void> updateSettings({
    required String name,
    required String location,
    required String zone,
  }) async {
    // 1. Set state to "loading" so the UI can show a spinner if it wants
    state = const AsyncValue.loading();

    // 2. Wrap the update in a guard to handle errors automatically
    state = await AsyncValue.guard(() async {
      // Look up the frost dates for the newly selected zone
      final frostDates = await _configService.getFrostDatesForZone(zone);
      
      // Create the updated config object
      final newConfig = FarmConfig(
        farmName: name,
        location: location,
        hardinessZone: zone,
        lastFrostDate: frostDates['lastFrost']!,
        firstFrostDate: frostDates['firstFrost']!,
      );

      // Save to disk
      await _configService.saveConfig(newConfig);

      // Return the new config, which automatically updates the UI
      return newConfig;
    });
  }
}