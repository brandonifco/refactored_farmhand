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
}