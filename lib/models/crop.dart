import 'package:hive_ce/hive.dart'; // Add this

part 'crop.g.dart'; // Add this

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

  // --- NEW: Management & Logic Fields ---
  @HiveField(10) final String family;        // e.g., 'Nightshade', 'Brassica'
  @HiveField(11) final int gddBase;          // e.g., 50 for warm, 40 for cool
  @HiveField(12) final int waterIntensity;   // 1 (Drought tolerant) to 5 (Heavy)
  @HiveField(13) final double spaceRequired; // Sq Ft per plant
  @HiveField(14) final int successionDays;   // 0 if single crop, 7-21 for successions
  
  // A flexible map for regenerative "tags" (Companions, Nutrients, Sun)
  @HiveField(15) final Map<String, String> traits;

  // Calculated fields
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

  factory Crop.fromJson(Map<String, dynamic> json) {
    return Crop(
      name: json['name'],
      hardiness: json['hardiness'] ?? 'Unknown',
      criticalTemp: json['criticalTemp'] is int
          ? json['criticalTemp']
          : int.tryParse(json['criticalTemp'].toString()) ?? 32,
      pivot: json['pivot'],
      relativeStart: json['relativeStart'],
      relativeEnd: json['relativeEnd'],
      daysToHarvest: json['daysToHarvest'],
      method: json['method'],
      notes: json['notes'],
    );
  }

  // Creates a new Crop with calculated dates based on the active config
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

  // Standard immutable update pattern
  Crop copyWith({
    bool? isSelected,
    DateTime? start,
    DateTime? end,
    DateTime? harvestStart,
    DateTime? harvestEnd,
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
      start: start ?? this.start,
      end: end ?? this.end,
      harvestStart: harvestStart ?? this.harvestStart,
      harvestEnd: harvestEnd ?? this.harvestEnd,
    );
  }

  String getStatus(DateTime projectionDate) {
    if (start == null || end == null) return "Unknown";
    if (projectionDate.isBefore(start!)) return "Upcoming";
    if (projectionDate.isAfter(end!)) return "Past";
    return "Active";
  }
}
