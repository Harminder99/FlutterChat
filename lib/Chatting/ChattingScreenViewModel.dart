import 'package:flutter/cupertino.dart';
import 'package:untitled2/Chatting/ReceiverProfile.dart';
import 'package:untitled2/Home/HomeScreenModel.dart';

import 'ChattingScreenModel.dart';

class ChattingScreenViewModel extends ChangeNotifier {
  HomeScreenModel? _userModel;
  String _inputText = '';
  bool _isEmojiVisible = false;
  final bool _isLoadingMore = false;
  final Set<String> _selectedMessages = {}; // add message _id

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


  Map<DateTime, List<ChattingScreenModel>> get messages => _groupMessagesByWeek(_messages);

  void setEmojiVisible(bool isShow) {
    _isEmojiVisible = isShow;
    notifyListeners();
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

  void sendMessage(TextEditingController textController) {
    if (_inputText.isNotEmpty) {
      _messages.insert(0, ChattingScreenModel(
          isSender: true,
          message: _inputText,
          date: DateTime.now(),
          status: MessageStatus.sent,
          id: "1",
          receiverProfile: ReceiverProfile(name: 'Maninder', id: "1", photo: "")));
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
    DateTime startDate = DateTime.now().subtract(const Duration(days: 50));
    for (int i = 0; i <= conversation.length; i++) {
      if(i >= 0 && i < conversation.length) {
        DateTime messageDate = startDate.add(Duration(days: i));
        users.add(ChattingScreenModel(
            isSender: i % 2 == 0,  // Alternating sender for demonstration
            message: conversation[i],
            date: messageDate,
            status: MessageStatus.sent,
            id: "${i + 1}",
            receiverProfile: ReceiverProfile(
                name: 'Maninder', id: "1", photo: "")
        ));
      }
    }

    return users;
  }

  // Method to group messages by the start of their month
  // Map<DateTime, List<ChattingScreenModel>> _groupMessagesByMonth(List<ChattingScreenModel> messages) {
  //   Map<DateTime, List<ChattingScreenModel>> groupedMessages = {};
  //   for (var message in messages) {
  //     // Get the first day of the month for each message
  //     var month = DateTime(message.date.year, message.date.month);
  //     if (!groupedMessages.containsKey(month)) {
  //       groupedMessages[month] = [];
  //     }
  //     groupedMessages[month]!.add(message);
  //   }
  //   return groupedMessages;
  // }

  // group weekly
  Map<DateTime, List<ChattingScreenModel>> _groupMessagesByWeek(List<ChattingScreenModel> messages) {
    Map<DateTime, List<ChattingScreenModel>> groupedMessages = {};

    for (var message in messages) {
      // Get the start of the week for each message
      DateTime startOfWeek = _getStartOfWeek(message.date);

      if (!groupedMessages.containsKey(startOfWeek)) {
        groupedMessages[startOfWeek] = [];
      }
      groupedMessages[startOfWeek]!.add(message);
    }
    return groupedMessages;
  }

  DateTime _getStartOfWeek(DateTime date) {
    // Assuming week starts on Monday
    // Calculate the number of days to subtract to get to the last Monday
    int daysToSubtract = (date.weekday - DateTime.monday) % 7;
    return DateTime(date.year, date.month, date.day - daysToSubtract);
  }


  void getChatting() {
    debugPrint("START CHATTING");
    _messages.clear();
    debugPrint("ASK CHATTING");
    _messages.addAll(createDummyMessages());
    debugPrint("NOTIFY CHATTING");
    Future.microtask(() => notifyListeners());
  }

  void loadMore(){

  }
}
