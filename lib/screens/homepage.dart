import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:spa_admin_app/models/calendar.dart';
import 'package:spa_admin_app/models/service_model.dart';
import 'package:spa_admin_app/navigator/navigation_drawer.dart';
import 'package:spa_admin_app/screens/bookings.dart';
import 'package:spa_admin_app/screens/calendar_display.dart';
import 'package:spa_admin_app/screens/categories.dart';
import 'package:spa_admin_app/screens/customer.dart';
import 'package:spa_admin_app/screens/offers.dart';
import 'package:spa_admin_app/screens/promo_codes.dart';
import 'package:spa_admin_app/screens/reviews.dart';
import 'package:spa_admin_app/screens/services.dart';
import 'package:spa_admin_app/search/search_service.dart';
import 'package:spa_admin_app/utils/constants.dart';
import 'package:easy_localization/easy_localization.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  void _openDrawer () {
    _drawerKey.currentState!.openDrawer();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      key: _drawerKey,
      drawer: MenuDrawer(),
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.25,
            decoration: BoxDecoration(
              color: lightBrown,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              )
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      IconButton(onPressed: _openDrawer , icon: Icon(Icons.menu,color: Colors.white,)),
                      SizedBox(width: 10,),
                      Text("Admin Panel App",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 18),)

                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: ()async{
                            List<ServiceModel> services=[];
                            FirebaseFirestore.instance.collection('services')
                                .where("isActive",isEqualTo: true)
                                .where("isFeatured",isEqualTo: true).get().then((QuerySnapshot querySnapshot) {
                              querySnapshot.docs.forEach((doc) {
                                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                                ServiceModel model=ServiceModel.fromMap(data, doc.reference.id);
                                setState(() {
                                  services.add(model);
                                });
                              });
                              print("size1 ${services.length}");
                            }).then((value){
                              showSearch<String>(
                                context: context,
                                delegate: ServiceSearch(services),
                              );
                            });
                            print("size ${services.length}");

                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width*0.63,
                            height: 50,
                            margin: EdgeInsets.only(right: 5,left: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(40)
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(Icons.search),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('search'.tr())
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      /*InkWell(
                        onTap: (){
                          //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SelectGender("Home")));
                        },
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width*0.15,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.wc_outlined)
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SelectGender("Home")));
                        },
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width*0.15,
                          child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(Icons.roofing_outlined)
                          ),
                        ),
                      ),*/

                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Bookings()));

                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height*0.15,
                      margin: EdgeInsets.fromLTRB(10, 10, 5, 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: darkBrown,
                            child: Icon(Icons.assignment_turned_in),
                          ),
                          SizedBox(height: 10,),
                          Text("Bookings")
                        ],
                      )
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: ()async{
                      final ProgressDialog pr = ProgressDialog(context: context);
                      pr.show(max: 100, msg: "Loading");
                      List<Meeting> meetings = <Meeting>[];
                      await FirebaseFirestore.instance.collection('appointments').get().then((QuerySnapshot querySnapshot) {querySnapshot.docs.forEach((doc) async {
                        if (doc['status'] == "Completed") {
                          meetings.add(Meeting(
                              "${doc["time"]} ${doc["serviceName"]}",
                              DateTime.fromMillisecondsSinceEpoch(
                                  doc["dateBooked"]),
                              DateTime.fromMillisecondsSinceEpoch(
                                  doc["dateBooked"]),
                              const Color(0xff6CFF33),
                              true));
                        }
                        else if (doc['status'] == "Pending") {
                          meetings.add(Meeting(
                              "${doc["time"]} ${doc["serviceName"]}",
                              DateTime.fromMillisecondsSinceEpoch(
                                  doc["dateBooked"]),
                              DateTime.fromMillisecondsSinceEpoch(
                                  doc["dateBooked"]),
                              const Color(0xffFFBE33),
                              true));
                        }
                        else if (doc['status'] == "Cancelled") {
                          meetings.add(Meeting(
                              "${doc["time"]} ${doc["serviceName"]}",
                              DateTime.fromMillisecondsSinceEpoch(
                                  doc["dateBooked"]),
                              DateTime.fromMillisecondsSinceEpoch(
                                  doc["dateBooked"]),
                              const Color(0xffF93030),
                              true));
                        }
                        else if (doc['status'] == "Approved") {
                          meetings.add(Meeting(
                              "${doc["time"]} ${doc["serviceName"]}",
                              DateTime.fromMillisecondsSinceEpoch(
                                  doc["dateBooked"]),
                              DateTime.fromMillisecondsSinceEpoch(
                                  doc["dateBooked"]),
                              const Color(0xff8D7A51),
                              true));
                        }
                       
                      });
                      });
                      pr.close();
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => CalendarDisplay(meetings)));

                    },
                    child: Container(
                        height: MediaQuery.of(context).size.height*0.15,
                        margin: EdgeInsets.fromLTRB(10, 10, 5, 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: darkBrown,
                              child: Icon(Icons.calendar_today),
                            ),
                            SizedBox(height: 10,),
                            Text("Calendar")
                          ],
                        )
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Reviews()));
                    },
                    child: Container(
                        height: MediaQuery.of(context).size.height*0.15,
                        margin: EdgeInsets.fromLTRB(10, 10, 5, 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: darkBrown,
                              child: Icon(Icons.star),
                            ),
                            SizedBox(height: 10,),
                            Text("Reviews")
                          ],
                        )
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Customers()));
                    },
                    child: Container(
                        height: MediaQuery.of(context).size.height*0.15,
                        margin: EdgeInsets.fromLTRB(10, 10, 5, 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: darkBrown,
                              child: Icon(Icons.person),
                            ),
                            SizedBox(height: 10,),
                            Text("Customers")
                          ],
                        )
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Services()));
                    },
                    child: Container(
                        height: MediaQuery.of(context).size.height*0.15,
                        margin: EdgeInsets.fromLTRB(10, 10, 5, 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: darkBrown,
                              child: Icon(Icons.spa),
                            ),
                            SizedBox(height: 10,),
                            Text("Services")
                          ],
                        )
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Categories()));
                    },
                    child: Container(
                        height: MediaQuery.of(context).size.height*0.15,
                        margin: EdgeInsets.fromLTRB(10, 10, 5, 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: darkBrown,
                              child: Icon(Icons.category),
                            ),
                            SizedBox(height: 10,),
                            Text("Categories")
                          ],
                        )
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Offers()));
                    },
                    child: Container(
                        height: MediaQuery.of(context).size.height*0.15,
                        margin: EdgeInsets.fromLTRB(10, 10, 5, 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: darkBrown,
                              child: Icon(Icons.local_offer),
                            ),
                            SizedBox(height: 10,),
                            Text("Offers")
                          ],
                        )
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => PromoCodes()));
                    },
                    child: Container(
                        height: MediaQuery.of(context).size.height*0.15,
                        margin: EdgeInsets.fromLTRB(10, 10, 5, 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: darkBrown,
                              child: Icon(Icons.add_shopping_cart),
                            ),
                            SizedBox(height: 10,),
                            Text("Promo Codes")
                          ],
                        )
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
