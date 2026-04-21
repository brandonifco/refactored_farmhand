import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'views/dashboard/planting_dashboard.dart';
import 'utils/constants.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart'; // Add this
import 'models/crop.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(CropAdapter());
  
  await Hive.openBox<Crop>('crops_box');

  runApp(const ProviderScope(child: FarmApp()));
}

class FarmApp extends StatelessWidget {
  const FarmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      // We will create the updated dashboard file next
      home: const PlantingDashboard(), 
    );
  }
}