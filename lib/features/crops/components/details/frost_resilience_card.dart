import 'package:flutter/material.dart';
import '../../models/crop.dart';
import '../../../../shared/utils/theme_helper.dart';

class FrostResilienceCard extends StatelessWidget {
  final Crop crop;
  const FrostResilienceCard({super.key, required this.crop});

  @override
  Widget build(BuildContext context) {
    final hardinessColor = AppTheme.getHardinessColor(crop.hardiness);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.ac_unit, color: hardinessColor),
        title: const Text('Frost Resilience', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${crop.hardiness.toUpperCase()} (Safe to ${crop.criticalTemp}°F)'),
        trailing: Chip(
          label: Text(crop.hardiness, style: const TextStyle(fontSize: 10)),
          backgroundColor: hardinessColor.withValues(alpha: 0.1),
          side: BorderSide(color: hardinessColor),
        ),
      ),
    );
  }
}