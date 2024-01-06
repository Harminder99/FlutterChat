import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/Chatting/ChattingScreenViewModel.dart';
import 'package:untitled2/ForgotPassword/ForgotPasswordViewModel.dart';
import 'package:untitled2/Home/HomeScreenViewModel.dart';
import 'Login/LoginScreen.dart';
import 'Login/LoginViewModel.dart';
import 'Signup/SignUpViewModel.dart';
import 'Utiles/ThemeNotifier.dart';
import 'package:flutter/scheduler.dart';

void main() {
  timeDilation = 2.0;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => SignUpViewModel()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordViewModel()),
        ChangeNotifierProvider(create: (_) => HomeScreenViewModel()),
        ChangeNotifierProvider(create: (_) => ChattingScreenViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeNotifier.getTheme(),
      home: const LoginScreen(),
    );
  }
}

