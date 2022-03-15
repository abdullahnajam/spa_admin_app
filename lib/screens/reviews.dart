import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:spa_admin_app/models/appointment_model.dart';
import 'package:spa_admin_app/models/review_model.dart';
import 'package:spa_admin_app/utils/constants.dart';
import 'package:spa_admin_app/widgets/appbar_title.dart';
import 'package:spa_admin_app/widgets/booking_tile.dart';

class Reviews extends StatefulWidget {
  const Reviews({Key? key}) : super(key: key);

  @override
  _ReviewsState createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  String dropdownValue='All';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBarTitleOnly("Reviews"),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.only(left: 10,right: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: DropdownButton<String>(
                value: dropdownValue,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                //style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items: <String>['All', 'Approved', 'Hidden','Cancelled']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            if(dropdownValue=='All')
              Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('reviews').snapshots(),
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
                        child:Text("No Reviews")

                    );

                  }
                  return new ListView(
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      ReviewModel model= ReviewModel.fromMap(data, document.reference.id);
                      if(model.isHidden){
                        if(model.userId==FirebaseAuth.instance.currentUser!.uid)
                          return Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.all(10),

                                    decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10)
                                        )
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(model.username,style: TextStyle(fontWeight: FontWeight.w600),),
                                        RatingBar(
                                          initialRating: model.rating.toDouble(),
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          ratingWidget: RatingWidget(
                                            full: Icon(Icons.star,color: darkBrown),
                                            half: Icon(Icons.star_half,color: darkBrown),
                                            empty:Icon(Icons.star_border,color: darkBrown),
                                          ),
                                          ignoreGestures: true,
                                          itemSize: 14,
                                          itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                          onRatingUpdate: (rating) {
                                            print(rating);
                                          },
                                        )
                                      ],
                                    )
                                ),
                                Container(
                                  margin: EdgeInsets.all(10),
                                  child: Text(model.review),
                                )
                              ],
                            ),
                          );
                        else{
                          return Container();
                        }
                      }

                      else
                        return Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(10),

                                  decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10)
                                      )
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(model.username,style: TextStyle(fontWeight: FontWeight.w600),),
                                      RatingBar(
                                        initialRating: model.rating.toDouble(),
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        ratingWidget: RatingWidget(
                                          full: Icon(Icons.star,color: darkBrown),
                                          half: Icon(Icons.star_half,color: darkBrown),
                                          empty:Icon(Icons.star_border,color: darkBrown),
                                        ),
                                        ignoreGestures: true,
                                        itemSize: 14,
                                        itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                        onRatingUpdate: (rating) {
                                          print(rating);
                                        },
                                      )
                                    ],
                                  )
                              ),
                              Container(
                                margin: EdgeInsets.all(10),
                                child: Text(model.review),
                              )
                            ],
                          ),
                        );
                    }).toList(),
                  );
                },
              ),
            )
            else if(dropdownValue=='Hidden')
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('reviews')
                      .where("isHidden",isEqualTo: true).snapshots(),
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
                          child:Text("No Reviews")

                      );

                    }
                    return new ListView(
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        ReviewModel model= ReviewModel.fromMap(data, document.reference.id);
                        if(model.isHidden){
                          if(model.userId==FirebaseAuth.instance.currentUser!.uid)
                            return Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.all(10),

                                      decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10)
                                          )
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(model.username,style: TextStyle(fontWeight: FontWeight.w600),),
                                          RatingBar(
                                            initialRating: model.rating.toDouble(),
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            ratingWidget: RatingWidget(
                                              full: Icon(Icons.star,color: darkBrown),
                                              half: Icon(Icons.star_half,color: darkBrown),
                                              empty:Icon(Icons.star_border,color: darkBrown),
                                            ),
                                            ignoreGestures: true,
                                            itemSize: 14,
                                            itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                            onRatingUpdate: (rating) {
                                              print(rating);
                                            },
                                          )
                                        ],
                                      )
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    child: Text(model.review),
                                  )
                                ],
                              ),
                            );
                          else{
                            return Container();
                          }
                        }

                        else
                          return Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.all(10),

                                    decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10)
                                        )
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(model.username,style: TextStyle(fontWeight: FontWeight.w600),),
                                        RatingBar(
                                          initialRating: model.rating.toDouble(),
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          ratingWidget: RatingWidget(
                                            full: Icon(Icons.star,color: darkBrown),
                                            half: Icon(Icons.star_half,color: darkBrown),
                                            empty:Icon(Icons.star_border,color: darkBrown),
                                          ),
                                          ignoreGestures: true,
                                          itemSize: 14,
                                          itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                          onRatingUpdate: (rating) {
                                            print(rating);
                                          },
                                        )
                                      ],
                                    )
                                ),
                                Container(
                                  margin: EdgeInsets.all(10),
                                  child: Text(model.review),
                                )
                              ],
                            ),
                          );
                      }).toList(),
                    );
                  },
                ),
              )
            else
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('reviews')
                      .where("status",isEqualTo: dropdownValue).snapshots(),
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
                          child:Text("No Reviews")

                      );

                    }
                    return new ListView(
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        ReviewModel model= ReviewModel.fromMap(data, document.reference.id);
                        if(model.isHidden){
                          if(model.userId==FirebaseAuth.instance.currentUser!.uid)
                            return Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.all(10),

                                      decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10)
                                          )
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(model.username,style: TextStyle(fontWeight: FontWeight.w600),),
                                          RatingBar(
                                            initialRating: model.rating.toDouble(),
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            ratingWidget: RatingWidget(
                                              full: Icon(Icons.star,color: darkBrown),
                                              half: Icon(Icons.star_half,color: darkBrown),
                                              empty:Icon(Icons.star_border,color: darkBrown),
                                            ),
                                            ignoreGestures: true,
                                            itemSize: 14,
                                            itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                            onRatingUpdate: (rating) {
                                              print(rating);
                                            },
                                          )
                                        ],
                                      )
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    child: Text(model.review),
                                  )
                                ],
                              ),
                            );
                          else{
                            return Container();
                          }
                        }

                        else
                          return Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.all(10),

                                    decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10)
                                        )
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(model.username,style: TextStyle(fontWeight: FontWeight.w600),),
                                        RatingBar(
                                          initialRating: model.rating.toDouble(),
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          ratingWidget: RatingWidget(
                                            full: Icon(Icons.star,color: darkBrown),
                                            half: Icon(Icons.star_half,color: darkBrown),
                                            empty:Icon(Icons.star_border,color: darkBrown),
                                          ),
                                          ignoreGestures: true,
                                          itemSize: 14,
                                          itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                          onRatingUpdate: (rating) {
                                            print(rating);
                                          },
                                        )
                                      ],
                                    )
                                ),
                                Container(
                                  margin: EdgeInsets.all(10),
                                  child: Text(model.review),
                                )
                              ],
                            ),
                          );
                      }).toList(),
                    );
                  },
                ),
              )
          ],
        ),
      ),
    );
  }
}
