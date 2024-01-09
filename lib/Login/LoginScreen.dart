import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/ForgotPassword/ForgotPasswordScreen.dart';
import 'package:untitled2/Home/HomeScreen.dart';
import 'package:untitled2/Utiles/Dialogs.dart';

import '../Reuseables/CircleImage.dart';
import '../Reuseables/CustomButton.dart';
import '../Reuseables/GradientButton.dart';
import '../Reuseables/PasswordTextFormField.dart';
import '../Signup/SignupScreen.dart';
import 'LoginViewModel.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // appBar: AppBar(title: const Text("Login")),
      body: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    final loginViewModel = Provider.of<LoginViewModel>(context);
    return SizedBox(
      height: screenHeight,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Center(
          child: Card(
            margin: EdgeInsets.only(top: screenHeight * 0.15),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 300),
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text("Login",
                        style: TextStyle(
                          fontSize: 24,
                        )),
                    const CircleImage(
                      marginTop: 30,
                      imageUrl: 'https://picsum.photos/200',
                      size: 100.0, // Optional, specify the size you want
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: TextFormField(
                        textCapitalization: TextCapitalization.none,
                        validator: (value) => EmailValidator.validate(value!)
                            ? null
                            : "Invalid email",
                        onSaved: (value) => loginViewModel.setEmail(value!),
                        decoration: const InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    PasswordTextFormField(
                      onSaved: (value) => loginViewModel.setPassword(value),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () {
                          loginViewModel.cancelLoginApi();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordScreen()));
                        },
                        child: const Text('Forgot Password?',
                            style: TextStyle(
                                color: Colors.lightBlue, fontSize: 13)),
                      ),
                    ),
                    GradientButton(
                      marginTop: 10,
                      isLoading: loginViewModel.isLoginLoading,
                      gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.purple],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      onPressed: () {
                        if (loginViewModel.validateAndSaveForm(_formKey)) {
                          // Perform login logic using ViewModel
                          //loginViewModel.startLoading();
                          loginViewModel.loginApi((error){
                            if (error != null) {
                              Dialogs().showDefaultAlertDialog(
                                  context, "Alert", error!);
                            } else {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const HomeScreen()),
                                    (Route<dynamic> route) => false, // This condition ensures all routes are removed
                              );
                            }
                          });
                        }
                      },
                      child: const Text(
                        'Login',
                      ),
                    ),
                    CustomButton(
                      width: 1,
                      marginTop: 10,
                      text: 'Signup',
                      onPressed: () {
                        loginViewModel.cancelLoginApi();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
