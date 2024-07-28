import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healther/presentation/home_screen/home_screen.dart';
import 'package:healther/presentation/login_screen/login_screen.dart';

class UserState extends StatelessWidget {
  const UserState({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, userSnapshot) {
        if (userSnapshot.data == null) {
          print('User is not login yet');
          return LoginScreen();
        } else if (userSnapshot.hasData) {
          print('User already logged in yet');
          return HomeScreen();
        } else if (userSnapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                'An error has occurred. Try again later',
              ),
            ),
          );
        } else if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Scaffold(
          body: Center(
            child: Text('Something went wrong'),
          ),
        );
      },
    );
  }
}
