import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/AddChating/AddUserForChat.dart';
import 'package:untitled2/Chatting/ChattingScreen.dart';
import 'package:untitled2/Chatting/ChattingScreenModel.dart';
import 'package:untitled2/Chatting/ChattingScreenViewModel.dart';
import 'package:untitled2/Home/HomeScreenViewModel.dart';
import 'package:untitled2/NetworkApi/ApiEndpoints.dart';
import 'package:untitled2/NetworkApi/SocketResponse.dart';
import 'package:untitled2/NetworkApi/WebSocketManager.dart';
import 'package:untitled2/Profile/ProfileScreen.dart';
import '../Reuseables/HomeAppBar.dart';
import '../Utiles/ProfileDialogScreen.dart';
import 'Cells/UserItem.dart';
import 'HomeScreenModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final socket = Provider.of<WebSocketManager>(context, listen: false);
      socket.connect(context);
      initSocketOn();
      callApi(1);
    });

    //_scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
  }

  void _deleteUsers(){
    final viewModel = Provider.of<HomeScreenViewModel>(context, listen: false);
    if(viewModel.selectedUserIds.isNotEmpty) {
      viewModel.deleteUsers();
    }
  }

  void callApi(int page) {
    final viewModel = Provider.of<HomeScreenViewModel>(context, listen: false);
    viewModel.getUsers();
  }

  void _onSearchChanged() {
    final viewModel = Provider.of<HomeScreenViewModel>(context, listen: false);
    viewModel.searchData(_searchController.text);
  }

  void _handleCellTap(HomeScreenModel user, String tag) {
    final homeModel = Provider.of<HomeScreenViewModel>(context, listen: false);
    homeModel.updateCountToZero(user);
    if (homeModel.onCellTap(user)) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChattingScreen(user: user, tag: tag)));
    }
  }

  void _handleImageTap(HomeScreenModel user, String tag) {
    //Provider.of<HomeScreenViewModel>(context, listen: false).onImageTap(user);
    Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      pageBuilder: (BuildContext context, _, __) {
        return ProfileDialogScreen(
            tag: tag, user: user); // Custom full-screen modal route
      },
    ));
  }

  void _handleCellLongPress(HomeScreenModel user) {
    Provider.of<HomeScreenViewModel>(context, listen: false).onLongTap(user);
  }

  void _onAddUsers() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AddUserForChat()));
  }

  Future<void> _refresh() async {
    // Perform your refresh action here
    callApi(1);
  }

  @override
  Widget build(BuildContext context) {
    void handleMenuSelection(dynamic value) {
      // Handle menu selection
      // debugPrint("Selected: $value");
    }

    void handleProfileSelection() {
      // Handle menu selection
      Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return const ProfileScreen(
              tag: "myProfile"); // Custom full-screen modal route
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
        onAddUsers: _onAddUsers,
        onDeleteUsers: _deleteUsers,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: _body(),
      ),
    );
  }

  Widget _body() {
    final homeScreenViewModel = Provider.of<HomeScreenViewModel>(context);
    final isLoading = homeScreenViewModel.isLoginLoading;
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
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
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
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10.0), // Reduced padding
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
              final isSelected =
                  homeScreenViewModel.selectedUserIds.contains(user.id);
              return RepaintBoundary(
                child: UserItem(
                  tag: 'profile-hero$index',
                  isSelected: isSelected,
                  imageUrl: user.photo,
                  username: user.name,
                  message: user.message,
                  date: user.date,
                  count: user.count,
                  onCellTap: () => _handleCellTap(user, 'profile-hero$index'),
                  onImageTap: () => _handleImageTap(user, 'profile-hero$index'),
                  onLongTap: () => _handleCellLongPress(user),
                ),
              );
            },
            childCount: homeScreenViewModel.data.length,
          ),
        ),
        if (isLoading && homeScreenViewModel.data.isEmpty)
          const SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(), // Centered loader
            ),
          ),
        if (isLoading && homeScreenViewModel.data.isNotEmpty)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: CircularProgressIndicator(), // Footer loader
              ),
            ),
          ),
        if (!isLoading && homeScreenViewModel.data.isEmpty)
          SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                      "No user for chat,\nClick on button to add new user.",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20), // For spacing
                  ElevatedButton(
                    onPressed: () {
                      _onAddUsers();
                    },
                    child: const Text("Add Chat"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      callApi(1);
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            ),
          )
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void initSocketOff() {
    // final socket = Provider.of<WebSocketManager>(context, listen: false);
    // socket.off(ApiEndpoints.receiveMessage);
  }

  void initSocketOn() {
    final socket = Provider.of<WebSocketManager>(context, listen: false);
    socket.on(ApiEndpoints.receiveMessage, (SocketResponse model) {
      if (model.data != null) {
        ChattingScreenModel chatModel =
            ChattingScreenModel.fromRecJson(model.data!);
        final socketViewModel =
            Provider.of<ChattingScreenViewModel>(context, listen: false);
        final viewModel =
            Provider.of<HomeScreenViewModel>(context, listen: false);

        if (socketViewModel.receiverProfile?.id ==
            chatModel.receiverProfile.id) {
          debugPrint("you are in chatting screen");
          socketViewModel.receiveMessage(chatModel);
          // update home screen list because you have short this list by time and update last message but not count
          viewModel.updateListMessage(
              chatModel, socketViewModel.isChatScreenVisible ? false : true);
          if (!socketViewModel.isChatScreenVisible) {
            showNotifications();
          }

          // return emit to update message Status here message is delivered
          socketViewModel.updateStatusEmit(
              context, chatModel, MessageStatus.delivered);
        } else {
          debugPrint("Chatting screen is closed");
          // update count, last message and time here
          viewModel.updateListMessage(chatModel, true);
          showNotifications();
        }
      } else {
        debugPrint("print init fail");
      }
    });
  }

  void showNotifications() {}
}
