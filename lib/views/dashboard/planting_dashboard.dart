import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/config_provider.dart';
import '../../providers/weather_provider.dart';
import '../calendar/full_calendar_view.dart';
import '../settings/settings_view.dart';
import 'widgets/weather_summary_card.dart';
import 'widgets/today_planting_list.dart';

class PlantingDashboard extends ConsumerWidget {
  const PlantingDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We only need the config here to get the Farm Name for the AppBar
    final configState = ref.watch(configProvider);
    final farmName = configState.value?.farmName ?? "Loading...";

    return Scaffold(
      appBar: AppBar(
        title: Text(farmName),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        actions: [
          // Refreshing is now a single line of code triggering the provider
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Weather',
            onPressed: () {
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
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WeatherSummaryCard(),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Planting Now',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: TodayPlantingList(),
          ),
        ],
      ),
    );
  }
}