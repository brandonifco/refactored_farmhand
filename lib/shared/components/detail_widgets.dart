import 'package:flutter/material.dart';

/// A compact, stylized stat box for the top of detail views.
class HeaderStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const HeaderStat({
    super.key, 
    required this.label, 
    required this.value, 
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // Standardizing on theme data for scalability
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: theme.primaryColor),
          const SizedBox(height: 4),
          Text(
            label, 
            style: theme.textTheme.labelSmall?.copyWith(color: theme.hintColor),
          ),
          Text(
            value, 
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

/// A specialized card for resource-specific data (Water, Space, GDD).
class ResourceCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String content;

  const ResourceCard({
    super.key, 
    required this.title, 
    required this.icon, 
    required this.color, 
    required this.content,
  });

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
            Text(
              title, 
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
            ),
            Text(
              content, 
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

/// A standardized row for list-style details.
class DetailRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String value;
  final Widget? trailing; // Added for scalability

  const DetailRow({
    super.key, 
    required this.icon, 
    required this.color, 
    required this.title, 
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontSize: 13)),
        subtitle: Text(
          value, 
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        trailing: trailing,
      ),
    );
  }
}