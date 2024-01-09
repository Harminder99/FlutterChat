import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Home/HomeScreen.dart';
import '../Login/LoginViewModel.dart';
import '../Reuseables/CircleImage.dart';
import '../Reuseables/GradientButton.dart';
import '../Reuseables/PasswordTextFormField.dart';
import '../Utiles/Dialogs.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: const SignUpScreenForm(),
    );
  }
}

class SignUpScreenForm extends StatefulWidget {
  const SignUpScreenForm({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreenForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    final signupViewModel = Provider.of<LoginViewModel>(context);
    return SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Align(
          alignment: Alignment.topCenter,
          child: Card(
            margin: EdgeInsets.only(top: screenHeight * 0.1),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 300),
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text("Sign Up",
                        style: TextStyle(
                          fontSize: 24,
                        )),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              // TODO: Handle CircleImage tap
                              signupViewModel.pickImage();
                            },
                            child: CircleImage(
                              imageFile: signupViewModel.getImage(),
                              // File object for a local image
                              imageUrl: 'https://picsum.photos/200',
                              // URL string for a network image
                              size: 100.0,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: 2, bottom: 2, right: 2, left: 2),
                            child: const SizedBox(
                              width: 102.0, // Slightly larger than CircleImage
                              height: 102.0,
                              child: CircularProgressIndicator(
                                value: 1,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: -10,
                            child: IconButton(
                              icon: const Icon(Icons.add_circle),
                              onPressed: () {
                                // TODO: Handle plus icon button tap
                                signupViewModel.pickImage();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: TextFormField(
                        textCapitalization: TextCapitalization.none,
                        validator: (value) => value != null && value!.isNotEmpty
                            ? value.length > 5
                                ? null
                                : "Enter minimum 6 characters"
                            : "Enter username",
                        onSaved: (value) => signupViewModel.setName(value!),
                        decoration: const InputDecoration(labelText: 'Name'),
                      ),
                    ),
                    TextFormField(
                      textCapitalization: TextCapitalization.none,
                      validator: (value) => EmailValidator.validate(value!)
                          ? null
                          : "Invalid email",
                      onSaved: (value) => signupViewModel.setEmail(value!),
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    PasswordTextFormField(
                      onSaved: (value) => signupViewModel.setPassword(value),
                    ),
                    PasswordTextFormField(
                      placeholder: "Confirm password",
                      onSaved: (value) =>
                          signupViewModel.setConfirmPassword(value),
                      validator: (value) {
                        if (value != signupViewModel.getPassword()) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),
                    GradientButton(
                      marginTop: 20,
                      gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.purple],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      onPressed: () {
                        if (signupViewModel
                            .validateAndSaveSignUpForm(_formKey)) {
                          signupViewModel.signUpApi((error) {
                            if (error == null) {
                              // success
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const HomeScreen()),
                                    (Route<dynamic> route) => false, // This condition ensures all routes are removed
                              );
                            } else {
                              // fail
                              Dialogs().showDefaultAlertDialog(
                                  context, "Alert", error!);
                            }
                          });
                        }
                      },
                      child: const Text(
                        'Sign up',
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () {
                          // TODO: Implement forgot password functionality
                        },
                        child: const Text('Already have account?',
                            style: TextStyle(
                                color: Colors.lightBlue, fontSize: 13)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
