import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/weather_provider.dart';
import '../../settings/providers/config_provider.dart';

class WeatherSummaryCard extends ConsumerWidget {
  const WeatherSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to both the weather and the config (for location/zone data)
    final weatherState = ref.watch(weatherProvider);
    final configState = ref.watch(configProvider);
    final today = DateTime.now();

    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.green[50],
      child: weatherState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Text("Weather Unavailable: $err"),
        data: (weather) {
          if (weather == null) return const Text("Weather Unavailable");

          final config = configState.value;
          final location = config?.location ?? "Unknown";
          final zone = config?.hardinessZone ?? "Unknown";

          Color riskColor = weather.riskLevel.contains("Warning")
              ? Colors.red
              : weather.riskLevel.contains("Likely")
                  ? Colors.orange
                  : Colors.green;

          return Row(
            children: [
              Text(weather.iconEmoji, style: const TextStyle(fontSize: 40)),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('MMMM d, yyyy').format(today),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[900],
                      ),
                    ),
                    Text(
                      'Currently ${weather.temp.toStringAsFixed(0)}°F - ${weather.riskLevel}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: riskColor,
                      ),
                    ),
                    Text(
                      'High ${weather.high.toStringAsFixed(0)}°F @ ${weather.formattedHighTime}',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: riskColor),
                    ),
                    Text(
                      'Low ${weather.low.toStringAsFixed(0)}°F @ ${weather.formattedLowTime}',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: riskColor),
                    ),
                    Text('${weather.summary} • Wind: ${weather.wind}mph • Rain: ${weather.precipProb.toStringAsFixed(0)}%'),
                    Text('Accumulation ${weather.accum} in.'),
                    const SizedBox(height: 5),
                    Text(
                      '$location - Zone $zone',
                      style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}