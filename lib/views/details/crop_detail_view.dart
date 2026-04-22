import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/crop.dart';
import '../../utils/theme_helper.dart';

class CropDetailView extends StatelessWidget {
  final Crop crop;

  const CropDetailView({super.key, required this.crop});

  @override
  Widget build(BuildContext context) {
    // Calculated date formatting
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
            // 1. Primary Identity Header (Family & Hardiness)
            Row(
              children: [
                Expanded(
                  child: _HeaderStat(
                    label: 'Family',
                    value: crop.family,
                    icon: Icons.category,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _HeaderStat(
                    label: 'Succession',
                    value: crop.successionDays > 0 ? '${crop.successionDays} Days' : 'Single',
                    icon: Icons.repeat,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 2. Frost & Hardiness Card
            Card(
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
            ),
            const SizedBox(height: 10),

            // 3. Scheduling & Method
            _DetailRow(
              icon: Icons.calendar_today,
              color: Colors.blue,
              title: 'Planting Window',
              value: '$startDate to $endDate',
            ),
            _DetailRow(
              icon: Icons.shopping_basket,
              color: Colors.orange,
              title: 'Estimated Harvest',
              value: harvestRange,
            ),
            _DetailRow(
              icon: Icons.pan_tool,
              color: Colors.brown,
              title: 'Method',
              value: crop.method,
            ),
            
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 4.0),
              child: Text('Farm Management', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),

            // 4. Resource & Space Intensity
            Row(
              children: [
                Expanded(
                  child: _ResourceCard(
                    title: 'Water',
                    icon: Icons.water_drop,
                    color: Colors.blue,
                    content: 'Level ${crop.waterIntensity}/5',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ResourceCard(
                    title: 'Space',
                    icon: Icons.square_foot,
                    color: Colors.blueGrey,
                    content: '${crop.spaceRequired} sq ft',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ResourceCard(
                    title: 'GDD Base',
                    icon: Icons.thermostat,
                    color: Colors.redAccent,
                    content: '${crop.gddBase}°F',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 5. Traits & Ecological Tags
            if (crop.traits.isNotEmpty) ...[
              const Text('Ecological Traits', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: crop.traits.entries.map((entry) {
                  return Chip(
                    label: Text('${entry.key}: ${entry.value}', style: const TextStyle(fontSize: 12)),
                    backgroundColor: Colors.green[50],
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],

            // 6. Planting Tips
            Card(
              color: Colors.green[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: Colors.green),
                        SizedBox(width: 10),
                        Text('Planting Tips', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(crop.notes, style: const TextStyle(fontSize: 14, height: 1.4)),
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

// --- Internal Helper Widgets ---

class _HeaderStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _HeaderStat({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: Colors.green[800]),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}

class _ResourceCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String content;

  const _ResourceCard({required this.title, required this.icon, required this.color, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: color.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
          side: BorderSide(color: color.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500)),
            Text(content, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String value;

  const _DetailRow({required this.icon, required this.color, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontSize: 13)),
        subtitle: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
      ),
    );
  }
}