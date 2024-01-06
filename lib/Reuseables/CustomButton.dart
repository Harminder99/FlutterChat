import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double? marginTop;

  const CustomButton({
    super.key,
    this.width,
    this.marginTop,
    required this.text,
    required this.onPressed,

  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: width ?? 0.5, // Use provided width or default to 0.5
      child: Container(
        margin: EdgeInsets.only(top: marginTop ?? 0.0), // Apply top margin
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            // Additional styling can be added here
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'HighwayItalic',
            ),
          ),
        ),
      ),
    );
  }
}
