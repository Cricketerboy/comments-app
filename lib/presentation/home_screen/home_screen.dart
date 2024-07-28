import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healther/controller/comments_controller.dart';
import 'package:provider/provider.dart';
import 'package:healther/models/comments_model.dart';
import 'package:healther/core/app_export.dart';
import 'package:healther/presentation/home_screen/widgets/userProfileList.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CommentsController>(context, listen: false).fetchComments();
    });
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.loginScreen,
                  (route) => false,
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80.h,
          title: Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Text(
              "Comments",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.fSize,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          backgroundColor: theme.colorScheme.primary,
          actions: [
            IconButton(
              onPressed: () {
                _showLogoutDialog(context);
              },
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: Consumer<CommentsController>(
          builder: (context, controller, child) {
            if (controller.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (controller.comments.isEmpty) {
              return Center(child: Text('No comments found'));
            }

            return Container(
              width: double.maxFinite,
              margin: EdgeInsets.fromLTRB(16.h, 26.h, 16.h, 4.h),
              child: SingleChildScrollView(
                child: Column(
                  children: [_buildUserProfile(context, controller.comments)],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildUserProfile(BuildContext context, List<Comment> comments) {
    return SizedBox(
      width: double.maxFinite,
      child: ListView.separated(
        padding: EdgeInsets.zero,
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (context, index) {
          return SizedBox(
            height: 14.h,
          );
        },
        itemCount: comments.length,
        itemBuilder: (context, index) {
          return UserProfileList(comment: comments[index]);
        },
      ),
    );
  }
}
