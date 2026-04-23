import 'package:hive_ce_flutter/hive_ce_flutter.dart';

class RainTabulatorService {
  static const String _boxName = 'settings_box';
  static const String _startDateKey = 'rain_tabulator_start_date';

  // Retrieves the date. Defaults to the 1st of the current month if never set.
  DateTime getStartDate() {
    final box = Hive.box(_boxName);
    final int? milliseconds = box.get(_startDateKey);
    
    if (milliseconds != null) {
      return DateTime.fromMillisecondsSinceEpoch(milliseconds);
    } else {
      final now = DateTime.now();
      return DateTime(now.year, now.month, 1);
    }
  }

  // Saves a new date
  Future<void> setStartDate(DateTime date) async {
    final box = Hive.box(_boxName);
    await box.put(_startDateKey, date.millisecondsSinceEpoch);
  }
}