import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  /// Requests GPS coordinates and translates them into a "City, State" string.
  /// Returns null if permissions are denied or services are disabled.
  Future<String?> getCurrentLocationString() async {
    try {
      // 1. Check if hardware location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null; // Hardware GPS is turned off
      }

      // 2. Handle OS Permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null; // User explicitly denied
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        return null; // Cannot request permissions anymore
      }

      // 3. Fetch the raw coordinates using the modern LocationSettings
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium, // Medium is fine for weather/zones
        ),
      );

      // 4. Reverse Geocode (Coordinates -> Address)
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return "${place.locality}, ${place.administrativeArea}";
      }
      
      return null;
    } catch (e) {
      print("Location Error: $e");
      return null;
    }
  }
}