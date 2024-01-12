import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/AddChating/AddUserChatViewModel.dart';
import 'package:untitled2/Chatting/ChattingScreenViewModel.dart';
import 'package:untitled2/ForgotPassword/ForgotPasswordViewModel.dart';
import 'package:untitled2/Home/HomeScreenViewModel.dart';
import 'package:untitled2/NetworkApi/WebSocketManager.dart';
import 'Login/LoginScreen.dart';
import 'Login/LoginViewModel.dart';
import 'Utiles/ThemeNotifier.dart';
import 'package:flutter/scheduler.dart';
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
void main() {
  timeDilation = 2.0;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => WebSocketManager()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordViewModel()),
        ChangeNotifierProvider(create: (_) => HomeScreenViewModel()),
        ChangeNotifierProvider(create: (_) => ChattingScreenViewModel()),
        ChangeNotifierProvider(create: (_) => AddUserChatViewModel()),
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
      navigatorObservers: [routeObserver],
      debugShowCheckedModeBanner: false,
      theme: themeNotifier.getTheme(),
      home: const LoginScreen(),
    );
  }
}

