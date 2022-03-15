import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:spa_admin_app/models/appointment_model.dart';
import 'package:spa_admin_app/models/user_model.dart';
import 'package:spa_admin_app/navigator/bottom_navigation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:spa_admin_app/screens/login.dart';
import 'package:spa_admin_app/screens/my_profile.dart';
import 'package:spa_admin_app/screens/notifications.dart';
import 'package:spa_admin_app/screens/reports.dart';
import 'package:spa_admin_app/utils/constants.dart';
import 'package:spa_admin_app/utils/dark_mode.dart';

class MenuDrawer extends StatefulWidget {


  @override
  MenuDrawerState createState() => new MenuDrawerState();
}


class MenuDrawerState extends State<MenuDrawer> {

  String getMonthName(int monthNumber){
    String name="";
    switch(monthNumber) {
      case 1: {  name="January"; }
      break;
      case 2: {  name="February"; }
      break;
      case 3: {  name="March"; }
      break;
      case 4: {  name="April"; }
      break;
      case 5: {  name="May"; }
      break;
      case 6: {  name="June"; }
      break;
      case 7: {  name="July"; }
      break;
      case 8: {  name="August"; }
      break;
      case 9: {  name="September"; }
      break;
      case 10: {  name="October"; }
      break;
      case 11: {  name="November"; }
      break;
      case 12: {  name="December"; }
      break;
      default: { name="January"; }
      break;
    }
    return name;
  }

  _showChangeLanguageDailog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          insetAnimationDuration: const Duration(seconds: 1),
          insetAnimationCurve: Curves.fastOutSlowIn,
          elevation: 2,

          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text('changeLanguage'.tr(),textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.w600),),
                ),
                ListTile(
                  onTap: (){
                    context.locale = Locale('ar', 'EG');
                    Navigator.pushReplacement(context, new MaterialPageRoute(
                        builder: (context) => BottomBar()));
                  },
                  title: Text("عربى"),
                ),
                ListTile(
                  onTap: (){
                    context.locale = Locale('en', 'US');
                    Navigator.pushReplacement(context, new MaterialPageRoute(
                        builder: (context) => BottomBar()));
                  },
                  title: Text("English"),
                ),
                SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
        );
      },
    );
  }
  void onDrawerItemClicked(String name){
    Navigator.pop(context);
  }


  Future<String> getSideBarImage()async{
    String sideBarUrl="";
    await FirebaseFirestore.instance.collection('settings').doc('app_data').get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          sideBarUrl=data['sideBar'];
        });
      }
    });
    print("side bar image $sideBarUrl");
    return sideBarUrl;
  }
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Drawer(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20,),
              FutureBuilder<DocumentSnapshot>(
                future:  FirebaseFirestore.instance.collection('admins').doc(FirebaseAuth.instance.currentUser!.uid).get(),
                builder:
                    (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                  if (snapshot.hasError) {
                    return Text("Something went wrong");
                  }

                  if (snapshot.hasData && !snapshot.data!.exists) {
                    return Text("");
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                    return InkWell(
                        onTap: (){
                          print("admin id ${snapshot.data!.reference.id}");
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MyProfile()));

                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 100,
                              width: 100,

                              decoration: BoxDecoration(
                                border: Border.all(color: darkBrown),
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(data['profilePicture'])
                                  )
                              ),
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  data['username'],
                                  style: Theme.of(context).textTheme.headline6!.apply(color: Colors.black),
                                ),
                                Text(
                                  data['email'],
                                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
                                ),
                                Text(
                                  data['phone'],
                                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
                                ),
                              ],
                            )

                          ],
                        )
                    );
                  }

                  return Text("-");
                },
              ),

              Container(height: 8),

/*
              Container(height: 10),
              InkWell(onTap: (){
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) => Login()));
              },
                child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.p, color: Colors.grey, size: 20),
                      Container(width: 20),
                      Expanded(child: Text('support'.tr(), style: TextStyle(color: Colors.grey))),
                    ],
                  ),
                ),
              ),*/
              Container(height: 10),
              InkWell(onTap: ()async{
                final ProgressDialog pr = ProgressDialog(context: context);
                pr.show(max: 100, msg: "Please wait");
                getMonthName(DateTime.now().month);
                List<String> months=[];
                List<int> income=[];
                for(int i =0 ; i<5 ; i++){
                  months.add(getMonthName(DateTime.now().month-i));
                  income.add(0);
                }
                await FirebaseFirestore.instance.collection('appointments').where("status",isEqualTo: "Completed").get().then((QuerySnapshot querySnapshot) {
                  querySnapshot.docs.forEach((doc) {
                    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                    AppointmentModel model=AppointmentModel.fromMap(data, doc.reference.id);
                    for(int i =0 ; i<5 ; i++){
                      if(months[i]==getMonthName(data['month'])){
                        setState(() {
                          income[i]+=int.parse(model.amount);
                        });
                      }
                    }
                  });
                });
                pr.close();
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) => Reports(months,income)));
              },
                child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.list_alt_outlined, color: Colors.grey, size: 20),
                      Container(width: 20),
                      Expanded(child: Text("Reports", style: TextStyle(color: Colors.grey))),
                    ],
                  ),
                ),
              ),
              Container(height: 10),
              InkWell(onTap: (){
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) => NotificationList()));
              },
                child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.notifications, color: Colors.grey, size: 20),
                      Container(width: 20),
                      Expanded(child: Text("Notifications", style: TextStyle(color: Colors.grey))),
                    ],
                  ),
                ),
              ),
              Container(height: 10),
              InkWell(onTap: (){
                FirebaseAuth.instance.signOut().then((value) => Navigator.push(context, new MaterialPageRoute(
                    builder: (context) => Login()))).onError((error, stackTrace) => print("error ${error.toString()}"));

              },
                child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.exit_to_app, color: Colors.grey, size: 20),
                      Container(width: 20),
                      Expanded(child: Text('logout'.tr(), style: TextStyle(color: Colors.grey))),
                    ],
                  ),
                ),
              ),






            ],
          ),
        )
      ),
    );
  }




}
