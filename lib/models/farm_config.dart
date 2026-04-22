class FarmConfig {
  final String farmName;
  final String location;
  final String hardinessZone;
  final String lastFrostDate;
  final String firstFrostDate;
  final double lat; // Add this
  final double lon; // Add this

  FarmConfig({
    this.farmName = 'The Farm',
    this.location = 'Bethel Township, OH',
    this.hardinessZone = '6b',
    this.lastFrostDate = '2026-05-10',
    this.firstFrostDate = '2026-10-15',
    this.lat = 39.9614, // Default to Bethel Township
    this.lon = -84.0624,
  });

  // Convert from JSON
  factory FarmConfig.fromJson(Map<String, dynamic> json) {
    return FarmConfig(
      farmName: json['farmName'] ?? 'The Farm',
      location: json['location'] ?? 'Bethel Township, OH',
      hardinessZone: json['hardinessZone'] ?? '6b',
      lastFrostDate: json['lastFrostDate'] ?? '2026-05-10',
      firstFrostDate: json['firstFrostDate'] ?? '2026-10-15',
      // Convert JSON strings to doubles safely
      lat: double.tryParse(json['lat'].toString()) ?? 39.9614,
      lon: double.tryParse(json['lon'].toString()) ?? -84.0624,
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
      'lat': lat.toString(), // Store as string to match your current JSON format
      'lon': lon.toString(),
    };
  }

  // Helper to update specific fields without rewriting everything
  FarmConfig copyWith({
    String? farmName,
    String? location,
    String? hardinessZone,
    String? lastFrostDate,
    String? firstFrostDate,
    double? lat,
    double? lon,
  }) {
    return FarmConfig(
      farmName: farmName ?? this.farmName,
      location: location ?? this.location,
      hardinessZone: hardinessZone ?? this.hardinessZone,
      lastFrostDate: lastFrostDate ?? this.lastFrostDate,
      firstFrostDate: firstFrostDate ?? this.firstFrostDate,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
    );
  }
}