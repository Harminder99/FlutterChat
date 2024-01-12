import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/Chatting/ChattingScreenModel.dart';
import 'package:untitled2/Utiles/Utiles.dart';

import '../NetworkApi/ApiEndpoints.dart';
import '../NetworkApi/ApiResponse.dart';
import '../NetworkApi/ApiService.dart';
import '../NetworkApi/HeaderService.dart';
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
    _data.insert(0, HomeScreenModel.updateModelFromChatModel(chatModel));
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
      } else {
        addNewUser(chatModel);
      }
      notifyListeners();
    }
  }

  void getUsers(int page, Function(String? error) onComplete) async {
    // Implement your logic to fetch data here
    // For example, fetch data from an API and add it to _data

    // Simulating network call
    // _data.clear();
    // _data.addAll(createDummyUsers());
    // _userData = _data;
    // Future.microtask(() => notifyListeners());
    startLoading();
    ApiResponse<List<HomeScreenModel>>? response =
        await _apiService?.get<List<HomeScreenModel>>(
      ApiEndpoints.usersEndpoint,
      "",
      (json) {
        final data = json["data"];
        if (data is List) {
          return data
              .map((item) => HomeScreenModel.fromJson(item))
              .toList(); // Convert each item individually
        } else {
          debugPrint("Error in format");
          throw const FormatException("Invalid response format");
        }
      },
    );
    hideLoading();
    if (response != null && response!.isSuccess) {
      // Handle success scenario
      _userData = response.data!;
      _data = _userData;
      notifyListeners();
    } else {
      // Handle error scenario
      ApiError? error = response?.error;
      debugPrint("Error: ${error?.message ?? "Something went wrong!"}");
      // Handle the error message as needed
      onComplete(error?.message ?? "Something went wrong!");
    }
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
        return user.username.toLowerCase().contains(searchTxt.toLowerCase());
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
      debugPrint("Cell tapped for user: ${user.username}");
      return true;
    }
  }

  void onImageTap(HomeScreenModel user) {
    // Handle image tap logic here
    debugPrint("Image tapped for user: ${user.username}");
  }

  void onLongTap(HomeScreenModel user) {
    // Handle image tap logic here
    debugPrint("Cell Long tapped for user: ${user.username}");
    enableMultiSelection();
    toggleUserSelection(user.id);
  }

  List<HomeScreenModel> createDummyUsers() {
    List<HomeScreenModel> users = [];

    for (int i = 1; i <= 110; i++) {
      users.add(HomeScreenModel(
          id: 'id_$i',
          username:
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
}
