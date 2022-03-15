import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spa_admin_app/models/appointment_model.dart';
import 'package:spa_admin_app/models/user_model.dart';
import 'package:spa_admin_app/utils/constants.dart';
import 'package:spa_admin_app/widgets/appbar.dart';
import 'package:spa_admin_app/models/service_model.dart';
class BookingDetail extends StatefulWidget {
  AppointmentModel _appointmentModel;


  BookingDetail(this._appointmentModel);

  @override
  _BookingDetailState createState() => _BookingDetailState();
}

class _BookingDetailState extends State<BookingDetail> {
  Future<void> _showChangeStatusDialog(AppointmentModel model) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {

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
                padding: EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height*0.5,
                width: MediaQuery.of(context).size.width*0.5,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: ListView(
                  children: [
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: Text("Change Status"),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            child: IconButton(
                              icon: Icon(Icons.close,color: Colors.grey,),
                              onPressed: ()=>Navigator.pop(context),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    ListTile(
                      onTap: (){
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.QUESTION,
                          animType: AnimType.BOTTOMSLIDE,
                          dialogBackgroundColor: Colors.white,
                          title: 'Change Status',
                          desc: 'Are you sure you want to change status?',
                          btnCancelOnPress: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BookingDetail(widget._appointmentModel)));
                          },
                          btnOkOnPress: () {
                            FirebaseFirestore.instance.collection('appointments').doc(model.id).update({
                              'status':"Approved"
                            }).then((value) {

                              /*Navigator.pop(context);
                              showDialog<void>(
                                context: context,
                                barrierDismissible: false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Select Place',style: TextStyle(color: Colors.black),),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: const <Widget>[
                                          Text("Do you want to select place?",style: TextStyle(color: Colors.black),),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          _showSelectPlace(model, context).then((value) => Navigator.pop(context));

                                        },
                                      ),
                                      TextButton(
                                        child: const Text('Later'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );*/
                            }).onError((error, stackTrace) {

                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.ERROR,
                                animType: AnimType.BOTTOMSLIDE,
                                dialogBackgroundColor: Colors.white,
                                title: 'Error : Unable to change status',
                                desc: '${error.toString()}',

                                btnOkOnPress: () {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BookingDetail(widget._appointmentModel)));

                                },
                              )..show();
                            });
                          },
                        )..show();


                      },
                      title: Text("Approved",style: TextStyle(color: Colors.black),),
                    ),
                    Divider(color: Colors.grey,),
                    ListTile(
                      onTap: (){

                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.QUESTION,
                          animType: AnimType.BOTTOMSLIDE,
                          dialogBackgroundColor: Colors.white,
                          title: 'Change Status',
                          desc: 'Are you sure you want to change status?',
                          btnCancelOnPress: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BookingDetail(widget._appointmentModel)));
                          },
                          btnOkOnPress: () {
                            FirebaseFirestore.instance.collection('appointments').doc(model.id).update({
                              'status':"Completed"
                            }).then((value) {
                              FirebaseFirestore.instance.collection('customer').doc(model.userId).get().then((DocumentSnapshot documentSnapshot) {
                                if (documentSnapshot.exists) {
                                  Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
                                  UserModel userModel=UserModel.fromMap(data,documentSnapshot.reference.id);
                                  int points=userModel.points;
                                  points=points+model.points;
                                  print("points $points");
                                  FirebaseFirestore.instance.collection('customer').doc(model.userId).update({
                                    'points':points,
                                  });

                                }
                              });

                              Navigator.pop(context);
                            }).onError((error, stackTrace) {

                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.ERROR,
                                animType: AnimType.BOTTOMSLIDE,
                                dialogBackgroundColor: Colors.white,
                                title: 'Error : Unable to change status',
                                desc: '${error.toString()}',

                                btnOkOnPress: () {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BookingDetail(widget._appointmentModel)));

                                },
                              )..show();
                            });
                          },
                        )..show();

                      },
                      title: Text("Completed",style: TextStyle(color: Colors.black),),
                    ),
                    Divider(color: Colors.grey,),
                    ListTile(
                      onTap: (){

                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.QUESTION,
                          animType: AnimType.BOTTOMSLIDE,
                          dialogBackgroundColor: Colors.white,
                          title: 'Change Status',
                          desc: 'Are you sure you want to change status?',
                          btnCancelOnPress: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BookingDetail(widget._appointmentModel)));
                          },
                          btnOkOnPress: () {
                            FirebaseFirestore.instance.collection('appointments').doc(model.id).update({
                              'status':"Cancelled"
                            }).then((value) {
                              FirebaseFirestore.instance
                                  .collection('customer')
                                  .doc(model.userId)
                                  .get()
                                  .then((DocumentSnapshot documentSnapshot) {
                                if (documentSnapshot.exists) {
                                  Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
                                  UserModel userModel=UserModel.fromMap(data,documentSnapshot.reference.id);
                                  if(model.paymentMethod=="Points Redemption"){
                                    FirebaseFirestore.instance
                                        .collection('services')
                                        .doc(model.serviceId)
                                        .get()
                                        .then((DocumentSnapshot serviceSnap) {
                                      if (serviceSnap.exists) {
                                        Map<String, dynamic> serviceData = serviceSnap.data() as Map<String, dynamic>;
                                        ServiceModel serviceModel=ServiceModel.fromMap(serviceData,documentSnapshot.reference.id);
                                        int points=userModel.points;
                                        points+=serviceModel.redeemPoints;
                                        print("points $points");
                                        FirebaseFirestore.instance.collection('customer').doc(model.userId).update({
                                          'points':points,
                                        });
                                      }
                                    });

                                  }
                                  else{
                                    int points=userModel.points;
                                    points+=model.points;
                                    print("points $points");
                                    FirebaseFirestore.instance.collection('customer').doc(model.userId).update({
                                      'points':points,
                                    });
                                  }


                                }
                              });
                              Navigator.pop(context);
                            }).onError((error, stackTrace) {

                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.ERROR,
                                animType: AnimType.BOTTOMSLIDE,
                                dialogBackgroundColor: Colors.white,
                                title: 'Error : Unable to change status',
                                desc: '${error.toString()}',

                                btnOkOnPress: () {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BookingDetail(widget._appointmentModel)));

                                },
                              )..show();
                            });
                          },
                        )..show();

                      },
                      title: Text("Cancelled",style: TextStyle(color: Colors.black),),
                    ),
                    Divider(color: Colors.grey,),
                    ListTile(
                      onTap: (){
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.QUESTION,
                          animType: AnimType.BOTTOMSLIDE,
                          dialogBackgroundColor: Colors.white,
                          title: 'Change Status',
                          desc: 'Are you sure you want to change status?',
                          btnCancelOnPress: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BookingDetail(widget._appointmentModel)));
                          },
                          btnOkOnPress: () {
                            FirebaseFirestore.instance.collection('appointments').doc(model.id).update({
                              'status':"Pending"
                            }).then((value) {
                              Navigator.pop(context);
                            }).onError((error, stackTrace) {

                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.ERROR,
                                animType: AnimType.BOTTOMSLIDE,
                                dialogBackgroundColor: Colors.white,
                                title: 'Error : Unable to change status',
                                desc: '${error.toString()}',

                                btnOkOnPress: () {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BookingDetail(widget._appointmentModel)));

                                },
                              )..show();
                            });
                          },
                        )..show();

                      },
                      title: Text("Pending",style: TextStyle(color: Colors.black),),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            CustomAppBar("Booking Detail"),
            SizedBox(height: 20,),
            FutureBuilder<DocumentSnapshot>(
              future:  FirebaseFirestore.instance.collection('customer').doc(widget._appointmentModel.userId).get(),
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
                  UserModel userModel=UserModel.fromMap(data, FirebaseAuth.instance.currentUser!.uid);
                  return Column(
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
                            "${data['firstName']} ${data['lastName']}",
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
                  );
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20,),
                  Text("Date & Time",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Date",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),),
                      Text("${widget._appointmentModel.date}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),),

                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Time",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),),
                      Text("${widget._appointmentModel.time}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),),

                    ],
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20,),
                  Text("Amount",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${widget._appointmentModel.serviceName}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),),
                      Text("${widget._appointmentModel.amount}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),),

                    ],
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20,),
                  Text("Details",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Payment Method",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),),
                      Text("${widget._appointmentModel.paymentMethod}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),),

                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Branch",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),),
                      Text("${widget._appointmentModel.branchName}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),),

                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Package",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),),
                      Text("${widget._appointmentModel.packageName}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),),

                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Status",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),),
                      Text(widget._appointmentModel.status,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),),

                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Room",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),),
                      Text("${widget._appointmentModel.place}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),),

                    ],
                  ),
                  SizedBox(height: 20,),
                  Text("Rating",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Rated",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),),
                      Text(widget._appointmentModel.isRated?"Yes":"No",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),),

                    ],
                  ),
                  SizedBox(height: 5,),
                  if(widget._appointmentModel.isRated)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Rating",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),),
                      Text("${widget._appointmentModel.rating}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),),

                    ],
                  ),

                  SizedBox(height: 20,),
                  InkWell(
                    onTap: (){
                      _showChangeStatusDialog(widget._appointmentModel);
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: darkBrown,
                      ),
                      alignment: Alignment.center,
                      child: Text("Change Status",style: TextStyle(color:Colors.white,fontSize: 15,fontWeight: FontWeight.w300),),
                    ),
                  ),
                  SizedBox(height: 20,),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}
