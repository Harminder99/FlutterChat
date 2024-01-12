import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:untitled2/Utiles/LocationService.dart';
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
  Position? _position;

  int get limit => _limit;

  Position? get position => _position;

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

  bool setPosition(Position p) {

    if (_position == null) {
      debugPrint("init location");
      _position = p;
      return true;
    } else if (!LocationService.isWithInRadius(
        p.latitude,
        p.longitude,
        _position!.latitude,
        _position!.longitude,
        LocationService.getKMFromMeters(100))) {
      _position = p;
      debugPrint("location");
      return true;
    } else {
      debugPrint("init location else");
    }
    return false;
  }

  void startLoading() {
    _isLoginLoading = true;
    notifyListeners();
  }

  void hideLoading() {
    _isLoginLoading = false;
    notifyListeners();
  }

  void getUsers(int page, Function(String? error) onComplete) async {
    startLoading();

    final body = {
      "coordinates": [_position?.latitude, _position?.longitude],
      "distance": 100
    };
    debugPrint("body ===> $body");
    ApiResponse<List<HomeScreenModel>>? response =
        await _apiService?.getWithBody<List<HomeScreenModel>>(
      ApiEndpoints.usersEndpoint,
      "",
      body,
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
    } else if (searchTxt.length > 3) {
      _userData = _data.where((user) {
        return user.name.toLowerCase().contains(searchTxt.toLowerCase());
      }).toList();

      notifyListeners();
    }
  }

  void onImageTap(HomeScreenModel user) {
    // Handle image tap logic here
    debugPrint("Image tapped for user: ${user.name}");
  }
}
