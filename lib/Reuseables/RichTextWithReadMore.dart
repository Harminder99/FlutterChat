import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class RichTextWithReadMore extends StatefulWidget {
  final String text;

  const RichTextWithReadMore({Key? key, required this.text}) : super(key: key);

  @override
  _RichTextWithReadMoreState createState() => _RichTextWithReadMoreState();
}

class _RichTextWithReadMoreState extends State<RichTextWithReadMore> {
  late String firstPart;
  late String secondPart;
  bool flag = true; // Flag to toggle Read more/Read less

  @override
  void initState() {
    super.initState();
    if (widget.text.split(' ').length > 100) {
      firstPart = '${widget.text.split(' ').sublist(0, 100).join(' ')}... ';
      secondPart = widget.text.substring(firstPart.length - 4);
    } else {
      firstPart = widget.text;
      secondPart = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 0,top: 5,right: 3,left: 3),
      child: secondPart.isEmpty
          ? _buildRichText(firstPart)
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRichText(flag ? (firstPart + (secondPart.isNotEmpty ? "Read more" : "")) : ("${widget.text} Read less")),
          InkWell(
            child: Text(
              flag ? "Read more" : "Read less",
              style: const TextStyle(color: Colors.blue),
            ),
            onTap: () {
              setState(() {
                flag = !flag;
              });
            },
          ),
        ],
      ),
    );
  }

  RichText _buildRichText(String text) {
    final regexUrl = RegExp(r'\bhttps?:\/\/\S+\b', caseSensitive: false);
    final words = text.split(' ');
    List<TextSpan> spans = words.map((word) {
      // Check if the word matches URL pattern
      bool isUrl = regexUrl.hasMatch(word);

      if (word.startsWith('#')) {
        return TextSpan(
          text: '$word ',
          style: const TextStyle(color: Colors.red),
          recognizer: TapGestureRecognizer()..onTap = () => debugPrint('Hashtag $word tapped'),
        );
      } else if (word.startsWith('@')) {
        return TextSpan(
          text: '$word ',
          style: const TextStyle(color: Colors.green),
          recognizer: TapGestureRecognizer()..onTap = () => debugPrint('Mention $word tapped'),
        );
      } else if (isUrl) {
        return TextSpan(
          text: '$word ',
          style: const TextStyle(color: Colors.blue),
          recognizer: TapGestureRecognizer()..onTap = () => debugPrint('URL $word tapped'),
        );
      } else {
        return TextSpan(text: '$word ', style: const TextStyle(color: Colors.black));
      }
    }).toList();

    return RichText(
      text: TextSpan(
        children: spans,
        style: const TextStyle(fontSize: 16.0, color: Colors.black),
      ),
    );
  }


}
