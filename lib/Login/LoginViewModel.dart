import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../NetworkApi/ApiEndpoints.dart';
import '../NetworkApi/ApiResponse.dart';
import '../NetworkApi/ApiService.dart';
import '../NetworkApi/HeaderService.dart';
import 'LoginModel.dart';

class LoginViewModel extends ChangeNotifier {
  String _name = "";
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  XFile? selectedImage;
  ApiService? _apiService;
  bool _isLoginLoading = false;
  LoginModel? _model;

  LoginViewModel() {
    _apiService = ApiService(HeaderService());
  }

  ApiService get apiService {
    _apiService ??= ApiService(HeaderService());
    return _apiService!;
  }

  bool get isLoginLoading => _isLoginLoading;

  LoginModel? get model => _model;

  String getEmail() {
    return _email;
  }

  String getPassword() {
    return _password;
  }

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  XFile? getImage() {
    return selectedImage;
  }

  void setConfirmPassword(String password) {
    _confirmPassword = password;
    notifyListeners();
  }

  String? validatePasswordsMatch() {
    debugPrint("$_password === $_confirmPassword");
    if (_password != _confirmPassword) {
      return "Passwords do not match";
    }
    return null;
  }

  bool validateAndSaveForm(GlobalKey<FormState> formKey) {
    final form = formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  bool validateAndSaveSignUpForm(GlobalKey<FormState> formKey) {
    final form = formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      // Check if passwords match
      String? passwordValidationMessage = validatePasswordsMatch();
      if (passwordValidationMessage != null) {
        // If passwords do not match, show an error message or handle it accordingly
        // You can use a method to display the error or set a state that triggers an error message in the UI
        return false;
      }
      return true;
    }
    return false;
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    // final LostDataResponse response = await picker.retrieveLostData();
    // if (response.isEmpty) {
    //   return;
    // }
    // final List<XFile>? files = response.files;
    // Pick an image
    final XFile? image = await picker.pickImage(
        source: ImageSource.gallery); // or ImageSource.camera for camera

    if (image != null) {
      debugPrint(image.path);
      selectedImage = image;
      notifyListeners();
    }
  }

  void cancelLoginApi() {
    _isLoginLoading = false;
    _apiService?.cancelApi(ApiEndpoints.loginEndpoint);
    notifyListeners();
  }

  void startLoading() {
    _isLoginLoading = true;
    notifyListeners();
  }

  void hideLoading() {
    _isLoginLoading = false;
    notifyListeners();
  }

  void loginApi(Function(String? error) onComplete) async {
    startLoading();
    ApiResponse<LoginModel>? response = await _apiService?.post<LoginModel>(
      ApiEndpoints.loginEndpoint,
      {'email': _email, 'password': _password},
      (json) => LoginModel.fromJson(json),
    );
    hideLoading();
    if (response != null && response!.isSuccess) {
      // Handle success scenario
      _model = response.data!;
      Global.authToken = _model?.token;
      Global.userId = _model?.id;
      onComplete(null);
    } else {
      // Handle error scenario
      ApiError? error = response?.error;
      debugPrint("Error: ${error?.message ?? "Something went wrong!"}");
      // Handle the error message as needed
      onComplete(error?.message ?? "Something went wrong!");
    }
  }

  void signUpApi(Function(String? error) onComplete) async {
    startLoading();
    ApiResponse<LoginModel>? response = await _apiService?.post<LoginModel>(
      ApiEndpoints.signUpEndpoint,
      {
        "name" : _name,
        'email': _email,
        'password': _password,
        "confirmPassword": _confirmPassword
      },
      (json) => LoginModel.fromJson(json),
    );
    hideLoading();
    if (response != null && response!.isSuccess) {
      // Handle success scenario
      _model = response.data!;
      Global.authToken = _model?.token;
      Global.userId = _model?.id;
      onComplete(null);
    } else {
      // Handle error scenario
      ApiError? error = response?.error;
      debugPrint("Error: ${error?.message ?? "Something went wrong!"}");
      // Handle the error message as needed
      onComplete(error?.message ?? "Something went wrong!");
    }
  }
}
