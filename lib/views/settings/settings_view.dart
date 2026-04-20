import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/config_provider.dart';
import '../../providers/location_provider.dart';

// Notice we change from StatefulWidget to ConsumerStatefulWidget
// This allows the widget to interact with Riverpod's 'ref' object
class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  
  final List<String> _zones = ['5a', '5b', '6a', '6b', '7a', '7b'];
  String _selectedZone = '6b';

  @override
  void initState() {
    super.initState();
    // Since the Dashboard loaded first, our configProvider already has data in memory.
    // We can just grab the current value to pre-fill the text boxes.
    final currentConfig = ref.read(configProvider).value;
    
    if (currentConfig != null) {
      _nameController.text = currentConfig.farmName;
      _locationController.text = currentConfig.location;
      _selectedZone = currentConfig.hardinessZone;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // Look how clean the location logic is now. The UI just asks the provider for a string.
  Future<void> _handleGetLocation() async {
    final locationService = ref.read(locationServiceProvider);
    final newLocation = await locationService.getCurrentLocationString();

    if (!mounted) return;

    if (newLocation != null) {
      setState(() {
        _locationController.text = newLocation;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Could not get location. Check device permissions."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Saving is just passing the strings back to the central hub.
  Future<void> _handleSave() async {
    await ref.read(configProvider.notifier).updateSettings(
      name: _nameController.text,
      location: _locationController.text,
      zone: _selectedZone,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Farm Configuration Saved!")),
      );
      // Optional: Automatically return to the dashboard after saving
      Navigator.pop(context); 
    }
  }

  @override
  Widget build(BuildContext context) {
    // We can watch the configProvider. If it's in a "loading" state (because it's saving),
    // we can disable the save button to prevent double-clicks.
    final configState = ref.watch(configProvider);
    final isSaving = configState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm Configuration'),
        backgroundColor: Colors.blueGrey[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: isSaving 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Icon(Icons.save),
            onPressed: isSaving ? null : _handleSave,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "General Info",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: "Farm Name",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.agriculture),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _locationController,
            decoration: InputDecoration(
              labelText: "Location",
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.location_on),
              suffixIcon: IconButton(
                icon: const Icon(Icons.my_location),
                onPressed: _handleGetLocation,
                tooltip: "Get current location",
              ),
            ),
          ),
          const SizedBox(height: 30),

          const Text(
            "Hardiness Zone",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Text("Determines your planting window based on frost dates."),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            initialValue: _selectedZone,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: _zones.map((zone) {
              return DropdownMenuItem(value: zone, child: Text("Zone $zone"));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedZone = value!;
              });
            },
          ),
          const SizedBox(height: 40),

          ElevatedButton.icon(
            onPressed: isSaving ? null : _handleSave,
            icon: isSaving 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Icon(Icons.save),
            label: Text(isSaving ? "SAVING..." : "SAVE CONFIGURATION"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ],
      ),
    );
  }
}