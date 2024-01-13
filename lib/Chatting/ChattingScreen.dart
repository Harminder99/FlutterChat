import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/Chatting/ChattingScreenViewModel.dart';
import 'package:untitled2/Chatting/ReceiverProfile.dart';
import 'package:untitled2/Home/HomeScreenModel.dart';
import 'package:untitled2/Profile/FriendProfileScreen.dart';

import '../Reuseables/GeneralAppBar.dart';
import 'Reusable/ChatInputField.dart';
import 'Reusable/ChatMessagesList.dart';

class ChattingScreen extends StatefulWidget {
  final HomeScreenModel user;
  final String tag;

  const ChattingScreen({super.key, required this.user, required this.tag});

  @override
  _ChattingScreenState createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  @override
  void initState() {
    super.initState();
    final viewModel =
        Provider.of<ChattingScreenViewModel>(context, listen: false);
    viewModel.setReceiverProfile(ReceiverProfile(
        name: widget.user.name,
        id: widget.user.id,
        photo: widget.user.photo,
        email: widget.user.email));
    viewModel.getChatting();
  }

  void _handleMenuSelection(dynamic value) {
    // Handle menu selection
    final viewModel =
        Provider.of<ChattingScreenViewModel>(context, listen: false);
    debugPrint("Selected: $value");
    if (value == "cleanAll") {
      viewModel.deleteAllDataBase();
    }
  }

  void _handleProfileSelection() {
    // Handle menu selection
    debugPrint("Selected: Profile");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FriendProfileScreen(tag: widget.tag)));
  }

  PreferredSizeWidget _buildAppBar() {
    final viewModel =
        Provider.of<ChattingScreenViewModel>(context, listen: true);
    if (viewModel.selectedMessages.isNotEmpty) {
      return AppBar(
        title: Text('${viewModel.selectedMessages.length} selected'),
        leading: IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: () => viewModel.clearMessageSelection(),
        ),
        actions: _buildMenuActions(),
      );
    } else {
      return GeneralAppBar(
        tag: widget.tag,
        title: widget.user.name,
        imageUrl: 'https://picsum.photos/200',
        menuItems:  <PopupMenuEntry<dynamic>>[
          if(viewModel.messages.isNotEmpty)
          const PopupMenuItem<dynamic>(
            value: 'cleanAll',
            child: Text('Clear All'),
          ),
          // PopupMenuItem<dynamic>(
          //   value: 'Settings',
          //   child: Text('Settings'),
          // ),
          // Add more items as needed
        ],
        onMenuSelect: _handleMenuSelection,
        onProfileTap: _handleProfileSelection,
      );
    }
  }

  List<Widget> _buildMenuActions() {
    final viewModel =
        Provider.of<ChattingScreenViewModel>(context, listen: false);
    List<Widget> actions = [];

    if (viewModel.selectedMessages.length == 1) {
      actions.addAll([
        // Add your actions for single selection
        IconButton(
          icon: const Icon(Icons.copy_all_outlined),
          onPressed: () => {},
        ),
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => {},
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            viewModel.deleteIntoDataBase();
          },
        ),
        IconButton(
          icon: const Icon(Icons.info),
          onPressed: () => {},
        )
      ]);
    } else if (viewModel.selectedMessages.length > 1) {
      actions.addAll([
        // Add your actions for multiple selections
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            viewModel.deleteIntoDataBase();
          },
        ),
      ]);
    }

    return actions;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final viewModel =
            Provider.of<ChattingScreenViewModel>(context, listen: false);

        if (viewModel.isEmojiVisible()) {
          viewModel.setEmojiVisible(false);
        }
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: const Column(
          children: [
            Expanded(
              child: ChatMessagesList(), // Widget to display chat messages
            ),
            ChatInputField(), // Chat input field widget
          ],
        ),
      ),
    );
  }
}
