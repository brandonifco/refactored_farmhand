import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/location_service.dart';

// A simple provider that gives the rest of the app access to the LocationService
final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});