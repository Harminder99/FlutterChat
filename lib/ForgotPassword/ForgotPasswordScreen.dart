import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/ForgotPassword/ForgotPasswordViewModel.dart';

import '../Reuseables/CircleImage.dart';
import '../Reuseables/CustomButton.dart';
import '../Reuseables/GradientButton.dart';
import '../Reuseables/PasswordTextFormField.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),
      body: const ForgotPasswordScreenForm(),
    );
  }
}

class ForgotPasswordScreenForm extends StatefulWidget {
  const ForgotPasswordScreenForm({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreenForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    final loginViewModel = Provider.of<ForgotPasswordViewModel>(context);
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
                    const Text("Forgot Password", style: TextStyle(
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
                    GradientButton(
                      marginTop: 30,
                      gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.purple],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      onPressed: () {
                        if (loginViewModel.validateAndSaveForm(_formKey)) {
                          // Perform login logic using ViewModel
                        }
                      },
                      child: const Text(
                        'Reset',
                      ),
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