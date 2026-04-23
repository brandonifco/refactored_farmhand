import 'package:flutter/material.dart';
import '../models/crop.dart';
// Components
import '../components/details/crop_detail_header.dart';
import '../components/details/frost_resilience_card.dart';
import '../components/details/planting_schedule.dart';
import '../components/details/crop_resources.dart';
import '../components/details/crop_traits_tag_stack.dart';
import '../components/details/crop_tips_card.dart';

class CropDetailView extends StatelessWidget {
  final Crop crop;
  const CropDetailView({super.key, required this.crop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(crop.name),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CropDetailHeader(crop: crop),
            const SizedBox(height: 16),
            
            FrostResilienceCard(crop: crop),
            const SizedBox(height: 10),

            PlantingSchedule(crop: crop), // Pass crop directly, move logic inside!
            
            CropResources(crop: crop),
            
            CropTraitsTagStack(traits: crop.traits),
            
            CropTipsCard(notes: crop.notes),
          ],
        ),
      ),
    );
  }
}