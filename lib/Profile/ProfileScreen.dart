import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/Login/LoginScreen.dart';
import 'package:untitled2/Login/LoginViewModel.dart';
import 'package:untitled2/NetworkApi/HeaderService.dart';

import '../NetworkApi/WebSocketManager.dart';
import '../Reuseables/CircleImage.dart';

class ProfileScreen extends StatefulWidget {
  final String tag;

  const ProfileScreen({super.key, required this.tag});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          InkWell(
            onTap: () {
              // TODO: Handle CircleImage tap
              //signupViewModel.pickImage();
            },
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
          ),
          Container(
            margin: const EdgeInsets.only(top: 2, bottom: 2, right: 2, left: 2),
            child: const SizedBox(
              width: 102.0, // Slightly larger than CircleImage
              height: 102.0,
              child: CircularProgressIndicator(
                value: 1,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: -10,
            child: IconButton(
              icon: const Icon(Icons.add_circle),
              onPressed: () {
                // TODO: Handle plus icon button tap
                //signupViewModel.pickImage();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuList() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
          onTap: () {}, // Add your action
        ),
        ListTile(
          leading: const Icon(Icons.privacy_tip),
          title: const Text('Privacy Policy'),
          onTap: () {}, // Add your action
        ),
        ListTile(
          leading: const Icon(Icons.description),
          title: const Text('Terms and Conditions'),
          onTap: () {}, // Add your action
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () {
            final viewModel =
                Provider.of<LoginViewModel>(context, listen: false);

            if (viewModel.model != null && viewModel.model?.token != "") {
              Global.authToken = "";
              final socket = Provider.of<WebSocketManager>(context, listen: false);
              socket.disConnect();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (Route<dynamic> route) =>
                    false, // This condition ensures all routes are removed
              );
            }
          }, // Add your action
        ),
      ],
    );
  }
}
