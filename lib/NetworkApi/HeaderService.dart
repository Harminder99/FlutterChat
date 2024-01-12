import 'package:flutter/cupertino.dart';

import '../Login/LoginViewModel.dart';

class HeaderService {

  HeaderService();

  Map<String, String> getHeaders(String? apiEndPoint) {
    // Example header with basic authentication
    String basicAuth = "bearer ${Global.authToken}";
    return {
      'Authorization': basicAuth,
      // Add other headers as needed
    };
  }
}

class Global {
  static String? authToken;
  static String? userId;
}

