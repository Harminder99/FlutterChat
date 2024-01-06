import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import '../../Reuseables/ChatBubble.dart';
import '../../Reuseables/RichTextWithReadMore.dart';
import 'DocumentCell.dart';
import 'ImageCell.dart';
import '../ChattingScreenModel.dart';
import '../ChattingScreenViewModel.dart';
import 'VideoCell.dart';

class ChatMessagesList extends StatefulWidget {
  const ChatMessagesList({super.key});

  @override
  _ChatMessagesListState createState() => _ChatMessagesListState();
}

class _ChatMessagesListState extends State<ChatMessagesList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
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
    final viewModel = Provider.of<ChattingScreenViewModel>(context);
    final width = MediaQuery.of(context).size.width;
    return ListView.builder(
      reverse: true,
      controller: _scrollController,
      itemCount: viewModel.messages.length + (viewModel.isLoadingMore ? 1 : 0),
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
        List<ChattingScreenModel> messages = viewModel.messages[month]?.reversed.toList() ?? [];

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
            children: messages
                .asMap()
                .entries
                .map((entry) {
              int itemIndex = entry.key;
              ChattingScreenModel message = entry.value;
              return GestureDetector(
                onTap: () {
                  if (viewModel.selectedMessages.isNotEmpty) {
                    viewModel.handleSelection(message.id);
                  } else {
                    debugPrint("tap");
                  }
                },
                onLongPress: () {
                  viewModel.handleSelection(message.id);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: viewModel.selectedMessages.contains(message.id)
                        ? Colors.grey[300]
                        : Colors.transparent,
                  ),
                  child: ChatBubble(
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
            })
                .toList() ?? [],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
}
