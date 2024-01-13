import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:untitled2/Home/HomeScreenViewModel.dart';

import '../../NetworkApi/ApiEndpoints.dart';
import '../../NetworkApi/SocketResponse.dart';
import '../../NetworkApi/WebSocketManager.dart';
import '../../Reuseables/ChatBubble.dart';
import '../../Reuseables/RichTextWithReadMore.dart';
import '../../main.dart';
import '../ChattingScreenModel.dart';
import '../ChattingScreenViewModel.dart';

class ChatMessagesList extends StatefulWidget {
  const ChatMessagesList({super.key});

  @override
  _ChatMessagesListState createState() => _ChatMessagesListState();
}

class _ChatMessagesListState extends State<ChatMessagesList>
    with WidgetsBindingObserver, RouteAware {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController.addListener(_onScroll);
    final viewModel =
        Provider.of<ChattingScreenViewModel>(context, listen: false);
    viewModel.isChatScreenVisible = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.updateSeenAllEmit(context);
    });
    // you can do this with scroll like if reach end make it zero, and visible cell count - 1 there is so many ways
    //homeViewModel.updateCountToZeroById(viewModel.receiverProfile?.id ??"");
  }

  @override
  void didPushNext() {
    // TODO: implement didPushNext

    super.didPushNext();
    debugPrint("didPushNext chat");
    final viewModel =
        Provider.of<ChattingScreenViewModel>(context, listen: false);
    viewModel.isChatScreenVisible = false;
  }

  @override
  void didPopNext() {
    // TODO: implement didPopNext
    super.didPopNext();
    debugPrint("didPopNext chat");
// come from another screen
    final viewModel =
        Provider.of<ChattingScreenViewModel>(context, listen: false);
    final homeViewModel =
        Provider.of<HomeScreenViewModel>(context, listen: false);
    viewModel.isChatScreenVisible = true;
    // you can do this with scroll like if reach end make it zero, and visible cell count - 1 there is so many ways
    homeViewModel.updateCountToZeroById(viewModel.receiverProfile?.id ?? "");
  }

  @override
  void didPush() {
    // TODO: implement didPush
    super.didPush();
    debugPrint("didPush chat");
  }

  @override
  void didPop() {
    // TODO: implement didPop
    super.didPop();
    debugPrint("didPop chat");
    final viewModel =
        Provider.of<ChattingScreenViewModel>(context, listen: false);
    final homeViewModel =
        Provider.of<HomeScreenViewModel>(context, listen: false);
    viewModel.isChatScreenVisible = false;
    // you can do this with scroll like if reach end make it zero, and visible cell count - 1 there is so many ways
    homeViewModel.updateCountToZeroById(viewModel.receiverProfile?.id ?? "");
  }

  void _onScroll() {
    if (_scrollController.position.atEdge) {
      bool isTop = _scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent;
      if (isTop) {
        // Logic when reaching the top of the list
        debugPrint("Reached the top of the list");
        final viewModel =
            Provider.of<ChattingScreenViewModel>(context, listen: false);
        viewModel.loadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel =
        Provider.of<ChattingScreenViewModel>(context, listen: true);
    //final width = MediaQuery.of(context).size.width;
    if (viewModel.messages.isEmpty) {
      return  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Say hii, to ${viewModel.receiverProfile?.name ?? ""}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      );
    } else {
      return ListView.builder(
        key: UniqueKey(),
        reverse: true,
        controller: _scrollController,
        itemCount:
            viewModel.messages.length + (viewModel.isLoadingMore ? 1 : 0),
        // Add one for loading indicator
        itemBuilder: (context, index) {
          if (index == viewModel.messages.length && viewModel.isLoadingMore) {
            // Show loading indicator at the top
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          var month = viewModel.messages.keys.elementAt(index);
          List<ChattingScreenModel> messages =
              viewModel.messages[month]?.reversed.toList() ?? [];

          return StickyHeader(
            header: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                    color: Theme.of(context).cardColor,
                    child: Text(
                      DateFormat('d MMM yyyy').format(month),
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    )),
              ),
            ),
            content: Column(
              children: messages.asMap().entries.map((entry) {
                // int itemIndex = entry.key;
                ChattingScreenModel message = entry.value;
                return GestureDetector(
                  onTap: () {
                    if (viewModel.selectedMessages.isNotEmpty) {
                      viewModel.handleSelection(message.messageId);
                    } else {
                      debugPrint("tap");
                    }
                  },
                  onLongPress: () {
                    viewModel.handleSelection(message.messageId);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          viewModel.selectedMessages.contains(message.messageId)
                              ? Colors.grey[300]
                              : Colors.transparent,
                    ),
                    child: ChatBubble(
                      date: message.date,
                      status: message.status,
                      isSender: message.isSender,
                      verticalPadding: 8,
                      horizontalPadding: 8,
                      child: RichTextWithReadMore(text: message.message),
                      // child: DocumentCell(
                      //   size: width * 0.4,
                      //   message: message, heroTag: 'video$itemIndex',
                      // ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      );
    }
  }

  @override
  void dispose() {
    debugPrint("dispose chat");
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint("Resumed chat");
      final viewModel =
          Provider.of<ChattingScreenViewModel>(context, listen: false);
      viewModel.isChatScreenVisible = true;
    } else if (state == AppLifecycleState.paused) {
      debugPrint("Pause chat");
      final viewModel =
          Provider.of<ChattingScreenViewModel>(context, listen: false);
      viewModel.isChatScreenVisible = false;
    }
  }
}
