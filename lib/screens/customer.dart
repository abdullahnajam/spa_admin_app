import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:spa_admin_app/models/appointment_model.dart';
import 'package:spa_admin_app/models/review_model.dart';
import 'package:spa_admin_app/models/user_model.dart';
import 'package:spa_admin_app/search/search_customer.dart';
import 'package:spa_admin_app/utils/constants.dart';
import 'package:spa_admin_app/widgets/appbar_title.dart';
import 'package:spa_admin_app/widgets/booking_tile.dart';
import 'package:easy_localization/easy_localization.dart';
class Customers extends StatefulWidget {
  const Customers({Key? key}) : super(key: key);

  @override
  _CustomersState createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBarTitleOnly("Customers"),
            Padding(
              padding: EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: ()async{
                        List<UserModel> services=[];
                        FirebaseFirestore.instance.collection('customer').get().then((QuerySnapshot querySnapshot) {
                          querySnapshot.docs.forEach((doc) {
                            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                            UserModel model=UserModel.fromMap(data, doc.reference.id);
                            setState(() {
                              services.add(model);
                            });
                          });
                          print("size1 ${services.length}");
                        }).then((value){
                          showSearch<String>(
                            context: context,
                            delegate: CustomerSearch(services),
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

                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('customer').snapshots(),
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
                        child:Text("No Customers")

                    );

                  }
                  return new ListView(
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      UserModel model= UserModel.fromMap(data, document.reference.id);
                      return Container(
                        margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        color: Colors.white,
                        child: ListTile(
                          leading: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(model.profilePicture)
                              )
                            ),
                          ),
                          title: Text("${model.firstName} ${model.lastName}"),
                          subtitle: Text(model.phone),
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
