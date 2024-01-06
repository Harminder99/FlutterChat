import 'package:flutter/material.dart';

import '../Reuseables/CircleImage.dart';


class FriendProfileScreen extends StatefulWidget {
  final String tag;

  const FriendProfileScreen({super.key, required this.tag});

  @override
  _FriendProfileScreenState createState() => _FriendProfileScreenState();
}

class _FriendProfileScreenState extends State<FriendProfileScreen> {
  bool isMute = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: _buildProfileContent(),
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
            title: const Text(
              'Username',
              style: TextStyle(color: Colors.white),
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
          child: const Text('email@example.com'),
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
        child: const CircleImage(
          //imageFile: signupViewModel.getImage(),
          // File object for a local image
          imageUrl: 'https://picsum.photos/200',
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
          title: const Text('Block', style: TextStyle(color: Colors.red)),
          onTap: () {}, // Add your action
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
