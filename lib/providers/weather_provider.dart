import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/weather.dart';
import '../services/api/weather_api.dart';

// Global instance of our API client
final _weatherApi = WeatherApi();

// The provider your UI will listen to
final weatherProvider = AsyncNotifierProvider<WeatherNotifier, Weather?>(() {
  return WeatherNotifier();
});

class WeatherNotifier extends AsyncNotifier<Weather?> {
  @override
  FutureOr<Weather?> build() async {
    // Fetches automatically when the app loads or the dashboard is viewed
    return await _weatherApi.fetchCurrentWeather();
  }

  // The UI can call this when the user taps the "Refresh" button
  Future<void> refreshWeather() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _weatherApi.fetchCurrentWeather();
    });
  }
}