import 'package:flutter/material.dart';

class CropTraitsTagStack extends StatelessWidget {
  final Map<String, String> traits;

  const CropTraitsTagStack({super.key, required this.traits});

  @override
  Widget build(BuildContext context) {
    if (traits.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ecological Traits', 
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: traits.entries.map((entry) {
            return Chip(
              label: Text(
                '${entry.key}: ${entry.value}', 
                style: const TextStyle(fontSize: 12)
              ),
              backgroundColor: Colors.green[50],
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}