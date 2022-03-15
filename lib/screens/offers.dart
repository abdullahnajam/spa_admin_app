import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:spa_admin_app/models/appointment_model.dart';
import 'package:spa_admin_app/models/branch_model.dart';
import 'package:spa_admin_app/models/checklist_model.dart';
import 'package:spa_admin_app/models/offer_model.dart';
import 'package:spa_admin_app/models/review_model.dart';
import 'package:spa_admin_app/models/service_model.dart';
import 'package:spa_admin_app/models/user_model.dart';
import 'package:spa_admin_app/screens/add_offer.dart';
import 'package:spa_admin_app/utils/constants.dart';
import 'package:spa_admin_app/widgets/appbar_title.dart';
import 'package:spa_admin_app/widgets/booking_tile.dart';

class Offers extends StatefulWidget {
  const Offers({Key? key}) : super(key: key);

  @override
  _OffersState createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: ()async{
          final ProgressDialog pr = ProgressDialog(context: context);
          pr.show(max: 100, msg: "Please wait");
          List<CheckListModel> branches=[];
          await FirebaseFirestore.instance.collection('branches').get().then((QuerySnapshot querySnapshot) {
            querySnapshot.docs.forEach((doc) {
              Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
              setState(() {
                CheckListModel model=new CheckListModel(false,BranchModel.fromMap(data, doc.reference.id));
                branches.add(model);
              });
            });
          });
          pr.close();
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AddOffer(branches)));

        },
        backgroundColor: darkBrown,
      ),
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBarTitleOnly("Offers"),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('offers').snapshots(),
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
                        child:Text("No Offers")

                    );

                  }
                  return new ListView(
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      OfferModel model= OfferModel.fromMap(data, document.reference.id);
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
                          subtitle: Text("${model.startDate} - ${model.endDate}"),
                          trailing: Text("Discount : ${model.discount}"),
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
