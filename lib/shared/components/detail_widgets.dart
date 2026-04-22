// lib/components/detail_widgets.dart
import 'package:flutter/material.dart';

class HeaderStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const HeaderStat({super.key, required this.label, required this.value, required this.icon});

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

class ResourceCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String content;

  const ResourceCard({super.key, required this.title, required this.icon, required this.color, required this.content});

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

class DetailRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String value;

  const DetailRow({super.key, required this.icon, required this.color, required this.title, required this.value});

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