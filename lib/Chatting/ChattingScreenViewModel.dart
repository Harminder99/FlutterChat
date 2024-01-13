import 'package:flutter/cupertino.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/Chatting/ReceiverProfile.dart';
import 'package:untitled2/Home/HomeScreenModel.dart';
import 'package:untitled2/Home/HomeScreenViewModel.dart';
import 'package:untitled2/NetworkApi/ApiEndpoints.dart';
import 'package:untitled2/NetworkApi/WebSocketManager.dart';
import 'package:untitled2/Utiles/Utiles.dart';

import '../NetworkApi/CallBackSocketModel.dart';
import '../Utiles/DatabaseHelper.dart';
import 'ChattingScreenModel.dart';

class ChattingScreenViewModel extends ChangeNotifier {
  bool isChatScreenVisible = false;
  HomeScreenModel? _userModel;
  String _inputText = '';
  bool _isEmojiVisible = false;
  final bool _isLoadingMore = false;
  final Set<String> _selectedMessages = {}; // add message _id
  ReceiverProfile? _receiverProfile;

  String get inputText => _inputText;

  bool get isLoadingMore => _isLoadingMore;

  Set<String> get selectedMessages => _selectedMessages;

  bool get isSendButtonVisible => _inputText.isNotEmpty;
  final List<ChattingScreenModel> _messages = [];

  var conversation = [
    "Hey, how's it going?",
    "I'm good, thanks! How about you?",
    "Pretty good, just working on a project right now.",
    "Oh cool, what kind of project is it?",
    "It's a new mobile app I'm developing.",
    "That sounds interesting. What does the app do?",
    "It helps people manage their personal finances.",
    "I could use something like that. Is it available yet?",
    "Not yet, still in the beta testing phase.",
    "Well, let me know when it's out. I'd love to try it.",
    "Definitely, I'll send you a link once it's ready.",
    "Thanks! So, what are you up to this weekend?",
    "Not much, just planning to relax at home. You?",
    "I was thinking of going hiking. The weather looks great.",
    "That sounds like a good idea. Where do you plan to go?",
    "There's a trail nearby that I've been wanting to check out.",
    "Nice, I've heard it's a beautiful area.",
    "Yeah, it's supposed to have some great views.",
    "Well, have fun and be safe!",
    "Thanks! We should catch up sometime next week.",
    "Absolutely, let's plan for coffee on Tuesday?",
    "Tuesday works for me. What time?",
    "How about 10 AM at the usual place?",
    "Perfect. See you then!",
    "Looking forward to it. Have a great hike!",
    "Thanks, see you Tuesday!",
    "Hey, just wanted to say the coffee was great today.",
    "I agree, it was nice catching up.",
    "We should do this more often.",
    "Definitely. How's the app coming along?",
    "Good news, the app is going live next week!",
    "That's awesome! Congratulations!",
    "Thanks! I'm pretty excited about it.",
    "You should be. It's a big achievement.",
    "I appreciate that. I'll send you the link when it's up.",
    "Looking forward to it. Let's celebrate soon.",
    "For sure. How about dinner next Friday?",
    "Sounds good to me. Any place in mind?",
    "How about that new Italian restaurant downtown?",
    "Perfect. I've been wanting to try it. See you then!",
    "Visit Google website at https://www.google.com for more information, join the conversation on research using #ArtificialIntelligence, and don't forget to follow @Harminder for the latest updates."
  ];
  Map<DateTime, List<ChattingScreenModel>> _messagesGroup = {};

  Map<DateTime, List<ChattingScreenModel>> get messages => _messagesGroup;

  ReceiverProfile? get receiverProfile => _receiverProfile;

  void setEmojiVisible(bool isShow) {
    _isEmojiVisible = isShow;
    notifyListeners();
  }

  void setReceiverProfile(ReceiverProfile profile) {
    _receiverProfile = profile;
  }

  void setUserModel(HomeScreenModel model) {
    _userModel = model;
    notifyListeners();
  }

  HomeScreenModel? getUserModel() {
    return _userModel;
  }

  bool isEmojiVisible() {
    return _isEmojiVisible;
  }

  void setInputText(String text) {
    _inputText = text.trim();
    notifyListeners();
  }

  void receiveMessage(ChattingScreenModel model) {
    _messages.insert(0, model);
    _messagesGroup = groupChatMessages(_messages);
    notifyListeners();
  }

  void updateStatus(ChattingScreenModel chatModel) {
    final index = _messages
        .indexWhere((element) => element.messageId == chatModel.messageId);
    debugPrint("updateStatus ==> $index == ${chatModel.messageId}");
    if (index >= 0) {
      final message = _messages[index];
      message.status = chatModel.status;
      _messages[index] = message;
      _messagesGroup = groupChatMessages(_messages);
      notifyListeners();
    }
    updateIntoDataBase(chatModel);
  }

  void updateStatusEmit(BuildContext context, ChattingScreenModel chatModel,
      MessageStatus status) {
    final viewModel = Provider.of<WebSocketManager>(context, listen: false);
    final model = ChattingScreenModel(
        isSender: true,
        message: "",
        date: DateTime.now(),
        status: status,
        messageId: chatModel.messageId,
        receiverProfile: _receiverProfile!);
    viewModel.emit(ApiEndpoints.sendMessage, {
      ...model.toJson(),
      ...{"event": ApiEndpoints.oneToOneStatus}
    });
  }

