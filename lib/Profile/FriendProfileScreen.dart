import 'package:flutter/material.dart';
import 'package:untitled2/Utiles/Dialogs.dart';

import '../Chatting/ReceiverProfile.dart';
import '../Reuseables/CircleImage.dart';
import 'FriendProfileViewModel.dart';

class FriendProfileScreen extends StatefulWidget {
  final String tag;
  final ReceiverProfile receiverProfile;

  const FriendProfileScreen(
      {super.key, required this.tag, required this.receiverProfile});

  @override
  _FriendProfileScreenState createState() => _FriendProfileScreenState();
}

class _FriendProfileScreenState extends State<FriendProfileScreen> {
  bool isMute = false;
  bool isBlock = false;
  bool isLoading = false;
  FriendProfileViewModel? profileViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileViewModel = FriendProfileViewModel();
    profileViewModel?.setReceiverProfile(widget.receiverProfile);
  }

  void _blockDialog() {
    Dialogs dialog = Dialogs();
    dialog.showGenericDialog(
        context: context,
        title: "Warning!",
        message: "Are you sure, you want ${isBlock ? "Unblock" : "block"}?",
        actions: [
          DialogAction(
              label: "No",
              onPressed: () {
                Navigator.of(context).pop();
              }),
          DialogAction(
              label: "Yes",
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  isLoading : true;
                });
                profileViewModel?.blockUser(isBlock,(message, isSuccess) {
                  setState(() {
                    isLoading : false;
                  });
                  if (message != null) {
                    if (isSuccess) {
                      setState(() {
                        isBlock = !isBlock;
                      });
                    }
                    dialog.showGenericDialog(
                        context: context,
                        title: "Alert",
                        message: message,
                        actions: null);
                  }
                });
              })
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildSliverAppBar(),
              SliverToBoxAdapter(
                child: _buildProfileContent(),
              ),
              // Your other sliver widgets
            ],
          ),
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5), // Semi-transparent background
                child: const Center(
                  child: CircularProgressIndicator(), // Loader widget
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 250.0,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return FlexibleSpaceBar(
            titlePadding: const EdgeInsets.only(
              left: 0,
              bottom: 16,
            ),
            title: Text(
              widget.receiverProfile.name,
              style: const TextStyle(color: Colors.white),
            ),
            background: Image.network(
              'https://picsum.photos/200',
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileContent() {
    return Column(
      children: [
        _buildProfileImage(),
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: Text(widget.receiverProfile.email),
        ),
        _buildMenuList(),
      ],
    );
  }

  Widget _buildProfileImage() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Hero(
        tag: widget.tag,
        child: CircleImage(
          //imageFile: signupViewModel.getImage(),
          // File object for a local image
          imageUrl: widget.receiverProfile.photo,
          // URL string for a network image
          size: 100.0,
        ),
      ),
    );
  }

  Widget _buildMenuList() {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Mute Notifications'),
          value: isMute,
          onChanged: (bool value) {
            setState(() {
              isMute = value;
            });
          },
          secondary: const Icon(Icons.notifications_off),
        ),
        ListTile(
          leading: const Icon(Icons.block, color: Colors.red),
          title: Text(isBlock ? "Unblock" : 'Block',
              style: const TextStyle(color: Colors.red)),
          onTap: _blockDialog, // Add your action
        ),
        ListTile(
          leading: const Icon(Icons.report, color: Colors.red),
          title: const Text('Report', style: TextStyle(color: Colors.red)),
          onTap: () {}, // Add your action
        ),
      ],
    );
  }
}
