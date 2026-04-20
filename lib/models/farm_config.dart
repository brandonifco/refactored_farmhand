class FarmConfig {
  final String farmName;
  final String location;
  final String hardinessZone;
  final String lastFrostDate;
  final String firstFrostDate;

  FarmConfig({
    this.farmName = 'The Farm',
    this.location = 'Bethel Township, OH',
    this.hardinessZone = '6b',
    this.lastFrostDate = '2026-05-10',
    this.firstFrostDate = '2026-10-15',
  });

  // Convert from JSON
  factory FarmConfig.fromJson(Map<String, dynamic> json) {
    return FarmConfig(
      farmName: json['farmName'] ?? 'The Farm',
      location: json['location'] ?? 'Bethel Township, OH',
      hardinessZone: json['hardinessZone'] ?? '6b',
      lastFrostDate: json['lastFrostDate'] ?? '2026-05-10',
      firstFrostDate: json['firstFrostDate'] ?? '2026-10-15',
    );
  }

  // Convert to JSON for saving
  Map<String, dynamic> toJson() {
    return {
      'farmName': farmName,
      'location': location,
      'hardinessZone': hardinessZone,
      'lastFrostDate': lastFrostDate,
      'firstFrostDate': firstFrostDate,
    };
  }

  // Helper to update specific fields without rewriting everything
  FarmConfig copyWith({
    String? farmName,
    String? location,
    String? hardinessZone,
    String? lastFrostDate,
    String? firstFrostDate,
  }) {
    return FarmConfig(
      farmName: farmName ?? this.farmName,
      location: location ?? this.location,
      hardinessZone: hardinessZone ?? this.hardinessZone,
      lastFrostDate: lastFrostDate ?? this.lastFrostDate,
      firstFrostDate: firstFrostDate ?? this.firstFrostDate,
    );
  }
}