  void updateSeenAllEmit(BuildContext context) {
    final viewModel = Provider.of<WebSocketManager>(context, listen: false);
    final data = {
      "receiverProfile": _receiverProfile?.toJson() ?? {},
      "event": ApiEndpoints.oneToOneStatus,
      "status": MessageStatus.seen.toString().split('.').last,
      "date": DateTime.timestamp().toUtc().toIso8601String(),
    };
    viewModel.emit(ApiEndpoints.sendMessage, data);
  }

  void sendMessage(BuildContext context, TextEditingController textController) {
    if (_inputText.isNotEmpty) {
      final msgId = Utils.generateUniqueString();
      final model = ChattingScreenModel(
          isSender: true,
          message: _inputText,
          date: DateTime.now(),
          status: MessageStatus.sending,
          messageId: msgId,
          receiverProfile: _receiverProfile!);
      debugPrint("Message Sent ==> $msgId");
      _messages.insert(0, model);
      _messagesGroup = groupChatMessages(_messages);
      addIntoDataBase(model);
      final viewModel = Provider.of<WebSocketManager>(context, listen: false);
      final homeModel =
          Provider.of<HomeScreenViewModel>(context, listen: false);
      homeModel.updateListMessage(model, false);
      viewModel.emitWithCallBack(ApiEndpoints.sendMessage, {
        ...model.toJson(),
        ...{"event": ApiEndpoints.oneToOneChat}
      }, (CallBackSocketModel model) {
        if (model.status == ApiEndpoints.success) {
          debugPrint("Wah!");
          final index = _messages
              .indexWhere((element) => element.messageId == model.messageId);
          debugPrint("index ==> $index == ${model.messageId}");
          if (index >= 0) {
            final message = _messages[index];
            message.status = MessageStatus.sent;
            _messages[index] = message;
            _messagesGroup = groupChatMessages(_messages);
            notifyListeners();
            updateIntoDataBase(message);
          }
        } else {
          debugPrint("Oops!");
        }
      });
      _inputText = "";
      textController.clear();
      notifyListeners();
    }
  }

  void handleSelection(String id) {
    if (_selectedMessages.contains(id)) {
      _selectedMessages.removeWhere((element) => element == id);
    } else {
      _selectedMessages.add(id);
    }
    notifyListeners();
  }

  void clearMessageSelection() {
    _selectedMessages.clear();
    notifyListeners();
  }

  bool validateAndSaveForm(GlobalKey<FormState> formKey) {
    final form = formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  List<ChattingScreenModel> createDummyMessages() {
    List<ChattingScreenModel> users = [];
    DateTime endDate = DateTime.now().subtract(const Duration(days: 10));

    for (int i = 0; i <= 5; i++) {
      if (i >= 0 && i < conversation.length) {
        // Subtract days from the end date to go back in time
        DateTime messageDate = endDate.subtract(Duration(days: i));
        users.add(ChattingScreenModel(
            isSender: i % 2 == 0,
            message: conversation[i],
            date: messageDate,
            status: MessageStatus.sent,
            messageId: Utils.generateUniqueString(),
            receiverProfile: _receiverProfile!));
      }
    }

    return users;
  }

  Map<DateTime, List<ChattingScreenModel>> groupChatMessages(
      List<ChattingScreenModel> messages) {
    Map<DateTime, List<ChattingScreenModel>> groupedMessages = {};

    messages.sort((a, b) => b.date.compareTo(a.date));

    DateTime currentDate = Jiffy.now().startOf(Unit.day).dateTime;

    for (var message in messages) {
      DateTime messageDate = message.date;
      DateTime groupDate;

      if (currentDate.difference(messageDate).inDays <= 15) {
        // Messages within the last 15 days
        groupDate =
            Jiffy.parseFromDateTime(messageDate).startOf(Unit.day).dateTime;
      } else {
        // Older messages grouped by week
        groupDate =
            Jiffy.parseFromDateTime(messageDate).startOf(Unit.week).dateTime;
      }

      if (!groupedMessages.containsKey(groupDate)) {
        groupedMessages[groupDate] = [];
      }
      groupedMessages[groupDate]!.add(message);
    }

    return groupedMessages;
  }

  void getChatting() async {
    _messages.clear();
    // _messages.addAll(createDummyMessages());
    // _messagesGroup = groupChatMessages(_messages);
    List<ChattingScreenModel> msg =
        await DatabaseHelper().getChatMessages(0, receiverProfile?.id ?? "");
    Future.microtask(() {
      _messages.addAll(msg);
      _messagesGroup = groupChatMessages(_messages);
      notifyListeners();
    });
  }

  void loadMore() {}

  void addIntoDataBase(ChattingScreenModel model) async {
    await DatabaseHelper().addChatMessage(model);
  }

  void updateIntoDataBase(ChattingScreenModel model) async {
    await DatabaseHelper().updateChatMessage(model);
  }

  void deleteIntoDataBase() async {
    debugPrint("deleteIntoDataBase init");
    if (_selectedMessages.isNotEmpty) {
      debugPrint("deleteIntoDataBase start");
      await DatabaseHelper().removeChatMessages(_selectedMessages);
      for (String id in _selectedMessages) {
        _messages.removeWhere((element) => element.messageId == id);
      }
      _selectedMessages.clear();
      _messagesGroup = groupChatMessages(_messages);
      debugPrint("deleteIntoDataBase finish");
      notifyListeners();
    }
  }

  void deleteAllDataBase() async {
    debugPrint("deleteAllDataBase init");
    await DatabaseHelper().removeAllMessages(receiverProfile?.id ?? "");
    _messages.clear();
    _selectedMessages.clear();
    _messagesGroup.clear();
    debugPrint("deleteAllDataBase finish");
    notifyListeners();
  }
}
