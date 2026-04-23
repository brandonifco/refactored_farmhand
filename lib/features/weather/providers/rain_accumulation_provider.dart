import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/weather_api.dart';
import '../services/rain_tabulator_service.dart';

// State class to hold both the date and the accumulation total
class RainTabulatorState {
  final DateTime startDate;
  final double totalAccumulation;

  RainTabulatorState({required this.startDate, required this.totalAccumulation});
}

// Global instances of our services
final _weatherApi = WeatherApi();
final _rainService = RainTabulatorService();

// The provider your UI will listen to
final rainAccumulationProvider = AsyncNotifierProvider<RainAccumulationNotifier, RainTabulatorState>(() {
  return RainAccumulationNotifier();
});

class RainAccumulationNotifier extends AsyncNotifier<RainTabulatorState> {
  @override
  FutureOr<RainTabulatorState> build() async {
    // 1. Get the saved start date from Hive
    final startDate = _rainService.getStartDate();
    
    // 2. Fetch the accumulation from that date to today
    final accumulation = await _weatherApi.fetchAccumulationSince(startDate);
    
    // 3. Return the combined state
    return RainTabulatorState(
      startDate: startDate,
      totalAccumulation: accumulation,
    );
  }

  // The UI will call this when the user picks a new date
  Future<void> updateStartDate(DateTime newDate) async {
    // Set UI to loading state while the API loops through the days
    state = const AsyncValue.loading();
    
    state = await AsyncValue.guard(() async {
      // 1. Save the new date to Hive
      await _rainService.setStartDate(newDate);
      
      // 2. Fetch the new accumulation data
      final accumulation = await _weatherApi.fetchAccumulationSince(newDate);
      
      // 3. Return the new combined state
      return RainTabulatorState(
        startDate: newDate,
        totalAccumulation: accumulation,
      );
    });
  }
}