import 'package:flutter/cupertino.dart';
import 'package:untitled2/Utiles/Utiles.dart';

import '../Home/HomeScreenModel.dart';
import '../NetworkApi/ApiEndpoints.dart';
import '../NetworkApi/ApiResponse.dart';
import '../NetworkApi/ApiService.dart';
import '../NetworkApi/HeaderService.dart';


class AddUserChatViewModel extends ChangeNotifier {
  bool _isLoginLoading = false;
  final int _limit = 10;
  String _searchTxt = "";
  int _page = 1;
  List<HomeScreenModel> _data = [];
  List<HomeScreenModel> _userData = [];

  List<HomeScreenModel> get data => _userData;

  int get limit => _limit;

  String get searchTxt => _searchTxt;
  ApiService? _apiService;

  AddUserChatViewModel() {
    _apiService = ApiService(HeaderService());
  }

  ApiService get apiService {
    _apiService ??= ApiService(HeaderService());
    return _apiService!;
  }

  bool get isLoginLoading => _isLoginLoading;

  void startLoading() {
    _isLoginLoading = true;
    notifyListeners();
  }

  void hideLoading() {
    _isLoginLoading = false;
    notifyListeners();
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
      debugPrint("_data ==> ${_data.length} $searchTxt");
      _userData = _data;
      notifyListeners();
    }else  if (searchTxt.length > 3) {
      _userData = _data.where((user) {
        return user.username.toLowerCase().contains(searchTxt.toLowerCase());
      }).toList();

      notifyListeners();
    }
  }

  void onImageTap(HomeScreenModel user) {
    // Handle image tap logic here
    debugPrint("Image tapped for user: ${user.username}");
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
