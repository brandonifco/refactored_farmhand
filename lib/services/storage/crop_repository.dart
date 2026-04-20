import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/crop.dart';
import '../../utils/constants.dart';

class CropRepository {
  /// Loads the raw list of crops from the JSON asset
  Future<List<Crop>> loadRawCrops() async {
    final String response = await rootBundle.loadString('assets/crops.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Crop.fromJson(json)).toList();
  }

  /// Gets the list of crop names the user has selected
  Future<List<String>> getSelectedCropNames() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(AppConstants.selectedCropsKey) ?? [];
  }

  /// Saves the updated list of selected crop names
  Future<void> saveSelectedCropNames(List<String> selectedNames) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(AppConstants.selectedCropsKey, selectedNames);
  }
}