import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final Widget child;
  final bool isSender;
  final double? verticalPadding;
  final double? horizontalPadding;


  const ChatBubble(
      {Key? key,
      required this.child,
      required this.isSender,
        required this.verticalPadding,
        required this.horizontalPadding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Align(
        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
        child: CustomPaint(
          painter: BubbleArrowPainter(isSender: isSender),
          child: IntrinsicWidth(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              child: Container(
                padding:  EdgeInsets.symmetric(vertical: verticalPadding ?? 10, horizontal: horizontalPadding ?? 15),
                decoration: BoxDecoration(
                  color: isSender ? Colors.blue[200] : Colors.grey[500],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BubbleArrowPainter extends CustomPainter {
  final bool isSender;

  BubbleArrowPainter({required this.isSender});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = isSender ? Colors.blue[200]! : Colors.grey[500]!;
    var path = Path();
    if (isSender) {
      path.moveTo(size.width - 10, size.height);
      path.lineTo(size.width, size.height - 10);
      path.lineTo(size.width + 10, size.height + 2);
      path.close();
    } else {
      path.moveTo(10, 0);
      path.lineTo(0, 10);
      path.lineTo(-10, -2);
      path.close();
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
