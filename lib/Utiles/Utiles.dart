
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

enum AttachmentType {
  image,
  video,
  location,
  document
}

class Utils {
  static String formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}m';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    } else {
      return count.toString();
    }
  }

  static int generateRandomNumber() {
    var random = Random();
    final v = random.nextInt(10000000);
    return v; // Generates a random number from 0 to 9,999,999
  }

  static String generateUniqueString() {
    const uuid = Uuid();
    final uniqueString = uuid.v4(); // Generates a random UUID string
    return uniqueString;
  }

  static String formatAgoTime(DateTime date) {
    // Format the time as "1 min ago", "2 hours ago", etc.
    // Using DateFormat for simplicity; replace with your preferred format
    return DateFormat('jm').format(date);
  }

  static void showAttachmentSheet(BuildContext context, Function(AttachmentType type)? onPress) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () {
                    // Handle Gallery
                    Navigator.of(context).pop();
                    if (onPress != null)  onPress!(AttachmentType.image);

                  }),
              ListTile(
                leading: const Icon(Icons.videocam),
                title: const Text('Video'),
                onTap: () {
                  // Handle Video
                  if (onPress != null)  onPress!(AttachmentType.video);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text('Location'),
                onTap: () {
                  // Handle Location
                  Navigator.of(context).pop();
                  if (onPress != null)  onPress!(AttachmentType.location);

                },
              ),
              ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: const Text('Document'),
                onTap: () {
                  // Handle Document
                  if (onPress != null)  onPress!(AttachmentType.document);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}