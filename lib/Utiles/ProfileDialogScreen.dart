import 'package:flutter/material.dart';
import 'package:untitled2/Chatting/ChattingScreen.dart';
import 'package:untitled2/Profile/FriendProfileScreen.dart';

import '../Chatting/ReceiverProfile.dart';
import '../Home/HomeScreenModel.dart';

class ProfileDialogScreen extends StatelessWidget {
  final String tag;
  final HomeScreenModel user;

  const ProfileDialogScreen({Key? key, required this.tag, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () {
            Navigator.of(context).pop(); // Close the dialog when tapped outside
          },
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.transparent,
            child: Center(
              child: Container(
                color: Theme.of(context).cardColor,
                margin: EdgeInsets.zero,
                width: MediaQuery.of(context).size.width *
                    0.5, // 80% of screen width
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  // Use minimum space needed by children
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.72,
                      padding: EdgeInsets.zero,
                      child: Image.network(
                        'https://picsum.photos/200',
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width * 0.72,
                      ),
                    ),
                    Container(
                      height: 50,
                      padding: EdgeInsets.zero,
                      width: MediaQuery.of(context).size.width * 0.72,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chat),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChattingScreen(
                                          user: user, tag: tag)));
                            }, // Add your action
                          ),
                          IconButton(
                            icon: const Icon(Icons.info),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FriendProfileScreen(
                                          tag: '',
                                          receiverProfile:
                                              ReceiverProfile.fromHomeModel(
                                                  user))));
                            }, // Add your action
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
