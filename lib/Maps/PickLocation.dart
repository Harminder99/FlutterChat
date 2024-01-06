import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PickLocation extends StatelessWidget {
  const PickLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PickLocation")),
      body: const PickLocationForm(),
    );
  }
}

class PickLocationForm extends StatefulWidget {
  const PickLocationForm({super.key});

  @override
  _PickLocationState createState() => _PickLocationState();
}

class _PickLocationState extends State<PickLocationForm> {
  // State variables and methods
  final LatLng location = const LatLng(0.0, 0.0);
  @override
  Widget build(BuildContext context) {
    // Return a widget tree
    return Container(
      padding:  EdgeInsets.zero,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: location,
          zoom: 10.0,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('location'),
            position: location,
          ),
        },
        myLocationButtonEnabled: false,
      ),
    );
  }
}
