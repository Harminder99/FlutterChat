import 'package:flutter/cupertino.dart';
import 'package:untitled2/Utiles/Utiles.dart';

import 'HomeScreenModel.dart';

class HomeScreenViewModel extends ChangeNotifier {
  final int _limit = 10;
   String _searchTxt = "";
  int _page = 1;
   final List<HomeScreenModel> _data = []; // Replace MyDataType with your data type
   List<HomeScreenModel> _userData = [];

  List<HomeScreenModel> get data => _userData;
  int get limit => _limit;
  String get searchTxt => _searchTxt;
  bool _isMultiSelectionEnabled = false;
  final Set<String> _selectedUserIds = {};

  bool get isMultiSelectionEnabled => _isMultiSelectionEnabled;
  Set<String> get selectedUserIds => _selectedUserIds;

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
    if(_selectedUserIds.isEmpty){
      disableMultiSelection();
      return;
    }
    notifyListeners();
  }
  // HomeScreenViewModel() {
  //   getUsers(_page);
  // }

  void getUsers(int page) async {
    // Implement your logic to fetch data here
    // For example, fetch data from an API and add it to _data

    // Simulating network call
    _data.clear();
    _data.addAll(createDummyUsers());
    _userData = _data;
    Future.microtask(() => notifyListeners());
  }

  void loadMore() {

    _page++;
    debugPrint("Next Page $_page");
    //getUsers(_page);
  }

  void searchData(String searchTxt){
    _searchTxt = searchTxt;
    if (searchTxt.length < 3) {
      _userData = _data;
    }

    _userData = _data.where((user) {
      return user.username.toLowerCase().contains(searchTxt.toLowerCase());
    }).toList();

    notifyListeners();
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
        username: 'User \nMy name is Harminder Singh Saini , You would like to talk $i',
        email: 'user$i@example.com',
        photo: 'https://example.com/photo$i.jpg',
        message: 'This is \n a message  from user, \nMy name is Harminder Singh Saini , You would like to talk $i',
        date: DateTime.now(),
        count: Utils.generateRandomNumber()
      ));
    }

    return users;
  }

}
