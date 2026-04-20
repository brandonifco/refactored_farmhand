import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/crop.dart';
import '../../utils/theme_helper.dart';

class CropDetailView extends StatelessWidget {
  final Crop crop;

  const CropDetailView({super.key, required this.crop});

  @override
  Widget build(BuildContext context) {
    // Null safety checks for calculated dates
    final String startDate = crop.start != null
        ? "${crop.start!.month}/${crop.start!.day}"
        : "TBD";
    final String endDate = crop.end != null
        ? "${crop.end!.month}/${crop.end!.day}"
        : "TBD";
    final String harvestRange =
        (crop.harvestStart != null && crop.harvestEnd != null)
        ? "${DateFormat('MMM d').format(crop.harvestStart!)} - ${DateFormat('MMM d').format(crop.harvestEnd!)}"
        : "TBD";

    final hardinessColor = AppTheme.getHardinessColor(crop.hardiness);

    return Scaffold(
      appBar: AppBar(
        title: Text(crop.name),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Frost Resilience
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.ac_unit, color: hardinessColor),
                title: const Text(
                  'Frost Resilience',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${crop.hardiness.toUpperCase()} (Safe to ${crop.criticalTemp}°F)',
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: hardinessColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: hardinessColor),
                  ),
                  child: Text(
                    crop.hardiness,
                    style: TextStyle(
                      color: hardinessColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Cleaned up detail cards using a private helper method
            _DetailRow(
              icon: Icons.calendar_today,
              color: Colors.green,
              title: 'Planting Window',
              value: '$startDate to $endDate',
            ),
            const SizedBox(height: 10),
            _DetailRow(
              icon: Icons.shopping_basket,
              color: Colors.orange,
              title: 'Estimated Harvest',
              value: harvestRange,
            ),
            const SizedBox(height: 10),
            _DetailRow(
              icon: Icons.pan_tool,
              color: Colors.green,
              title: 'Method',
              value: crop.method,
            ),
            const SizedBox(height: 10),

            // Notes Card
            Card(
              color: Colors.green[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.green),
                        SizedBox(width: 10),
                        Text(
                          'Planting Tips',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      crop.notes,
                      style: const TextStyle(fontSize: 14, height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable private widget for standardizing the detail cards
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}
