import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:spa_admin_app/navigator/bottom_navigation.dart';
import 'package:spa_admin_app/utils/constants.dart';
typedef void MyCallback();
class CustomAppBarTitleOnly extends StatefulWidget {
  String title;

  CustomAppBarTitleOnly(this.title);

  @override
  _CustomAppBarTitleOnlyState createState() => _CustomAppBarTitleOnlyState();
}

class _CustomAppBarTitleOnlyState extends State<CustomAppBarTitleOnly> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 0.15, color: darkBrown),
        ),
      ),
      height:  AppBar().preferredSize.height,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(widget.title),
          )
        ],
      ),
    );
  }
}

