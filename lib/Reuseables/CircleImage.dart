import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CircleImage extends StatelessWidget {
  final String? imageUrl;
  final XFile? imageFile;
  final double size;
  final double? marginTop;

  const CircleImage({
    super.key,
    this.imageUrl,
    this.imageFile,
    this.size = 50.0,
    this.marginTop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: EdgeInsets.only(top: marginTop ?? 0.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        image: DecorationImage(
          image: _buildImage(),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  ImageProvider _buildImage() {
    // Use local image if available
    final imageFile = this.imageFile;
    if (imageFile != null) {
      debugPrint("Local Image");
      return FileImage(File(imageFile.path));
    }
    // Use network image if available and local image is not provided
    else if (imageUrl != null && imageUrl!.isNotEmpty) {

      return NetworkImage(imageUrl!);
    }
    // Use a placeholder if neither local nor network image is provided
    else {
      debugPrint("Placeholder Image");
      return const AssetImage('assets/placeholder.jpg'); // Replace with your placeholder asset
    }
  }
}
