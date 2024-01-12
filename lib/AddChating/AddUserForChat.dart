import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/Chatting/ChattingScreen.dart';
import 'package:untitled2/Chatting/ChattingScreenModel.dart';
import 'package:untitled2/Chatting/ChattingScreenViewModel.dart';
import 'package:untitled2/NetworkApi/ApiEndpoints.dart';
import 'package:untitled2/NetworkApi/SocketResponse.dart';
import 'package:untitled2/NetworkApi/WebSocketManager.dart';
import 'package:untitled2/Utiles/LocationService.dart';

import '../Home/Cells/UserItem.dart';
import '../Home/HomeScreenModel.dart';
import '../Utiles/Dialogs.dart';
import '../Utiles/ProfileDialogScreen.dart';
import '../main.dart';
import 'AddUserChatViewModel.dart';

class AddUserForChat extends StatefulWidget {
  const AddUserForChat({super.key});

  @override
  _AddUserForChatState createState() => _AddUserForChatState();
}

class _AddUserForChatState extends State<AddUserForChat>
    with WidgetsBindingObserver, RouteAware {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchVisible = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPushNext() {
    // TODO: implement didPushNext

    super.didPushNext();
    initSocketOff();
  }

  @override
  void didPopNext() {
    // TODO: implement didPopNext
    super.didPopNext();
    initSocketOn();
  }

  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) {
    // TODO: implement didPushRouteInformation
    return super.didPushRouteInformation(routeInformation);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getPosition();
    });
    WidgetsBinding.instance.addObserver(this);
    _scrollController.addListener(_onScroll);

    _searchController.addListener(_onSearchChanged);
  }

  void callApi(int page) {
    final viewModel = Provider.of<AddUserChatViewModel>(context, listen: false);
    viewModel.getUsers(1, (String? error) {
      if (error != null) {
        Dialogs().showDefaultAlertDialog(context, "Alert", error ?? "");
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      initSocketOn();
    } else if (state == AppLifecycleState.paused) {
      initSocketOff();
    }
    // else if (state == AppLifecycleState.inactive) {
    //   debugPrint("inactive");
    // }else if (state == AppLifecycleState.detached) {
    //   debugPrint("detached");
    // }else if (state == AppLifecycleState.hidden) {
    //   debugPrint("hidden");
    // }
  }

  void _onSearchChanged() {
    final viewModel = Provider.of<AddUserChatViewModel>(context, listen: false);
    viewModel.searchData(_searchController.text);
  }

  void _onScroll() {
    final viewModel = Provider.of<AddUserChatViewModel>(context, listen: false);
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent &&
        viewModel.limit <= viewModel.data.length) {
      // End of the list reached

      viewModel.loadMore();
    }

    // Determine whether to show or hide the search bar
    bool isScrollingDown = _scrollController.position.userScrollDirection ==
        ScrollDirection.reverse;
    if (isScrollingDown && _isSearchVisible) {
      setState(() => _isSearchVisible = false);
    } else if (!isScrollingDown && !_isSearchVisible) {
      setState(() => _isSearchVisible = true);
    }
  }

  void _handleCellTap(HomeScreenModel user, String tag) {

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChattingScreen(user: user, tag: tag)));

  }

  void _handleImageTap(HomeScreenModel user, String tag) {
    //Provider.of<AddUserChatViewModel>(context, listen: false).onImageTap(user);
    Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      pageBuilder: (BuildContext context, _, __) {
        return ProfileDialogScreen(
            tag: tag, user: user); // Custom full-screen modal route
      },
    ));
  }

  Future<void> _refresh() async {
    // Perform your refresh action here
    callApi(1);
  }

  Future<void> getPosition() async {
    final homeScreenViewModel = Provider.of<AddUserChatViewModel>(context,listen: false);
    try {
      Position position = await LocationService().determinePosition();
      debugPrint("Locations ==> ${position.latitude}, ${position.longitude}");
      bool isNeedToApiCall = homeScreenViewModel.setPosition(position);
      // updateApi Here
      if (isNeedToApiCall){
        callApi(1);
      }else if (position == null && homeScreenViewModel.data.isEmpty){
        callApi(1);
      }
    } catch (e) {
      // Handle exceptions/errors
      debugPrint('Error occurred: $e');
      if(homeScreenViewModel.data.isEmpty){
        callApi(1);
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Add Chat"), actions: [
        IconButton(
          icon: const Icon(Icons.my_location),
          onPressed: () => getPosition(),
        )
      ],),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: _body(),
      ),
    );
  }

  Widget _body() {
    final homeScreenViewModel = Provider.of<AddUserChatViewModel>(context);
    final isLoading = homeScreenViewModel.isLoginLoading;
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverAppBar(
          floating: false,
          pinned: false,
          automaticallyImplyLeading: false,
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
              return RepaintBoundary(
                child: UserItem(
                  tag: 'profile-hero$index',
                  isSelected: false,
                  imageUrl: user.photo,
                  username: user.username,
                  message: user.message,
                  date: user.date,
                  count: user.count,
                  onCellTap: () => _handleCellTap(user, 'profile-hero$index'),
                  onImageTap: () => _handleImageTap(user, 'profile-hero$index'),
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
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  void initSocketOff() {
    final socket = Provider.of<WebSocketManager>(context, listen: false);
    socket.off(ApiEndpoints.receiveMessage);
  }

  void initSocketOn() {
    final socket = Provider.of<WebSocketManager>(context, listen: false);
    socket.on(ApiEndpoints.receiveMessage, (SocketResponse model) {
      if (model.data != null) {
        ChattingScreenModel chatModel =
        ChattingScreenModel.fromJson(model.data!);
        final socketViewModel =
        Provider.of<ChattingScreenViewModel>(context, listen: false);
        debugPrint(
            "print init ${socketViewModel.receiverProfile?.id} == ${chatModel.receiverProfile.id}");
        if (socketViewModel.receiverProfile?.id == chatModel.receiverProfile.id) {
          debugPrint("you are in chatting screen");
        } else {
          debugPrint("Chatting screen is closed");
        }
      } else {
        debugPrint("print init fail");
      }
    });
  }
}

