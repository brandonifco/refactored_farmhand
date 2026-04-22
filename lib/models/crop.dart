import 'package:hive_ce/hive.dart';

part 'crop.g.dart';

@HiveType(typeId: 0)
class Crop {
  @HiveField(0) final String name;
  @HiveField(1) final String hardiness;
  @HiveField(2) final int criticalTemp;
  @HiveField(3) final String pivot; // 'spring' or 'fall'
  @HiveField(4) final int relativeStart;
  @HiveField(5) final int relativeEnd;
  @HiveField(6) final int daysToHarvest;
  @HiveField(7) final String method;
  @HiveField(8) final String notes;
  @HiveField(9) final bool isSelected;

  // --- Management & Logic Fields ---
  @HiveField(10) final String family;
  @HiveField(11) final int gddBase;
  @HiveField(12) final int waterIntensity;
  @HiveField(13) final double spaceRequired;
  @HiveField(14) final int successionDays;
  @HiveField(15) final Map<String, String> traits;

  // Calculated fields (Not stored in Hive)
  final DateTime? start;
  final DateTime? end;
  final DateTime? harvestStart;
  final DateTime? harvestEnd;

  Crop({
    required this.name,
    required this.hardiness,
    required this.criticalTemp,
    required this.pivot,
    required this.relativeStart,
    required this.relativeEnd,
    required this.daysToHarvest,
    required this.method,
    required this.notes,
    this.isSelected = false,
    this.family = 'Unknown',
    this.gddBase = 45,
    this.waterIntensity = 3,
    this.spaceRequired = 1.0,
    this.successionDays = 0,
    this.traits = const {},
    this.start,
    this.end,
    this.harvestStart,
    this.harvestEnd,
  });

  // Updated copyWith to prevent data loss during updates
  Crop copyWith({
    bool? isSelected,
    DateTime? start,
    DateTime? end,
    DateTime? harvestStart,
    DateTime? harvestEnd,
    String? family,
    int? gddBase,
    int? waterIntensity,
    double? spaceRequired,
    int? successionDays,
    Map<String, String>? traits,
  }) {
    return Crop(
      name: name,
      hardiness: hardiness,
      criticalTemp: criticalTemp,
      pivot: pivot,
      relativeStart: relativeStart,
      relativeEnd: relativeEnd,
      daysToHarvest: daysToHarvest,
      method: method,
      notes: notes,
      isSelected: isSelected ?? this.isSelected,
      family: family ?? this.family,
      gddBase: gddBase ?? this.gddBase,
      waterIntensity: waterIntensity ?? this.waterIntensity,
      spaceRequired: spaceRequired ?? this.spaceRequired,
      successionDays: successionDays ?? this.successionDays,
      traits: traits ?? this.traits,
      start: start ?? this.start,
      end: end ?? this.end,
      harvestStart: harvestStart ?? this.harvestStart,
      harvestEnd: harvestEnd ?? this.harvestEnd,
    );
  }

  // Helper for date calculations
  Crop withCalculatedDates(DateTime lastFrost, DateTime firstFrost) {
    DateTime anchor = (pivot == 'spring') ? lastFrost : firstFrost;
    DateTime calcStart = anchor.add(Duration(days: relativeStart));
    DateTime calcEnd = anchor.add(Duration(days: relativeEnd));

    return copyWith(
      start: calcStart,
      end: calcEnd,
      harvestStart: calcStart.add(Duration(days: daysToHarvest)),
      harvestEnd: calcEnd.add(Duration(days: daysToHarvest)),
    );
  }

  String getStatus(DateTime projectionDate) {
    if (start == null || end == null) return "Unknown";
    if (projectionDate.isBefore(start!)) return "Upcoming";
    if (projectionDate.isAfter(end!)) return "Past";
    return "Active";
  }
}