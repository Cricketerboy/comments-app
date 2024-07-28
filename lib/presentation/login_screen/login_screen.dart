import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healther/core/app_export.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passFocusNode = FocusNode();
  bool _isLoggingIn = false;
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    setState(() {
      _isLoggingIn = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.toLowerCase().trim(),
        password: password.text.trim(),
      );
      // Check if user exists
      Navigator.pushReplacementNamed(context, AppRoutes.homeScreen);
    } catch (e) {
      String errorMessage = "Invalid Email or Password. Please try again.";
      if (e is FirebaseAuthException) {
        if (email.text.isEmpty || password.text.isEmpty) {
          errorMessage = 'All fields are required';
        }
      }
      print("Failed to sign in: $errorMessage");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
      ));
      setState(() {
        _isLoggingIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.only(top: 14.h),
            child: Text(
              "Comments",
              style: theme.textTheme.titleLarge,
            ),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SizedBox(
                height: SizeUtils.height,
                child: Form(
                  key: _key,
                  child: Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.h,
                      vertical: 50.h,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 150.h),
                        _buildEmail(context),
                        SizedBox(height: 18.h),
                        _buildPass(context),
                        SizedBox(height: 230.h),
                        _buildLoginButton(context),
                        SizedBox(height: 12.h),
                        GestureDetector(
                          onTap: () {
                            onTapSignUp(context);
                          },
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "New here?",
                                  style: theme.textTheme.bodyLarge,
                                ),
                                TextSpan(
                                  text: " ",
                                ),
                                TextSpan(
                                  text: "SignUp",
                                  style: CustomTextStyles.titleMediumPrimary,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (_isLoggingIn)
              Container(
                color: Colors.grey.withOpacity(0.34),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmail(BuildContext context) {
    return TextFormField(
      cursorColor: theme.colorScheme.primary,
      textInputAction: TextInputAction.next,
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(_passFocusNode),
      keyboardType: TextInputType.emailAddress,
      controller: email,
      validator: (value) {
        if (value!.isEmpty) {
          return 'This field is missing';
        } else {
          return null;
        }
      },
      style: TextStyle(color: appTheme.black900),
      decoration: InputDecoration(
        hintText: 'Email',
        hintStyle: theme.textTheme.bodyLarge,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.h),
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 0.5,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 14.h,
          vertical: 4.v,
        ),
      ),
    );
  }

  Widget _buildPass(BuildContext context) {
    return TextFormField(
      cursorColor: theme.colorScheme.primary,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      controller: password,
      validator: (value) {
        if (value!.isEmpty) {
          return 'This field is missing';
        } else {
          return null;
        }
      },
      style: TextStyle(color: appTheme.black900),
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: theme.textTheme.bodyLarge,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.h),
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 0.5,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 14.h,
          vertical: 4.v,
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return CustomElevatedButton(
      buttonStyle: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(15.h), // Set the border radius here
        ),
        backgroundColor: theme.colorScheme.primary,
      ),
      onPressed: () {
        _signInWithEmailAndPassword(context);
      },
      width: 220.h,
      height: 55.h,
      text: "Login",
      textWidth: 87.h,
      textHeight: 24.v,
    );
  }

  onTapSignUp(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.signUpScreen);
  }

  onTapLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.homeScreen);
  }
}
