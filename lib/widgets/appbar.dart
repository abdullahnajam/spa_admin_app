import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:spa_admin_app/navigator/bottom_navigation.dart';
import 'package:spa_admin_app/utils/constants.dart';
typedef void MyCallback();
class CustomAppBar extends StatefulWidget {

  String title;

  CustomAppBar(this.title);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
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
          context.locale.languageCode=="en"?
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => BottomBar()));
              },
              icon: Icon(Icons.arrow_back_sharp,color: darkBrown,),
            ),
          ):
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => BottomBar()));
              },
              icon: Icon(Icons.arrow_back_sharp,color: darkBrown,),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(widget.title),
          )
        ],
      ),
    );
  }
}

