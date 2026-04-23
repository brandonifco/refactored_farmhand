import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/rain_accumulation_provider.dart';

class RainTabulatorCard extends ConsumerWidget {
  const RainTabulatorCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rainState = ref.watch(rainAccumulationProvider);

    return rainState.when(
      data: (data) {
        // Shorter date format, e.g., 4/1/26
        final dateStr = '${data.startDate.month}/${data.startDate.day}/${data.startDate.year % 100}';
        
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.water_drop, size: 18, color: Colors.blueAccent),
                  const SizedBox(width: 8),
                  Text(
                    'Rain since $dateStr: ',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  Text(
                    '${data.totalAccumulation.toStringAsFixed(2)} in',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.edit_calendar, size: 20, color: Colors.grey),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(), // Removes default IconButton padding
                tooltip: 'Change Start Date',
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: data.startDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (selectedDate != null) {
                    ref.read(rainAccumulationProvider.notifier).updateStartDate(selectedDate);
                  }
                },
              ),
            ],
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Center(
          child: SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2)),
        ),
      ),
      error: (error, stack) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Text('Error: $error', style: const TextStyle(color: Colors.red, fontSize: 12)),
      ),
    );
  }
}