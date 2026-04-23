import 'package:flutter/material.dart';
import '../../models/crop.dart';
import '../../../../../shared/components/detail_widgets.dart';

class PlantingSchedule extends StatelessWidget {
  final Crop crop;
  final String startDate;
  final String endDate;
  final String harvestRange;

  const PlantingSchedule({
    super.key,
    required this.crop,
    required this.startDate,
    required this.endDate,
    required this.harvestRange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DetailRow(
          icon: Icons.calendar_today,
          color: Colors.blue,
          title: 'Planting Window',
          value: '$startDate to $endDate',
        ),
        DetailRow(
          icon: Icons.shopping_basket,
          color: Colors.orange,
          title: 'Estimated Harvest',
          value: harvestRange,
        ),
        DetailRow(
          icon: Icons.pan_tool,
          color: Colors.brown,
          title: 'Method',
          value: crop.method,
        ),
      ],
    );
  }
}