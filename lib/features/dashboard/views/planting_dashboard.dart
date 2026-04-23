import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../settings/providers/config_provider.dart';
import '../../weather/providers/weather_provider.dart';
import '../../crops/views/crop_full_list.dart';
import '../../settings/views/settings_view.dart';
import '../../weather/views/weather_summary_card.dart';
import '../../weather/views/rain_tabulator_card.dart'; // 1. Added import
import '../components/today_planting_list.dart';
import '../../weather/providers/rain_accumulation_provider.dart';

class PlantingDashboard extends ConsumerWidget {
  const PlantingDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the config to get the Farm Name
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
              ref.read(weatherProvider.notifier).refreshWeather();
              // Also refresh the rain tabulator when hitting the global refresh
              ref.read(rainAccumulationProvider.notifier).updateStartDate(
                ref.read(rainAccumulationProvider).value?.startDate ?? DateTime.now()
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.format_list_bulleted),
            tooltip: 'Crops List',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FullCropsList()),
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
          const RainTabulatorCard(), // 2. Inserted the new card here
          const Padding(
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Text(
              'Planting Priority', 
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