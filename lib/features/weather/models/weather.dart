class Weather {
  final double temp;
  final double high;
  final double low;
  final int highTimeUnix;
  final int lowTimeUnix;
  final double accum;
  final double wind;
  final double precipProb;
  final double dewPoint;
  final String summary;
  final String rawIcon;

  Weather({
    required this.temp,
    required this.high,
    required this.low,
    required this.highTimeUnix,
    required this.lowTimeUnix,
    required this.accum,
    required this.wind,
    required this.precipProb,
    required this.dewPoint,
    required this.summary,
    required this.rawIcon,
  });

  // Factory to safely parse the messy JSON from PirateWeather
  factory Weather.fromJson(Map<String, dynamic> json) {
    final current = json['currently'];
    final daily = json['daily']['data'][0];

    return Weather(
      temp: current['temperature'].toDouble(),
      high: daily['temperatureHigh'].toDouble(),
      low: daily['temperatureLow'].toDouble(),
      highTimeUnix: daily['temperatureHighTime'],
      lowTimeUnix: daily['temperatureLowTime'],
      accum: daily['precipAccumulation']?.toDouble() ?? 0.0,
      wind: current['windSpeed'].toDouble(),
      precipProb: current['precipProbability'].toDouble() * 100,
      dewPoint: current['dewPoint'].toDouble(),
      summary: current['summary'],
      rawIcon: current['icon'],
    );
  }

  // --- BUSINESS LOGIC & FORMATTING (Moved out of the UI) ---

  String get riskLevel {
    if (low <= 32) return "Freeze Warning";
    if (low <= 37 && wind < 5 && (low - dewPoint).abs() < 4) return "Frost Likely";
    if (low <= 40) return "Frost Watch";
    return "Low";
  }

  String get iconEmoji {
    switch (rawIcon) {
      case 'clear-day': return '☀️';
      case 'clear-night': return '🌙';
      case 'rain': return '🌧️';
      case 'snow': return '❄️';
      case 'cloudy': return '☁️';
      case 'partly-cloudy-day': return '⛅';
      default: return '🌡️';
    }
  }

  String _formatUnix(int timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    int hour = date.hour;
    int minute = date.minute;
    String period = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    if (hour == 0) hour = 12;
    String minuteStr = minute < 10 ? '0$minute' : '$minute';
    return '$hour:$minuteStr$period';
  }

  String get formattedHighTime => _formatUnix(highTimeUnix);
  String get formattedLowTime => _formatUnix(lowTimeUnix);
}