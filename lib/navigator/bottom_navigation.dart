import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spa_admin_app/screens/bookings.dart';
import 'package:spa_admin_app/screens/homepage.dart';
import 'package:spa_admin_app/screens/my_profile.dart';
import 'package:spa_admin_app/utils/constants.dart';

class BottomBar extends StatefulWidget {

  @override
  _BottomNavigationState createState() => new _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomBar>{


  int _currentIndex = 1;

  List<Widget> _children=[];

  @override
  void initState() {
    super.initState();


    _children = [
      MyProfile(),
      HomePage(),
      Bookings(),

    ];

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        backgroundColor: Color(0xffF0F0F0),
        index: 2,
        color: lightBrown,
        items: <Widget>[
          Icon(Icons.account_circle_outlined,color: Colors.white, size: 30),
          Icon(Icons.home,color: Colors.white, size: 30),
          Icon(Icons.calendar_today,color: Colors.white, size: 30),

        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

        },
      ),
      body: _children[_currentIndex],
    );
  }




}
