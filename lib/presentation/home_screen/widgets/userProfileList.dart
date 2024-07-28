import 'package:flutter/material.dart';
import 'package:healther/core/app_export.dart';
import 'package:healther/models/comments_model.dart';

class UserProfileList extends StatelessWidget {
  final Comment comment;

  const UserProfileList({required this.comment, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.h,
        vertical: 6.h,
      ),
      decoration: AppDecoration.fillOnPrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46.h,
            height: 46.h,
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 4.h),
            decoration: AppDecoration.fillBlueGray.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder22,
            ),
            child: Text(
              comment.name[0].toUpperCase(),
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
          ),
          SizedBox(width: 12.h),
          Expanded(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Name: ",
                          style: TextStyle(
                            color: appTheme.blueGray100,
                            fontSize: 16.fSize,
                            fontFamily: 'Poppins',
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            comment.name,
                            style: TextStyle(
                              color: appTheme.black900,
                              fontSize: 16.fSize,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(
                      children: [
                        Text(
                          "Email: ",
                          style: TextStyle(
                            color: appTheme.blueGray100,
                            fontSize: 16.fSize,
                            fontFamily: 'Poppins',
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            comment.email,
                            style: TextStyle(
                              color: appTheme.black900,
                              fontSize: 16.fSize,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      comment.body,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: appTheme.black900,
                        fontSize: 16.fSize,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
