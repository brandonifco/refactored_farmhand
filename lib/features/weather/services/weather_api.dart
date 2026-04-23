import 'dart:convert';
import 'dart:developer' as dev;
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherApi {
  // Keeping your hardcoded Bethel Township coordinates for now
  final double lat = 39.9614;
  final double lon = -84.0624;
  final String _apiKey = "APT4aa2hrBS0J61gjMO950GbEShEjOcC";

  Future<Weather?> fetchCurrentWeather() async {
    final url = Uri.parse(
      "https://api.pirateweather.net/forecast/$_apiKey/$lat,$lon?units=us",
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Weather.fromJson(data);
      } else {
        dev.log("Weather API returned status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      dev.log("Weather Network Error: $e");
      return null;
    }
  }
  // Add this inside your WeatherApi class
  Future<double> fetchAccumulationSince(DateTime startDate) async {
    DateTime now = DateTime.now();
    // Normalize dates to midnight to avoid partial day calculation errors
    DateTime current = DateTime(startDate.year, startDate.month, startDate.day);
    DateTime end = DateTime(now.year, now.month, now.day);
    
    double totalAccumulation = 0.0;

    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      final unixTime = (current.millisecondsSinceEpoch / 1000).round();
      // Added the Unix timestamp and excluded unnecessary blocks to save bandwidth/processing
      final url = Uri.parse(
        "https://timemachine.pirateweather.net/forecast/$_apiKey/$lat,$lon,$unixTime?units=us&exclude=currently,hourly,minutely,alerts",
      );
      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          dev.log("Time Machine Data for $current: ${data['daily']}");
          final dailyData = data['daily']?['data']?[0];
          
          if (dailyData != null) {
            // Using your exact mapping logic for consistency
            totalAccumulation += dailyData['precipAccumulation']?.toDouble() ?? 0.0;
          }
        } else {
          dev.log("Time Machine API error status: ${response.statusCode} for $current");
        }
      } catch (e) {
        dev.log("Time Machine Network Error for $current: $e");
      }

      // Increment by one day
      current = current.add(const Duration(days: 1));
    }

    return totalAccumulation;
  }
}