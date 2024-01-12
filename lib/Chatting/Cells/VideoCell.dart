import 'package:flutter/material.dart';

import '../../Reuseables/FullScreenVideoPlayer.dart';
import '../ChattingScreenModel.dart';

class VideoCell extends StatelessWidget {
  final ChattingScreenModel message;
  final double size;
  final String heroTag; // Unique tag for Hero animation

  const VideoCell({
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
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => FullScreenVideoPlayer(videoUrl: "https://storage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4", tag: heroTag),
          )),
          child: Hero(
            tag: heroTag,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Image
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        "https://picsum.photos/200",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Play Icon
                  Icon(Icons.play_circle_outline, size: size / 3, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
        Text(message.message, textAlign: TextAlign.left),
      ],
    );
  }
}

