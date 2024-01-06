import 'package:flutter/cupertino.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  String _email = '';

  void setEmail(String email) {
    _email = email;
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

  void forgotPasswordApi() {


  }
}
