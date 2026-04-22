import 'package:flutter/material.dart';

class AppTheme {
  static Color getStatusColor(String status) {
    switch (status) {
      case 'Active': return Colors.green;
      case 'Upcoming': return Colors.blue;
      case 'Past': return Colors.orange;
      default: return Colors.grey;
    }
  }

  static Color getHardinessColor(String hardiness) {
    switch (hardiness.toLowerCase()) {
      case 'very tender': return Colors.red[700]!;
      case 'tender': return Colors.orange[700]!;
      case 'half-hardy': return Colors.blue[600]!;
      case 'hardy': return Colors.green[700]!;
      case 'extremely hardy': return Colors.purple[700]!;
      default: return Colors.grey;
    }
  }
}