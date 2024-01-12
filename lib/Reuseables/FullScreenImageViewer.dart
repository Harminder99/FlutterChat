import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

// class FullScreenImageViewer extends StatelessWidget {
//   final String imageUrl;
//   final String tag;
//
//   const FullScreenImageViewer({Key? key, required this.imageUrl, required this.tag}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: PhotoViewGallery.builder(
//         itemCount: 1,
//         builder: (context, index) {
//           return PhotoViewGalleryPageOptions(
//             imageProvider: NetworkImage(imageUrl),
//             heroAttributes: PhotoViewHeroAttributes(tag: tag),
//             minScale: PhotoViewComputedScale.contained,
//             maxScale: PhotoViewComputedScale.covered * 2,
//           );
//         },
//         scrollPhysics: const BouncingScrollPhysics(),
//         backgroundDecoration: const BoxDecoration(
//           color: Colors.black,
//         ),
//         enableRotation: false,
//         loadingBuilder: (context, event) => Center(
//           child: CircularProgressIndicator(
//             value: event == null ? 0 : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
//           ),
//         ),
//       ),
//     );
//   }
// }

class FullScreenImageViewer extends StatefulWidget {
  final String imageUrl;
  final String tag;

  FullScreenImageViewer({Key? key, required this.imageUrl, required this.tag}) : super(key: key);

  @override
  _FullScreenImageViewerState createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  double initialY = 0.0;
  double currentY = 0.0;
  double delta = 0.0;

  void _onVerticalDragStart(DragStartDetails details) {
    initialY = details.globalPosition.dy;
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      currentY = details.globalPosition.dy;
      delta = currentY - initialY;
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (delta.abs() > 100) { // Swipe threshold
      Navigator.of(context).pop();
    } else {
      setState(() {
        delta = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onVerticalDragStart: _onVerticalDragStart,
        onVerticalDragUpdate: _onVerticalDragUpdate,
        onVerticalDragEnd: _onVerticalDragEnd,
        child: Transform.translate(
          offset: Offset(0, delta),
          child: Center(
            child: Hero(
              tag: widget.tag,
              child: PhotoView(
                imageProvider: NetworkImage(widget.imageUrl),
                backgroundDecoration: const BoxDecoration(color: Colors.transparent),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
