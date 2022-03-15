import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:spa_admin_app/models/appointment_model.dart';
import 'package:spa_admin_app/models/review_model.dart';
import 'package:spa_admin_app/models/service_model.dart';
import 'package:spa_admin_app/models/user_model.dart';
import 'package:spa_admin_app/screens/add_service.dart';
import 'package:spa_admin_app/utils/constants.dart';
import 'package:spa_admin_app/widgets/appbar_title.dart';
import 'package:spa_admin_app/widgets/booking_tile.dart';

class Services extends StatefulWidget {
  const Services({Key? key}) : super(key: key);

  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){

          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AddService()));

        },
        backgroundColor: darkBrown,
      ),
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBarTitleOnly("Services"),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('services').snapshots(),
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
                        child:Text("No Services")

                    );

                  }
                  return new ListView(
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      ServiceModel model= ServiceModel.fromMap(data, document.reference.id);
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
                          title: Text("${model.name}"),
                          subtitle: Text(model.categoryName),
                          trailing: Text("Price : ${model.price}"),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
