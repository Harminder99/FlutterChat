import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/Chatting/ChattingScreen.dart';
import 'package:untitled2/Home/HomeScreenViewModel.dart';
import 'package:untitled2/NetworkApi/ApiEndpoints.dart';
import 'package:untitled2/NetworkApi/WebSocketManager.dart';
import 'package:untitled2/Profile/ProfileScreen.dart';

import '../Reuseables/HomeAppBar.dart';
import '../Utiles/ProfileDialogScreen.dart';
import 'Cells/UserItem.dart';
import 'ChatTempModel.dart';
import 'HomeScreenModel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});



  @override
  Widget build(BuildContext context) {
    void handleMenuSelection(dynamic value) {
      // Handle menu selection
      debugPrint("Selected: $value");
    }

    void handleProfileSelection() {
      // Handle menu selection
      debugPrint("Selected: Profile");
      Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return const ProfileScreen(tag: "myProfile"); // Custom full-screen modal route
        },
      ));
    }
    return Scaffold(
      appBar: HomeAppBar(
        tag: "myProfile",
        title: "Home",
        imageUrl: 'https://picsum.photos/200',
        menuItems: const <PopupMenuEntry<dynamic>>[
          PopupMenuItem<dynamic>(
            value: 'Profile',
            child: Text('Profile'),
          ),
          PopupMenuItem<dynamic>(
            value: 'Settings',
            child: Text('Settings'),
          ),
          // Add more items as needed
        ],
        onMenuSelect: handleMenuSelection,
        onProfileTap: handleProfileSelection,
      ),
      body: const HomeScreenForm(),
    );
  }
}

class HomeScreenForm extends StatefulWidget {
  const HomeScreenForm({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenForm> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchVisible = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final socket = Provider.of<WebSocketManager>(context, listen: false);
      socket.connect(context);
      socket.on(ApiEndpoints.receiveMessage, (ChatTempModel model) {
       debugPrint("Message Found${model.message}");
      });
    });
    _scrollController.addListener(_onScroll);
    final viewModel = Provider.of<HomeScreenViewModel>(context, listen: false);
    viewModel.getUsers(1);
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final viewModel = Provider.of<HomeScreenViewModel>(context, listen: false);
    viewModel.searchData(_searchController.text);
  }

  void _onScroll() {
    final viewModel = Provider.of<HomeScreenViewModel>(context, listen: false);
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        viewModel.limit <= viewModel.data.length) {
      // End of the list reached

      viewModel.loadMore();
    }

    // Determine whether to show or hide the search bar
    bool isScrollingDown = _scrollController.position.userScrollDirection == ScrollDirection.reverse;
    if (isScrollingDown && _isSearchVisible) {
      setState(() => _isSearchVisible = false);
    } else if (!isScrollingDown && !_isSearchVisible) {
      setState(() => _isSearchVisible = true);
    }
  }

  void _handleCellTap(HomeScreenModel user,String tag) {
    final isNotSelection = Provider.of<HomeScreenViewModel>(context, listen: false).onCellTap(user);
    if (isNotSelection){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>  ChattingScreen(user : user, tag: tag)));
    }
  }

  void _handleImageTap(HomeScreenModel user,String tag) {
    //Provider.of<HomeScreenViewModel>(context, listen: false).onImageTap(user);
    Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      pageBuilder: (BuildContext context, _, __) {
        return ProfileDialogScreen(tag: tag, user: user); // Custom full-screen modal route
      },
    ));
  }

  void _handleCellLongPress(HomeScreenModel user) {
    Provider.of<HomeScreenViewModel>(context, listen: false).onLongTap(user);
  }

  @override
  Widget build(BuildContext context) {
    final homeScreenViewModel = Provider.of<HomeScreenViewModel>(context);

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverAppBar(
          floating: false,
          pinned: false,
          expandedHeight: 70.0,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: Theme.of(context).cardColor,
              padding: const EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
              child: Center(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'search',
                    fillColor: Theme.of(context).primaryColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0), // Reduced padding
                  ),
                  style: const TextStyle(fontSize: 14), // Adjust font size
                ),
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              final user = homeScreenViewModel.data[index];
              final isSelected = homeScreenViewModel.selectedUserIds.contains(user.id);
              return RepaintBoundary(
                child: UserItem(
                  tag: 'profile-hero$index',
                  isSelected: isSelected,
                  imageUrl: user.photo,
                  username: user.username,
                  message: user.message,
                  date: user.date,
                  count: user.count,
                  onCellTap: () => _handleCellTap(user,'profile-hero$index'),
                  onImageTap: () => _handleImageTap(user,'profile-hero$index'),
                  onLongTap: () => _handleCellLongPress(user),
                ),
              );
            },
            childCount: homeScreenViewModel.data.length,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
