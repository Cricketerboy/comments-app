import 'package:flutter/material.dart';
import 'package:healther/presentation/home_screen/home_screen.dart';
import 'package:healther/presentation/login_screen/login_screen.dart';
import 'package:healther/presentation/signup_screen/signup_screen.dart';

class AppRoutes {
  static const String signUpScreen = '/sign_up_screen';
  static const String loginScreen = '/login_screen';

  static const String homeScreen = '/home_screen';

  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> routes = {
    signUpScreen: (context) => SignupScreen(),
    loginScreen: (context) => LoginScreen(),
    homeScreen: (context) => HomeScreen(),
    initialRoute: (context) => SignupScreen()
  };
}
