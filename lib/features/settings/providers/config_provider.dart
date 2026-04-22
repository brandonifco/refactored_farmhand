import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/farm_config.dart';
import '../services/config_service.dart';

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
  required double lat,  // Add this
  required double lon,  // Add this
}) async {
  state = const AsyncValue.loading();

  state = await AsyncValue.guard(() async {
    final frostDates = await _configService.getFrostDatesForZone(zone);
    
    final newConfig = FarmConfig(
      farmName: name,
      location: location,
      hardinessZone: zone,
      lastFrostDate: frostDates['lastFrost']!,
      firstFrostDate: frostDates['firstFrost']!,
      lat: lat, // Add this
      lon: lon, // Add this
    );

    await _configService.saveConfig(newConfig);
    return newConfig;
  });
}
}