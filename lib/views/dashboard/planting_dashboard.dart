import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/config_provider.dart';
import '../../providers/weather_provider.dart';
// Note: We use dashboardCropsProvider inside the sub-widgets (TodayPlantingList)
import '../calendar/full_calendar_view.dart';
import '../settings/settings_view.dart';
import 'widgets/weather_summary_card.dart';
import 'widgets/today_planting_list.dart';

class PlantingDashboard extends ConsumerWidget {
  const PlantingDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the config to get the Farm Name (e.g., your Bethel Township property name)
    final configState = ref.watch(configProvider);
    final farmName = configState.value?.farmName ?? "Loading...";

    return Scaffold(
      appBar: AppBar(
        title: Text(farmName),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Weather',
            onPressed: () {
              // Standard Riverpod refresh pattern
              ref.read(weatherProvider.notifier).refreshWeather();
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month),
            tooltip: 'Full Calendar',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FullCalendarView()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsView()),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WeatherSummaryCard(),
          const Padding(
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Text(
              'Planting Priority', // Renamed to reflect the new sorting logic
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const Expanded(
            child: TodayPlantingList(),
          ),
        ],
      ),
    );
  }
}