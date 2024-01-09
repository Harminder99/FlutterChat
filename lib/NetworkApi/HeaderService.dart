import '../Login/LoginViewModel.dart';

class HeaderService {
  final LoginViewModel _loginViewModel;

  HeaderService(this._loginViewModel);

  Map<String, String> getHeaders() {
    // Example header with basic authentication
    String basicAuth = "Basic ${_loginViewModel.model?.token}";
    return {
      'Authorization': basicAuth,
      // Add other headers as needed
    };
  }
}
