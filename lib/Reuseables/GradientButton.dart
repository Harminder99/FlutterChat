import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class GradientButton extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final double width;
  final VoidCallback onPressed;
  final double? marginTop;
  final bool isLoading;

  const GradientButton({
    super.key,
    required this.child,
    required this.gradient,
    this.width = double.infinity,
    required this.onPressed,
    this.marginTop,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the height of the button's child content
    const double contentHeight = 20.0; // Adjust as per your design

    return Container(
      width: width,
      margin: EdgeInsets.only(top: marginTop ?? 0),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(30),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ?  const SpinKitSpinningLines(
          color: Colors.white,
          size: 20.0,
        )
            : child,
      ),
    );
  }
}
