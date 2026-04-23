import 'package:flutter/material.dart';
import 'package:planting_calendar_2/features/crops/models/crop.dart'; // Use package path
import 'package:planting_calendar_2/shared/components/detail_widgets.dart';

class CropResources extends StatelessWidget {
  final Crop crop;
  const CropResources({super.key, required this.crop});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ResourceCard(
            title: 'Water',
            icon: Icons.water_drop,
            color: Colors.blue,
            content: 'Level ${crop.waterIntensity}/5',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ResourceCard(
            title: 'Space',
            icon: Icons.square_foot,
            color: Colors.blueGrey,
            content: '${crop.spaceRequired} sq ft',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ResourceCard(
            title: 'GDD Base',
            icon: Icons.thermostat,
            color: Colors.redAccent,
            content: '${crop.gddBase}°F',
          ),
        ),
      ],
    );
  }
}