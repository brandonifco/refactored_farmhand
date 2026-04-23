import 'package:flutter/material.dart';
import '../../models/crop.dart';
import '../../../../shared/components/detail_widgets.dart';

class CropDetailHeader extends StatelessWidget {
  final Crop crop;
  const CropDetailHeader({super.key, required this.crop});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: HeaderStat(
            label: 'Family',
            value: crop.family,
            icon: Icons.category,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: HeaderStat(
            label: 'Succession',
            value: crop.successionDays > 0 ? '${crop.successionDays} Days' : 'Single',
            icon: Icons.repeat,
          ),
        ),
      ],
    );
  }
}