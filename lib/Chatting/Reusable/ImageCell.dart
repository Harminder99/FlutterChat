import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../ChattingScreenModel.dart';
import '../../Reuseables/FullScreenImageViewer.dart';

class ImageCell extends StatelessWidget {
  final ChattingScreenModel message;
  final double size;
  final String heroTag; // Unique tag for Hero animation

  const ImageCell({
    super.key,
    required this.message,
    this.size = 50.0,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () => Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => FullScreenImageViewer(imageUrl: "https://picsum.photos/200", tag: heroTag),
            transitionDuration: Duration.zero, // No animation duration
            reverseTransitionDuration: Duration.zero, // No reverse animation duration
            opaque: true, // No transparency
          )),
          child: Hero(
            tag: heroTag,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(
                  image: NetworkImage("https://picsum.photos/200"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Text(message.message, textAlign: TextAlign.left),
      ],
    );
  }
}
