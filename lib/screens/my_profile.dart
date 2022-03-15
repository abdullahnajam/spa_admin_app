import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spa_admin_app/models/admin_model.dart';
import 'package:spa_admin_app/models/branch_model.dart';
import 'package:spa_admin_app/models/gender_model.dart';
import 'package:spa_admin_app/utils/constants.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
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
            AdminModel adminModel=AdminModel.fromMap(data, FirebaseAuth.instance.currentUser!.uid);
            return Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height*0.45,
                  child: Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height*0.25,
                        decoration: BoxDecoration(
                          color: lightBrown,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0,30,10,0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.notifications,color: Colors.white,),
                              SizedBox(width: 5,),
                              Icon(Icons.settings,color: Colors.white,),

                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, MediaQuery.of(context).size.height*0.1, 10, 10),
                        child: Stack(
                          children: [
                            Container(
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              height: MediaQuery.of(context).size.height*0.4,
                              margin: EdgeInsets.only(top: 40),
                              child: Column(
                                children: [
                                  SizedBox(height: 50,),
                                  Text(adminModel.username,style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16),),
                                  SizedBox(height: 5,),
                                  Text(adminModel.email,style: TextStyle(color:Colors.grey,fontWeight: FontWeight.w300,fontSize: 13),),
                                  SizedBox(height: 5,),
                                  Text(adminModel.phone,style: TextStyle(color:Colors.grey,fontWeight: FontWeight.w300,fontSize: 13),),
                                  SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 130,
                                        margin: EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            color: darkBrown
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(adminModel.branchName,style: TextStyle(color: Colors.white),),
                                      ),
                                      Container(
                                        height: 40,
                                        width: 130,
                                        margin: EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            color: darkBrown
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(adminModel.gender,style: TextStyle(color: Colors.white),),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white,style: BorderStyle.solid,width: 2),
                                    image: DecorationImage(
                                        image: NetworkImage(adminModel.profilePicture),
                                        fit: BoxFit.cover
                                    ),
                                    shape: BoxShape.circle
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
                Expanded(
                  child: DefaultTabController(
                      length: 2,
                      child:Column(
                        children: [
                          TabBar(
                            labelColor:lightBrown,
                            unselectedLabelColor: Colors.grey,
                            indicatorWeight: 0.5,



                            tabs: [
                              Tab(text: 'BRANCHES'),
                              Tab(text: 'GENDERS'),
                            ],
                          ),

                          Container(
                            height: MediaQuery.of(context).size.height*0.45,

                            child: TabBarView(children: <Widget>[
                              Container(
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance.collection('branches').snapshots(),
                                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasError) {
                                      return Center(
                                        child: Column(
                                          children: [
                                            Image.asset("assets/images/wrong.png",width: 150,height: 150,),
                                            Text("Something Went Wrong")

                                          ],
                                        ),
                                      );
                                    }

                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    if (snapshot.data!.size==0){
                                      return Container(
                                          alignment: Alignment.center,
                                          child:Text("No Branches")

                                      );

                                    }
                                    return new ListView(
                                      padding: EdgeInsets.zero,
                                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                                        BranchModel model= BranchModel.fromMap(data, document.reference.id);
                                        return Container(
                                          color: Colors.white,
                                          margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                          child: ListTile(
                                            title: Text("${model.name}"),
                                            subtitle: Text("${model.location} "),
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  },
                                ),
                              ),
                              Container(
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance.collection('genders').snapshots(),
                                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasError) {
                                      return Center(
                                        child: Column(
                                          children: [
                                            Image.asset("assets/images/wrong.png",width: 150,height: 150,),
                                            Text("Something Went Wrong")

                                          ],
                                        ),
                                      );
                                    }

                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    if (snapshot.data!.size==0){
                                      return Container(
                                          alignment: Alignment.center,
                                          child:Text("No Branches")

                                      );

                                    }
                                    return new ListView(
                                      padding: EdgeInsets.zero,
                                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                                        GenderModel model= GenderModel.fromMap(data, document.reference.id);
                                        return Container(
                                          color: Colors.white,
                                          margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                          child: ListTile(
                                            leading: Container(
                                              height: 80,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: NetworkImage(model.image)
                                                  )
                                              ),
                                            ),
                                            title: Text("${model.gender} - ${model.gender_ar}"),
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  },
                                ),
                              ),

                            ]),
                          )

                        ],

                      )
                  ),
                )
              ],
            );
          }

          return Text("-");
        },
      ),
    );
  }
}
