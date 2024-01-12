import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;
import '../ChattingScreenModel.dart';

class MapCell extends StatelessWidget {
  final ChattingScreenModel message;
  final LatLng location; // Add a LatLng object for the map location
  final double size;
  final String heroTag; // This can be removed if not used elsewhere

  const MapCell({
    super.key,
    required this.message,
    this.location = const LatLng(0.0, 0.0), // Default location
    this.size = 200.0,
    required this.heroTag, // Adjust size as needed
  });

  Future<void> _launchMap(double lat, double lng) async {
    Uri googleUrl = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');
    Uri appleUrl = Uri.parse('https://maps.apple.com/?daddr=$lat,$lng');
    debugPrint(googleUrl.toString());
    if (Platform.isIOS) {
      if (await canLaunchUrl(appleUrl)) {
        // Launch the Apple Maps app
        debugPrint("Apple Url");
        await launchUrl(appleUrl);
      } else if (await canLaunchUrl(googleUrl)) {
        // Launch the Google Maps app
        debugPrint("Google Url");
        await launchUrl(googleUrl);
      } else {
        debugPrint("Fail Url");
        throw 'Could not launch URL';
      }
    } else {
      if (await canLaunchUrl(googleUrl)) {
        // Launch the Google Maps app
        debugPrint("Google Url");
        await launchUrl(googleUrl);
      } else if (await canLaunchUrl(appleUrl)) {
        // Launch the Apple Maps app
        debugPrint("Apple Url");
        await launchUrl(appleUrl);
      } else {
        debugPrint("Fail Url");
        throw 'Could not launch URL';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.transparent,
          width: size,
          height: size,
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
        ),
        ElevatedButton(
          onPressed: () {
            _launchMap(location.latitude, location.longitude);
          },
          child: const Text('Get Directions'),
        ),
      ],
    );
  }
}
