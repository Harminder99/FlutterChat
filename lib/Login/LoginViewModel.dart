import 'package:flutter/cupertino.dart';

class LoginViewModel extends ChangeNotifier {
  String _email = '';
  String _password = '';

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
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

  void loginApi() {}
}
