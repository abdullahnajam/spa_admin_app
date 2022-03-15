import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:spa_admin_app/models/admin_model.dart';
import 'package:spa_admin_app/models/offer_model.dart';
import 'package:spa_admin_app/utils/constants.dart';
import 'package:spa_admin_app/widgets/appbar.dart';

class AddBookingOffer extends StatefulWidget {
  AdminModel admin;

  AddBookingOffer(this.admin);

  @override
  _AddBookingOfferState createState() => _AddBookingOfferState();
}

class _AddBookingOfferState extends State<AddBookingOffer> {
  String? serviceId, specialistId = "none", userId;
  String payment = 'Card Payment';
  int points = 0;
  var offerController = TextEditingController();
  var dateController = TextEditingController();
  var userController = TextEditingController();
  var timeController = TextEditingController();
  var amountController = TextEditingController();
  var specialistController = TextEditingController();
  DateTime? start;
  final _formKey = GlobalKey<FormState>();
  _selectDate(BuildContext context) async {
    start = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Refer step 1
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (start != null && start != DateTime.now())
      setState(() {
        final f = new DateFormat('dd-MM-yyyy');
        dateController.text = f.format(start!).toString();
      });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar("Book Offer"),
            Expanded(
              child:Padding(
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "User",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .apply(color: secondaryColor),
                          ),
                          TextFormField(
                            readOnly: true,
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(
                                      builder: (context, setState) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            const BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                          ),
                                          insetAnimationDuration:
                                          const Duration(seconds: 1),
                                          insetAnimationCurve:
                                          Curves.fastOutSlowIn,
                                          elevation: 2,
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.3,
                                            child: StreamBuilder<
                                                QuerySnapshot>(
                                              stream: FirebaseFirestore
                                                  .instance
                                                  .collection('customer')
                                                  .snapshots(),
                                              builder: (BuildContext
                                              context,
                                                  AsyncSnapshot<
                                                      QuerySnapshot>
                                                  snapshot) {
                                                if (snapshot.hasError) {
                                                  return Center(
                                                    child: Column(
                                                      children: [
                                                        Image.asset(
                                                          "assets/images/wrong.png",
                                                          width: 150,
                                                          height: 150,
                                                        ),
                                                        Text(
                                                            "Something Went Wrong",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black))
                                                      ],
                                                    ),
                                                  );
                                                }

                                                if (snapshot
                                                    .connectionState ==
                                                    ConnectionState
                                                        .waiting) {
                                                  return Center(
                                                    child:
                                                    CircularProgressIndicator(),
                                                  );
                                                }
                                                if (snapshot.data!.size ==
                                                    0) {
                                                  return Center(
                                                    child: Column(
                                                      children: [
                                                        Image.asset(
                                                          "assets/images/empty.png",
                                                          width: 150,
                                                          height: 150,
                                                        ),
                                                        Text(
                                                            "No Customers Added",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black))
                                                      ],
                                                    ),
                                                  );
                                                }

                                                return new ListView(
                                                  shrinkWrap: true,
                                                  children: snapshot
                                                      .data!.docs
                                                      .map(
                                                          (DocumentSnapshot
                                                      document) {
                                                        Map<String, dynamic>
                                                        data =
                                                        document.data()
                                                        as Map<String,
                                                            dynamic>;

                                                        return new Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .only(
                                                              top: 15.0),
                                                          child: ListTile(
                                                            onTap: () {
                                                              setState(() {
                                                                userController
                                                                    .text =
                                                                "${data['firstName']} ${data['lastName']}";
                                                                userId = document
                                                                    .reference
                                                                    .id;
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            leading:
                                                            CircleAvatar(
                                                              radius: 25,
                                                              backgroundImage:
                                                              NetworkImage(
                                                                  data[
                                                                  'profilePicture']),
                                                              backgroundColor:
                                                              Colors
                                                                  .indigoAccent,
                                                              foregroundColor:
                                                              Colors
                                                                  .white,
                                                            ),
                                                            title: Text(
                                                              "${data['firstName']} ${data['lastName']}",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  });
                            },
                            controller: userController,
                            style: TextStyle(color: Colors.black),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(15),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: primaryColor,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                    color: primaryColor, width: 0.5),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: primaryColor,
                                  width: 0.5,
                                ),
                              ),
                              hintText: "",
                              floatingLabelBehavior:
                              FloatingLabelBehavior.always,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Offer",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .apply(color: secondaryColor),
                          ),
                          TextFormField(
                            readOnly: true,
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(
                                      builder: (context, setState) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            const BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                          ),
                                          insetAnimationDuration:
                                          const Duration(seconds: 1),
                                          insetAnimationCurve:
                                          Curves.fastOutSlowIn,
                                          elevation: 2,
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.3,
                                            child: StreamBuilder<
                                                QuerySnapshot>(
                                              stream: FirebaseFirestore
                                                  .instance
                                                  .collection('offers')
                                                  .snapshots(),
                                              builder: (BuildContext
                                              context,
                                                  AsyncSnapshot<
                                                      QuerySnapshot>
                                                  snapshot) {
                                                if (snapshot.hasError) {
                                                  return Center(
                                                    child: Column(
                                                      children: [
                                                        Image.asset(
                                                          "assets/images/wrong.png",
                                                          width: 150,
                                                          height: 150,
                                                        ),
                                                        Text(
                                                            "Something Went Wrong",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black))
                                                      ],
                                                    ),
                                                  );
                                                }

                                                if (snapshot
                                                    .connectionState ==
                                                    ConnectionState
                                                        .waiting) {
                                                  return Center(
                                                    child:
                                                    CircularProgressIndicator(),
                                                  );
                                                }
                                                if (snapshot.data!.size ==
                                                    0) {
                                                  return Center(
                                                    child: Column(
                                                      children: [
                                                        Image.asset(
                                                          "assets/images/empty.png",
                                                          width: 150,
                                                          height: 150,
                                                        ),
                                                        Text(
                                                            "No Offers Added",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black))
                                                      ],
                                                    ),
                                                  );
                                                }

                                                return new ListView(
                                                  shrinkWrap: true,
                                                  children: snapshot
                                                      .data!.docs
                                                      .map(
                                                          (DocumentSnapshot
                                                      document) {
                                                        //Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                                                        Map<String, dynamic>
                                                        data =
                                                        document.data()
                                                        as Map<String,
                                                            dynamic>;
                                                        OfferModel model =
                                                        OfferModel.fromMap(
                                                            data,
                                                            document
                                                                .reference
                                                                .id);
                                                        int year = int.parse(
                                                            "${model.endDate[6]}${model.endDate[7]}${model.endDate[8]}${model.endDate[9]}");
                                                        int day = int.parse(
                                                            "${model.endDate[0]}${model.endDate[1]}");
                                                        int month = int.parse(
                                                            "${model.endDate[3]}${model.endDate[4]}");
                                                        final date = DateTime(
                                                            year, month, day);
                                                        final difference = date
                                                            .difference(
                                                            DateTime
                                                                .now())
                                                            .inDays;
                                                        return difference > 0
                                                            ? Padding(
                                                          padding: const EdgeInsets
                                                              .only(
                                                              top:
                                                              15.0),
                                                          child:
                                                          ListTile(
                                                            onTap: () {
                                                              setState(
                                                                      () {
                                                                    offerController.text =
                                                                    "${data['name']}";
                                                                    serviceId = document
                                                                        .reference
                                                                        .id;
                                                                    amountController.text =
                                                                    "${data['discount']}";
                                                                    //points=data['points'];
                                                                  });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            leading:
                                                            CircleAvatar(
                                                              radius:
                                                              25,
                                                              backgroundImage:
                                                              NetworkImage(
                                                                  data['image']),
                                                              backgroundColor:
                                                              Colors
                                                                  .indigoAccent,
                                                              foregroundColor:
                                                              Colors
                                                                  .white,
                                                            ),
                                                            subtitle:
                                                            Text(
                                                              "${data['discount']}",
                                                              style: TextStyle(
                                                                  color:
                                                                  Colors.black),
                                                            ),
                                                            title: Text(
                                                              "${data['name']}",
                                                              style: TextStyle(
                                                                  color:
                                                                  Colors.black),
                                                            ),
                                                          ),
                                                        )
                                                            : Container();
                                                      }).toList(),
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  });
                            },
                            controller: offerController,
                            style: TextStyle(color: Colors.black),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(15),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: primaryColor,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                    color: primaryColor, width: 0.5),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: primaryColor,
                                  width: 0.5,
                                ),
                              ),
                              hintText: "",
                              floatingLabelBehavior:
                              FloatingLabelBehavior.always,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Date",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .apply(color: secondaryColor),
                          ),
                          TextFormField(
                            readOnly: true,
                            onTap: () {
                              _selectDate(context);
                            },
                            controller: dateController,
                            style: TextStyle(color: Colors.black),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(15),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: primaryColor,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                    color: primaryColor, width: 0.5),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: primaryColor,
                                  width: 0.5,
                                ),
                              ),
                              hintText: "",
                              floatingLabelBehavior:
                              FloatingLabelBehavior.always,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Time",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .apply(color: secondaryColor),
                          ),
                          TextFormField(
                            readOnly: true,
                            onTap: () {
                              if (offerController.text != "") {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          return Dialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              const BorderRadius.all(
                                                Radius.circular(10.0),
                                              ),
                                            ),
                                            insetAnimationDuration:
                                            const Duration(
                                                seconds: 1),
                                            insetAnimationCurve:
                                            Curves.fastOutSlowIn,
                                            elevation: 2,
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              width:
                                              MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  0.3,
                                              child: StreamBuilder<
                                                  QuerySnapshot>(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection(
                                                    'timeslots')
                                                    .snapshots(),
                                                builder: (BuildContext
                                                context,
                                                    AsyncSnapshot<
                                                        QuerySnapshot>
                                                    snapshot) {
                                                  if (snapshot.hasError) {
                                                    return Center(
                                                      child: Column(
                                                        children: [
                                                          Image.asset(
                                                            "assets/images/wrong.png",
                                                            width: 150,
                                                            height: 150,
                                                          ),
                                                          Text(
                                                              "Something Went Wrong",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black))
                                                        ],
                                                      ),
                                                    );
                                                  }

                                                  if (snapshot
                                                      .connectionState ==
                                                      ConnectionState
                                                          .waiting) {
                                                    return Center(
                                                      child:
                                                      CircularProgressIndicator(),
                                                    );
                                                  }
                                                  if (snapshot
                                                      .data!.size ==
                                                      0) {
                                                    return Center(
                                                      child: Column(
                                                        children: [
                                                          Image.asset(
                                                            "assets/images/empty.png",
                                                            width: 150,
                                                            height: 150,
                                                          ),
                                                          Text(
                                                              "No Timeslots",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black))
                                                        ],
                                                      ),
                                                    );
                                                  }

                                                  return new ListView(
                                                    shrinkWrap: true,
                                                    children: snapshot
                                                        .data!.docs
                                                        .map((DocumentSnapshot
                                                    document) {
                                                      Map<String, dynamic>
                                                      data =
                                                      document.data()
                                                      as Map<
                                                          String,
                                                          dynamic>;

                                                      return new Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(
                                                            top:
                                                            15.0),
                                                        child: ListTile(
                                                          onTap: () {
                                                            setState(() {
                                                              timeController
                                                                  .text =
                                                              "${data['time']}";
                                                            });
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          leading:
                                                          CircleAvatar(
                                                            radius: 25,
                                                            child: Icon(
                                                              Icons.timer,
                                                              color: Colors
                                                                  .white,
                                                            ),
                                                            backgroundColor:
                                                            Colors
                                                                .indigoAccent,
                                                          ),
                                                          title: Text(
                                                            "${data['time']}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  );
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    });
                              } else {
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible: false,
                                  // user must tap button!
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title:
                                      const Text('No Offer Selected'),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: const <Widget>[
                                            Text(
                                                "Please select a offer before reserving a time slot"),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            controller: timeController,
                            style: TextStyle(color: Colors.black),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(15),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: primaryColor,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                    color: primaryColor, width: 0.5),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: primaryColor,
                                  width: 0.5,
                                ),
                              ),
                              hintText: "",
                              floatingLabelBehavior:
                              FloatingLabelBehavior.always,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Amount",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .apply(color: secondaryColor),
                          ),
                          TextFormField(
                            readOnly: true,
                            controller: amountController,
                            style: TextStyle(color: Colors.black),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(15),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: primaryColor,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                    color: primaryColor, width: 0.5),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: primaryColor,
                                  width: 0.5,
                                ),
                              ),
                              hintText: "",
                              floatingLabelBehavior:
                              FloatingLabelBehavior.always,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Payment",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .apply(color: secondaryColor),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.0),
                              border: Border.all(
                                color: primaryColor,
                              ),
                            ),
                            child: DropdownButton<String>(
                              value: payment,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              isExpanded: true,
                              elevation: 16,
                              style: const TextStyle(color: Colors.black),
                              underline: Container(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  payment = newValue!;
                                });
                              },
                              items: <String>[
                                'Card Payment',
                                'Cash Payment'
                              ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            final f = new DateFormat('dd-MM-yyyy');
                            if (payment == 'Cash Payment') {
                              final ProgressDialog pr =
                              ProgressDialog(context: context);
                              pr.show(max: 100, msg: "Adding");
                              FirebaseFirestore.instance
                                  .collection('appointments')
                                  .add({
                                'name': userController.text,
                                'amount': amountController.text,
                                'userId': userId,
                                'date': dateController.text,
                                'time': timeController.text,
                                'specialistId': specialistId,
                                'specialistName':
                                specialistController.text == ""
                                    ? "none"
                                    : specialistController.text,
                                'serviceId': serviceId,
                                'serviceName': offerController.text,
                                'status': "Approved",
                                'isRated': false,
                                'rating': 0,
                                'paid': false,
                                'gender':"offer",
                                'points': points,
                                'paymentMethod': payment,
                                'datePosted':
                                DateTime.now().millisecondsSinceEpoch,
                                'dateBooked':
                                start!.millisecondsSinceEpoch,
                                'formattedDate':
                                f.format(DateTime.now()).toString(),
                                'day': DateTime.now().day,
                                'month': DateTime.now().month,
                                'year': DateTime.now().year,
                                'adminBooking':true,
                                'adminId':FirebaseAuth.instance.currentUser!.uid,
                                'adminName':widget.admin.username,
                              }).then((value) {
                                FirebaseFirestore.instance
                                    .collection('redeemedOffers')
                                    .doc(FirebaseAuth
                                    .instance.currentUser!.uid)
                                    .get()
                                    .then((DocumentSnapshot
                                documentSnapshot) {
                                  if (documentSnapshot.exists) {
                                    Map<String, dynamic> data =
                                    documentSnapshot.data()
                                    as Map<String, dynamic>;
                                    List offers = data['offers'];
                                    offers.add(serviceId);
                                    FirebaseFirestore.instance
                                        .collection('redeemedOffers')
                                        .doc(userId)
                                        .set({'offers': offers});
                                  } else {
                                    List offers = [];
                                    offers.add(serviceId);
                                    FirebaseFirestore.instance
                                        .collection('redeemedOffers')
                                        .doc(userId)
                                        .set({'offers': offers});
                                  }
                                });
                                pr.close();
                                Navigator.pop(context);
                              });
                            } else if (payment == 'Card Payment') {
                              final ProgressDialog pr = ProgressDialog(context: context);
                              pr.show(max: 100, msg: "Adding");
                              FirebaseFirestore.instance
                                  .collection('appointments')
                                  .add({
                                'name': userController.text,
                                'amount': amountController.text,
                                'userId': userId,
                                'date': dateController.text,
                                'time': timeController.text,
                                'specialistId': specialistId,
                                'specialistName':
                                specialistController.text == ""
                                    ? "none"
                                    : specialistController.text,
                                'serviceId': serviceId,
                                'serviceName': offerController.text,
                                'status': "Approved",
                                'isRated': false,
                                'rating': 0,
                                'paid': false,
                                'points': points,
                                'paymentMethod': payment,
                                'datePosted': DateTime.now().millisecondsSinceEpoch,
                                'gender':"offer",
                                'dateBooked': start!.millisecondsSinceEpoch,
                                'formattedDate': f.format(DateTime.now()).toString(),
                                'day': DateTime.now().day,
                                'month': DateTime.now().month,
                                'year': DateTime.now().year,
                                'adminBooking':true,
                                'adminId':FirebaseAuth.instance.currentUser!.uid,
                                'adminName':widget.admin.username,
                              }).then((value) {
                                FirebaseFirestore.instance
                                    .collection('redeemedOffers')
                                    .doc(FirebaseAuth
                                    .instance.currentUser!.uid)
                                    .get()
                                    .then((DocumentSnapshot
                                documentSnapshot) {
                                  if (documentSnapshot.exists) {
                                    Map<String, dynamic> data =
                                    documentSnapshot.data()
                                    as Map<String, dynamic>;
                                    List offers = data['offers'];
                                    offers.add(serviceId);
                                    FirebaseFirestore.instance
                                        .collection('redeemedOffers')
                                        .doc(userId)
                                        .set({'offers': offers});
                                  } else {
                                    List offers = [];
                                    offers.add(serviceId);
                                    FirebaseFirestore.instance
                                        .collection('redeemedOffers')
                                        .doc(userId)
                                        .set({'offers': offers});
                                  }
                                });
                                pr.close();
                                Navigator.pop(context);
                              });
                            }
                          }
                        },
                        child: Container(
                          height: 50,
                          color: secondaryColor,
                          alignment: Alignment.center,
                          child: Text(
                            "Book",
                            style: Theme.of(context)
                                .textTheme
                                .button!
                                .apply(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
