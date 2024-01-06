import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final double width;
  //final double height;
  final VoidCallback onPressed;
  final double? marginTop;

  const GradientButton({
    super.key,
    required this.child,
    required this.gradient,
    this.width = double.infinity, // Default full width
   // this.height = 50.0, // Default height
    required this.onPressed, this.marginTop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      //height: height,
      margin: EdgeInsets.only(top: marginTop ?? 0),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(30), // Adjust the radius as needed
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
