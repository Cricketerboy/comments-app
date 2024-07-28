import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healther/core/app_export.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _isregisterIn = false;
  final FocusNode _emailFocusNode = FocusNode();

  final FocusNode _passFocusNode = FocusNode();

  final FocusNode _nameFocusNode = FocusNode();
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  Future<void> _signUpWithEmailAndPassword(BuildContext context) async {
    setState(() {
      _isregisterIn = true;
    });
    RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.toLowerCase().trim(),
        password: password.text.trim(),
      );

      // Check if user already exists in Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (userDoc.exists) {
        // User already exists, show error message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("User already exists. Please login."),
        ));
        // Navigate to login screen
        Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          'name': name.text.toLowerCase().trim(),
          'email': email.text.toLowerCase().trim(),
        }).then((_) {
          Navigator.pushReplacementNamed(context, AppRoutes.homeScreen);
        }).catchError((error) {
          print("Failed to set day in Firestore: $error");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Failed to set day in Firestore."),
          ));
          setState(() {
            _isregisterIn = false;
          });
        });
      }
    } catch (e) {
      print("Failed to sign up: $e");
      String errorMessage = "Failed to sign up. Please try again.";

      if (e is FirebaseAuthException) {
        if (name.text.isEmpty || email.text.isEmpty || password.text.isEmpty) {
          errorMessage = 'All fields are required';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'The email address is already in use.';
        } else if (!emailRegex.hasMatch(email.text.trim())) {
          errorMessage = 'Please use a valid Email Address';
        } else if (password.text.trim().length < 6) {
          errorMessage =
              'Password is too weak. Please use a password with at least 5 characters.';
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
      ));
      setState(() {
        _isregisterIn = false;
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
                        SizedBox(height: 90.h),
                        _buildName(context),
                        SizedBox(height: 18.h),
                        _buildEmail(context),
                        SizedBox(height: 18.h),
                        _buildPass(context),
                        SizedBox(height: 220.h),
                        _buildSignUpButton(context),
                        SizedBox(height: 12.h),
                        GestureDetector(
                          onTap: () {
                            onTapLogin(context);
                          },
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Already have an account?",
                                  style: theme.textTheme.bodyLarge,
                                ),
                                TextSpan(
                                  text: " ",
                                ),
                                TextSpan(
                                    text: "Login",
                                    style: CustomTextStyles.titleMediumPrimary),
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
            if (_isregisterIn)
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

  // Section Widget
  Widget _buildName(BuildContext context) {
    return TextFormField(
      cursorColor: theme.colorScheme.primary,
      textInputAction: TextInputAction.next,
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(_emailFocusNode),
      keyboardType: TextInputType.emailAddress,
      controller: name,
      validator: (value) {
        if (value!.isEmpty) {
          return 'This field is missing';
        } else {
          return null;
        }
      },
      style: TextStyle(color: appTheme.black900),
      decoration: InputDecoration(
        hintText: 'Name',
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

  Widget _buildSignUpButton(BuildContext context) {
    return CustomElevatedButton(
      buttonStyle: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(15.h), // Set the border radius here
        ),
        backgroundColor: theme.colorScheme.primary,
      ),
      onPressed: () {
        _signUpWithEmailAndPassword(context);
      },
      width: 220.h,
      height: 55.h,
      text: "SignUp",
      textWidth: 87.h,
      textHeight: 24.v,
    );
  }

  onTapSignUp(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.homeScreen);
  }

  onTapLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
  }
}
