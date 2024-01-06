import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Reuseables/RichTextWithReadMore.dart';
import '../ChattingScreenModel.dart';
// Import any necessary packages for document viewing

class DocumentCell extends StatelessWidget {
  final ChattingScreenModel message;
  final double size;
  final String heroTag; // This might not be needed for documents

  const DocumentCell({
    super.key,
    required this.message,
    this.size = 50.0,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    IconData documentIcon = Icons.picture_as_pdf; // Default icon for documents

    // You can add logic to determine the icon based on the file type
    // For example, if your message object contains information about file type
    // if (message.fileType == 'pdf') documentIcon = Icons.picture_as_pdf;
    // if (message.fileType == 'word') documentIcon = Icons.book;

    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            // Handle document tap, e.g., open document viewer
            // Navigator.of(context).push(...);
          },
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.grey[300], // Background color for the document icon
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(documentIcon, size: size / 2, color: Colors.black),
          ),
        ),
        RichTextWithReadMore(text: message.message),
      ],
    );
  }
}
