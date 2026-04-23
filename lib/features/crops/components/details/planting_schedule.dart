import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this for formatting
import '../../models/crop.dart';
import '../../../../../shared/components/detail_widgets.dart';

class PlantingSchedule extends StatelessWidget {
  final Crop crop;

  const PlantingSchedule({
    super.key,
    required this.crop,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Logic moved from the View to here
    final String startDate = crop.start != null
        ? DateFormat('MMM d').format(crop.start!)
        : "TBD";
    final String endDate = crop.end != null
        ? DateFormat('MMM d').format(crop.end!)
        : "TBD";
    final String harvestRange =
        (crop.harvestStart != null && crop.harvestEnd != null)
        ? "${DateFormat('MMM d').format(crop.harvestStart!)} - ${DateFormat('MMM d').format(crop.harvestEnd!)}"
        : "TBD";

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