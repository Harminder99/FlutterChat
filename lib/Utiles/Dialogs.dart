import 'package:flutter/material.dart';

class Dialogs {
  void showProfileDialog(BuildContext context, String tag) {
    debugPrint("tag ==> $tag");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(10),
          backgroundColor: Colors.transparent,
          child: Container(
            margin: EdgeInsets.zero,
            width:
                MediaQuery.of(context).size.width * 0.5, // 80% of screen width
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // Use minimum space needed by children
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.72,
                  padding: EdgeInsets.zero,
                  child: Hero(
                    tag: tag,
                    child: Image.network(
                      'https://picsum.photos/200',
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width * 0.72,
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  padding: EdgeInsets.zero,
                  color: Colors.blue,
                  width: MediaQuery.of(context).size.width * 0.72,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chat),
                        onPressed: () {}, // Add your action
                      ),
                      IconButton(
                        icon: const Icon(Icons.info),
                        onPressed: () {}, // Add your action
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showDefaultAlertDialog(
      BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showGenericDialog({
    required BuildContext context,
    required String title,
    required String message,
    required List<DialogAction>? actions,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button to close the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: actions != null && actions.isNotEmpty
              ? actions
                  .map((action) => TextButton(
                        onPressed: action.onPressed,
                        child: Text(action.label),
                      ))
                  .toList()
              : <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Dismiss"),
                  ),
                ],
        );
      },
    );
  }
}

class DialogAction {
  final String label;
  final VoidCallback onPressed;

  DialogAction({required this.label, required this.onPressed});
}
