

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class SignUpViewModel extends ChangeNotifier {
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
   XFile? selectedImage;

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  XFile? getImage() {
    return selectedImage;
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  void setConfirmPassword(String password) {
    _confirmPassword = password;
    notifyListeners();
  }



  String? validatePasswordsMatch() {
    if (_password != _confirmPassword) {
      return "Passwords do not match";
    }
    return null;
  }


  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    // final LostDataResponse response = await picker.retrieveLostData();
    // if (response.isEmpty) {
    //   return;
    // }
    // final List<XFile>? files = response.files;
    // Pick an image
    final XFile? image = await picker.pickImage(source: ImageSource.gallery); // or ImageSource.camera for camera

    if (image != null) {
      if (kDebugMode) {
        print(image.path);
      }
      selectedImage = image;
      notifyListeners();
    }
  }

  bool validateAndSaveForm(GlobalKey<FormState> formKey) {
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

  void loginApi() {}
}
