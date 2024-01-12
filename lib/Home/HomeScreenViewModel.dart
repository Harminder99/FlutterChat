import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/Chatting/ChattingScreenModel.dart';
import 'package:untitled2/Utiles/Utiles.dart';

import '../NetworkApi/ApiEndpoints.dart';
import '../NetworkApi/ApiResponse.dart';
import '../NetworkApi/ApiService.dart';
import '../NetworkApi/HeaderService.dart';
import '../Utiles/DatabaseHelper.dart';
import 'HomeScreenModel.dart';

class HomeScreenViewModel extends ChangeNotifier {
  bool _isLoginLoading = false;
  bool _isSearchEnable = false;
  final int _limit = 10;
  String _searchTxt = "";
  int _page = 1;
  List<HomeScreenModel> _data = [];
  List<HomeScreenModel> _userData = [];

  List<HomeScreenModel> get data {
    _userData.sort((a, b) => (b.date ?? DateTime(0)).compareTo(a.date ?? DateTime(0)));
    return _userData;
  }
  int get limit => _limit;

  String get searchTxt => _searchTxt;

  bool get isSearchEnable => _isSearchEnable;
  bool _isMultiSelectionEnabled = false;
  final Set<String> _selectedUserIds = {};

  bool get isMultiSelectionEnabled => _isMultiSelectionEnabled;

  Set<String> get selectedUserIds => _selectedUserIds;
  ApiService? _apiService;

  HomeScreenViewModel() {
    _apiService = ApiService(HeaderService());
  }

  ApiService get apiService {
    _apiService ??= ApiService(HeaderService());
    return _apiService!;
  }

  bool get isLoginLoading => _isLoginLoading;

  void enableMultiSelection() {
    _isMultiSelectionEnabled = true;
    notifyListeners();
  }

  void disableMultiSelection() {
    _isMultiSelectionEnabled = false;
    _selectedUserIds.clear();
    notifyListeners();
  }

  void toggleUserSelection(String userId) {
    if (_selectedUserIds.contains(userId)) {
      _selectedUserIds.remove(userId);
    } else {
      _selectedUserIds.add(userId);
    }
    if (_selectedUserIds.isEmpty) {
      disableMultiSelection();
      return;
    }
    notifyListeners();
  }

  // HomeScreenViewModel() {
  //   getUsers(_page);
  // }

  void startLoading() {
    _isLoginLoading = true;
    notifyListeners();
  }

  void hideLoading() {
    _isLoginLoading = false;
    notifyListeners();
  }

  void addNewUser(ChattingScreenModel chatModel) {
    debugPrint("Added new User");
    HomeScreenModel model = HomeScreenModel.updateModelFromChatModel(chatModel);
    _data.insert(0, model);
    addUser(model);
    notifyListeners();
  }

  void updateCountToZero(HomeScreenModel model) {
    final indexMain =
    _data.indexWhere((element) => element.id == model.id);
    if (indexMain >= 0) {
      model.count = 0;
      _data[indexMain] = model;
    }
    notifyListeners();
  }

  void updateCountToZeroById(String id) {
    final indexMain = _data.indexWhere((element) => element.id == id);
    if (indexMain >= 0) {
      final model = _data[indexMain];
      model.count = 0;
      _data[indexMain] = model;
    }
    notifyListeners();
  }

  void updateListMessage(ChattingScreenModel chatModel, bool isCountUpdate) {
    if (_isSearchEnable) {
      final index =
          _userData.indexWhere((element) => element.id == chatModel.receiverProfile.id);
      final indexMain =
          _data.indexWhere((element) => element.id == chatModel.receiverProfile.id);
      if (indexMain >= 0 || index >= 0) {
        debugPrint("Update Search User");
        if (indexMain >= 0) {
          final userChat = _data[indexMain];
          if (isCountUpdate) {
            userChat.count = userChat.count + 1;
          }
          userChat.message = chatModel.message;
          userChat.date = chatModel.date;
          _data[indexMain] = userChat;
          addUser(userChat);
        }
        if (index >= 0) {
          final userChat = _userData[index];
          if (isCountUpdate) {
            userChat.count = userChat.count + 1;
          }
          userChat.message = chatModel.message;
          userChat.date = chatModel.date;
          _userData[index] = userChat;
        }
      } else {
        addNewUser(chatModel);
      }
      notifyListeners();
    } else {
      final index = _data.indexWhere((element) => element.id == chatModel.receiverProfile.id);
      if (index >= 0) {
        final userChat = _data[index];
        if (isCountUpdate) {
          userChat.count = userChat.count + 1;
        }
        userChat.message = chatModel.message;
        userChat.date = chatModel.date;
        _data[index] = userChat;
        addUser(userChat);
      } else {
        addNewUser(chatModel);
      }
      notifyListeners();
    }
  }

  void deleteUsers() async {
    await DatabaseHelper().removeUsers(_selectedUserIds);
    for (String id in _selectedUserIds) {
      _userData.removeWhere((element) => element.id == id);
      _data.removeWhere((element) => element.id == id);
    }

    _selectedUserIds.clear();
    if (_selectedUserIds.isEmpty) {
      disableMultiSelection();
      return;
    }
  }

  void getUsers() async {
   _data = await DatabaseHelper().getUsersByLoginId();
   _userData = _data;
   notifyListeners();
  }

  void loadMore() {
    _page++;
    debugPrint("Next Page $_page");
    //getUsers(_page);
  }

  void searchData(String searchTxt) {
    _searchTxt = searchTxt;
    if (searchTxt.length < 3) {
      _isSearchEnable = false;
      debugPrint("_data ==> ${_data.length} $searchTxt");
      _userData = _data;
      notifyListeners();
    } else if (searchTxt.length > 3) {
      _isSearchEnable = true;
      _userData = _data.where((user) {
        return user.name.toLowerCase().contains(searchTxt.toLowerCase());
      }).toList();

      notifyListeners();
    }
  }

  bool onCellTap(HomeScreenModel user) {
    // Handle cell tap logic here
    if (isMultiSelectionEnabled) {
      toggleUserSelection(user.id);
      return false;
    } else {
      // Handle regular tap
      debugPrint("Cell tapped for user: ${user.name}");
      return true;
    }
  }

  void onImageTap(HomeScreenModel user) {
    // Handle image tap logic here
    debugPrint("Image tapped for user: ${user.name}");
  }

  void onLongTap(HomeScreenModel user) {
    // Handle image tap logic here
    debugPrint("Cell Long tapped for user: ${user.name}");
    enableMultiSelection();
    toggleUserSelection(user.id);
  }

  List<HomeScreenModel> createDummyUsers() {
    List<HomeScreenModel> users = [];

    for (int i = 1; i <= 110; i++) {
      users.add(HomeScreenModel(
          id: 'id_$i',
          name:
              'User \nMy name is Harminder Singh Saini , You would like to talk $i',
          email: 'user$i@example.com',
          photo: 'https://example.com/photo$i.jpg',
          message:
              'This is \n a message  from user, \nMy name is Harminder Singh Saini , You would like to talk $i',
          date: DateTime.now(),
          count: Utils.generateRandomNumber()));
    }

    return users;
  }

  //Database Operations
  Future<void> addUser(HomeScreenModel user) async {
    await DatabaseHelper().addUser(user);
    notifyListeners();
  }
}
