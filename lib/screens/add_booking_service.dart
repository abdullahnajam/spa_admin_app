import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:spa_admin_app/models/admin_model.dart';
import 'package:spa_admin_app/models/service_model.dart';
import 'package:spa_admin_app/utils/constants.dart';
import 'package:spa_admin_app/widgets/appbar.dart';

class AddBookingService extends StatefulWidget {
  String date,time;
  AdminModel admin;

  AddBookingService(this.date, this.time,this.admin);

  @override
  _AddBookingServiceState createState() => _AddBookingServiceState();
}

class _AddBookingServiceState extends State<AddBookingService> {

  String? branchId = "", placeId = "", _packageId = "none", catId = "", serviceId="", specialistId = "none", userId;
  String payment = 'Card Payment';
  int points = 0;
  var branchController = TextEditingController();
  var _packageController = TextEditingController();
  var _packageArController = TextEditingController();
  var serviceController = TextEditingController();
  var dateController = TextEditingController();
  var userController = TextEditingController();
  var timeController = TextEditingController();
  var amountController = TextEditingController();
  var specialistController = TextEditingController();
  var categoryController = TextEditingController();
  var couponController = TextEditingController();
  var genderController = TextEditingController();
  var placeController = TextEditingController();
  DateTime? start=DateTime.now();
  String couponId = "";
  bool hasPackage=false;
  List ids = [];
  final _formKey = GlobalKey<FormState>();
  _selectDate(BuildContext context) async {
    start = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Refer step 1
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (start != null)
      setState(() {
        final f = new DateFormat('dd-MM-yyyy');
        dateController.text = f.format(start!).toString();
      });
  }

  @override
  void initState() {
    super.initState();
    if(widget.date!="")
      dateController.text=widget.date;
    if(widget.time!="")
      timeController.text=widget.time;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar("Book Service"),
            Expanded(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
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
                                .apply(color: darkBrown),
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
                                  color: red,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                    color: red, width: 0.5),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: red,
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
                            "Branch",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .apply(color: darkBrown),
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
                                                  .collection('branches')
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
                                                            "No Branches Added",
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
                                                                branchController
                                                                    .text =
                                                                "${data['name']}";
                                                                branchId =
                                                                    document
                                                                        .reference
                                                                        .id;
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            subtitle: Text(
                                                              "${data['location']}",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            title: Text(
                                                              "${data['name']}",
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
                            controller: branchController,
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
                                  color: red,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                    color: red, width: 0.5),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: red,
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
                            "Gender",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .apply(color: darkBrown),
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
                                                  .collection('genders')
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
                                                      child: Text(
                                                          "No Genders Added",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black)));
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
                                                                genderController
                                                                    .text =
                                                                "${data['gender']}";
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
                                                                  'image']),
                                                              backgroundColor:
                                                              Colors
                                                                  .indigoAccent,
                                                              foregroundColor:
                                                              Colors
                                                                  .white,
                                                            ),
                                                            title: Text(
                                                              "${data['gender']}",
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
                            controller: genderController,
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
                                  color: red,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                    color: red, width: 0.5),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: red,
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
                            "Category",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .apply(color: darkBrown),
                          ),
                          TextFormField(
                            readOnly: true,
                            onTap: () {
                              if(genderController.text==""){
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible: false, // user must tap button!
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('No Gender Selected',style: TextStyle(color: Colors.black),),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: const <Widget>[
                                            Text("Please select a gender before adding a category",style: TextStyle(color: Colors.black)),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('OK',style: TextStyle(color: Colors.black)),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                              else{
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
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  0.3,
                                              child: StreamBuilder<
                                                  QuerySnapshot>(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection(
                                                    'categories')
                                                    .where("gender",
                                                    isEqualTo:
                                                    genderController
                                                        .text)
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
                                                              "No Categories Added",
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
                                                                  categoryController
                                                                      .text =
                                                                  "${data['name']}";
                                                                  catId = document
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
                                                                    'image']),
                                                                backgroundColor:
                                                                Colors
                                                                    .indigoAccent,
                                                                foregroundColor:
                                                                Colors
                                                                    .white,
                                                              ),
                                                              title: Text(
                                                                "${data['name']}",
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
                              }
                            },
                            controller: categoryController,
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
                                  color: red,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                    color: red, width: 0.5),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: red,
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
                            "Service",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .apply(color: darkBrown),
                          ),
                          TextFormField(
                            readOnly: true,
                            onTap: () {
                              if (catId != "") {
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
                                                    'services')
                                                    .where("categoryId",
                                                    isEqualTo: catId)
                                                    .where("gender",
                                                    isEqualTo:
                                                    genderController
                                                        .text)
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
                                                              "No Services Added",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black))
                                                        ],
                                                      ),
                                                    );
                                                  }

                                                  return new ListView(
                                                    shrinkWrap: true,
                                                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                                                      ServiceModel _serviceModel=ServiceModel.fromMap(data, document.reference.id);
                                                      return new Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(
                                                            top:
                                                            15.0),
                                                        child: ListTile(
                                                          onTap: () {
                                                            setState(() {
                                                              serviceController.text = "${data['name']}";
                                                              serviceId = document.reference.id;
                                                              amountController.text = "${data['price']}";
                                                              points = data['points'];
                                                            });
                                                            hasPackage=_serviceModel.hasPackages;
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          leading:
                                                          CircleAvatar(
                                                            radius: 25,
                                                            backgroundImage:
                                                            NetworkImage(data['image']),
                                                            backgroundColor:
                                                            Colors
                                                                .indigoAccent,
                                                            foregroundColor:
                                                            Colors
                                                                .white,
                                                          ),
                                                          subtitle: Text(
                                                            "${data['categoryName']}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          title: Text(
                                                            "${data['name']}",
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
                                      title: const Text(
                                        'No Category Selected',
                                        style: TextStyle(
                                            color: Colors.black),
                                      ),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: const <Widget>[
                                            Text(
                                              "Please select a category before selecting a service",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
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
                            controller: serviceController,
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
                                  color: red,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                    color: red, width: 0.5),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: red,
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
                      if(hasPackage)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Service Package",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .apply(color: darkBrown),
                            ),
                            TextFormField(
                              readOnly: true,
                              onTap: () {
                                if (serviceId != "") {
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
                                                  stream: FirebaseFirestore.instance.collection('service_packages')
                                                      .where("serviceId", isEqualTo: serviceId).snapshots(),
                                                  builder: (BuildContextcontext, AsyncSnapshot<QuerySnapshot>snapshot) {
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
                                                                "No Services Added",
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
                                                                _packageController.text = "${data['title']}";
                                                                _packageArController.text = "${data['title_ar']}";
                                                                _packageId = document.reference.id;
                                                                amountController.text = "${data['price']}";
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            title: Text(
                                                              "${data['title']}",
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
                                }
                                else {
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible: false,
                                    // user must tap button!
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                          'No Category Selected',
                                          style: TextStyle(
                                              color: Colors.black),
                                        ),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: const <Widget>[
                                              Text(
                                                "Please select a category before selecting a service",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
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
                              controller: _packageController,
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
                                    color: red,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7.0),
                                  borderSide: BorderSide(
                                      color: red, width: 0.5),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7.0),
                                  borderSide: BorderSide(
                                    color: red,
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
                      if(hasPackage)
                        SizedBox(height: 10,),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Date",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .apply(color: darkBrown),
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
                                  color: red,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                    color: red, width: 0.5),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: red,
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
                                .apply(color: darkBrown),
                          ),
                          TextFormField(
                            readOnly: true,
                            onTap: () {
                              if (serviceController.text != "") {
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
                                      title: const Text(
                                          'No Service Selected'),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: const <Widget>[
                                            Text(
                                                "Please select a service before reserving a time slot"),
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
                                  color: red,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                    color: red, width: 0.5),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: red,
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
                            "Place",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .apply(color: darkBrown),
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
                                                  .collection('places')
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
                                                      child: Text(
                                                          "No Place Added",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black)));
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
                                                            onTap: () async {
                                                              int i = 0;
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                  'appointments')
                                                                  .where(
                                                                  "placeId",
                                                                  isEqualTo: document
                                                                      .reference
                                                                      .id)
                                                                  .get()
                                                                  .then((QuerySnapshot
                                                              querySnapshot) {
                                                                querySnapshot
                                                                    .docs
                                                                    .forEach(
                                                                        (doc) {
                                                                      if (doc["time"] ==
                                                                          timeController
                                                                              .text &&
                                                                          doc["date"] ==
                                                                              dateController.text)
                                                                        i++;
                                                                    });
                                                                if (i <
                                                                    int.parse(
                                                                        data[
                                                                        'capacity'])) {
                                                                  setState(
                                                                          () {
                                                                        placeController
                                                                            .text =
                                                                        "${data['name']}";
                                                                        placeId = document
                                                                            .reference
                                                                            .id;
                                                                      });
                                                                } else {
                                                                  showDialog<
                                                                      void>(
                                                                    context:
                                                                    context,
                                                                    barrierDismissible:
                                                                    false,
                                                                    // user must tap button!
                                                                    builder:
                                                                        (BuildContext
                                                                    context) {
                                                                      return AlertDialog(
                                                                        title:
                                                                        const Text('Full Capacity'),
                                                                        content:
                                                                        SingleChildScrollView(
                                                                          child:
                                                                          ListBody(
                                                                            children: const <Widget>[
                                                                              Text("Please select another place since its already full"),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        actions: <
                                                                            Widget>[
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
                                                              });

                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            title: Text(
                                                              "${data['name']}",
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
                            controller: placeController,
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
                                  color: red,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                    color: red, width: 0.5),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: red,
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
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: red)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add Promo Code',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .apply(color: Colors.black),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: couponController,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(15),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(7.0),
                                  borderSide: BorderSide(
                                    color: red,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(7.0),
                                  borderSide: BorderSide(
                                      color: red, width: 0.5),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(7.0),
                                  borderSide: BorderSide(
                                    color: red,
                                    width: 0.5,
                                  ),
                                ),
                                hintText: "Enter Promo Code",
                                floatingLabelBehavior:
                                FloatingLabelBehavior.always,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  //amountController=amount;
                                });
                                int i = 0;
                                FirebaseFirestore.instance
                                    .collection('coupons')
                                    .where("code",
                                    isEqualTo:
                                    couponController.text.trim())
                                    .where("serviceId",
                                    isEqualTo: serviceId)
                                    .get()
                                    .then((QuerySnapshot querySnapshot) {
                                  querySnapshot.docs.forEach((doc) {
                                    setState(() {
                                      i++;
                                    });
                                    FirebaseFirestore.instance
                                        .collection('redeemedCoupons')
                                        .doc(FirebaseAuth
                                        .instance.currentUser!.uid)
                                        .get()
                                        .then((DocumentSnapshot
                                    documentSnapshot) {
                                      if (documentSnapshot.exists) {
                                        Map<String, dynamic> data =
                                        documentSnapshot.data()
                                        as Map<String, dynamic>;
                                        List coupons = data['coupons'];
                                        ids = coupons;
                                        int counter = 0;
                                        int totalLimit =
                                        int.parse(doc['usage']);
                                        for (int c = 0;
                                        c < coupons.length;
                                        c++) {
                                          if (coupons[c] ==
                                              doc.reference.id) {
                                            counter++;
                                          }
                                        }
                                        if (counter >= totalLimit) {
                                          final snackBar = SnackBar(
                                              content:
                                              Text("Limit Exceeded"));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        } else {
                                          print(
                                              "code ${doc['code']} ${serviceId}");
                                          couponId = doc.reference.id;
                                          if (doc['discountType'] ==
                                              'Percentage') {
                                            double percent = double.parse(
                                                doc['discount']) /
                                                100;
                                            percent = double.parse(
                                                amountController
                                                    .text) *
                                                percent;
                                            percent = double.parse(
                                                amountController
                                                    .text) -
                                                percent;
                                            setState(() {
                                              amountController.text =
                                                  (percent).toString();
                                            });
                                          } else {
                                            setState(() {
                                              amountController
                                                  .text = (double.parse(
                                                  amountController
                                                      .text) -
                                                  double.parse(doc[
                                                  'discount']))
                                                  .toString();
                                            });
                                          }
                                        }
                                      } else {
                                        couponId = doc.reference.id;
                                        print(
                                            "code ${doc['code']} ${serviceId}");
                                        if (doc['discountType'] ==
                                            'Percentage') {
                                          double percent = double.parse(
                                              doc['discount']) /
                                              100;
                                          percent = double.parse(
                                              amountController.text) *
                                              percent;
                                          percent = double.parse(
                                              amountController.text) -
                                              percent;
                                          setState(() {
                                            amountController.text =
                                                (percent).toString();
                                          });
                                        } else {
                                          setState(() {
                                            amountController
                                                .text = (double.parse(
                                                amountController
                                                    .text) -
                                                double.parse(
                                                    doc['discount']))
                                                .toString();
                                          });
                                        }
                                      }
                                    });
                                  });
                                  if (i == 0) {
                                    print("Invalid Code");
                                    showDialog<void>(
                                      context: context,
                                      barrierDismissible: false,
                                      // user must tap button!
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                            'Invalid Code',
                                            style: TextStyle(
                                                color: Colors.black),
                                          ),
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              children: const <Widget>[
                                                Text(
                                                  "Please try another code",
                                                  style: TextStyle(
                                                      color:
                                                      Colors.black),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('OK'),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: darkBrown,
                                    borderRadius:
                                    BorderRadius.circular(10)),
                                alignment: Alignment.center,
                                child: Text(
                                  'Redeem',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            )
                          ],
                        ),
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
                                .apply(color: darkBrown),
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
                                  color: red,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                    color: red, width: 0.5),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: red,
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
                            "Specialist",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .apply(color: darkBrown),
                          ),
                          TextFormField(
                            readOnly: true,
                            onTap: () {
                              if (serviceController.text != "") {
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
                                                    'specialists')
                                                    .where("serviceIds",
                                                    arrayContains:
                                                    serviceId)
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
                                                              "No Specialists",
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
                                                      specialist =
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
                                                              specialistController
                                                                  .text =
                                                              "${specialist['name']}";
                                                              specialistId =
                                                                  document
                                                                      .reference
                                                                      .id;
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
                                                            "${specialist['name']}",
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
                                      title: const Text(
                                        'No Service Selected',
                                        style: TextStyle(
                                            color: Colors.black),
                                      ),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: const <Widget>[
                                            Text(
                                                "Please select a service before reserving a specialist",
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('OK',
                                              style: TextStyle(
                                                  color: Colors.black)),
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
                            controller: specialistController,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(15),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: red,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                    color: red, width: 0.5),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: red,
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
                                .apply(color: darkBrown),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.0),
                              border: Border.all(
                                color: red,
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
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            final f = new DateFormat('dd-MM-yyyy');
                            if (payment == 'Cash Payment') {
                              final ProgressDialog pr = ProgressDialog(context: context);
                              pr.show(max: 100, msg: "Adding");
                              FirebaseFirestore.instance.collection('appointments').add({
                                'name': userController.text,
                                'amount': amountController.text,
                                'userId': userId,
                                'branchName': branchController.text,
                                'place': placeController.text,
                                'branchId': branchId,
                                'placeId': placeId,
                                'date': dateController.text,
                                'time': timeController.text,
                                'specialistId': specialistId,
                                'specialistName': specialistController.text == "" ? "none" : specialistController.text,
                                'serviceId': serviceId,
                                'serviceName': serviceController.text,
                                'status': "Approved",
                                'isRated': false,
                                'rating': 0,
                                'paid': false,
                                'points': points,
                                'paymentMethod': payment,
                                'datePosted': DateTime.now().millisecondsSinceEpoch,
                                'dateBooked': start!.millisecondsSinceEpoch,
                                'formattedDate': f.format(DateTime.now()).toString(),
                                'day': DateTime.now().day,
                                'month': DateTime.now().month,
                                'year': DateTime.now().year,
                                'packageId': _packageId,
                                'adminBooking':true,
                                'adminId':FirebaseAuth.instance.currentUser!.uid,
                                'adminName':widget.admin.username,
                                'gender':genderController.text,
                                'packageName': _packageController.text==""?"none":_packageController.text,
                                'packageArName': _packageController.text==""?"none":_packageController.text,
                              }).then((value) {
                                if (couponId != "") {
                                  ids.add(couponId);
                                  FirebaseFirestore.instance
                                      .collection('redeemedCoupons')
                                      .doc(FirebaseAuth
                                      .instance.currentUser!.uid)
                                      .set({'coupons': ids});
                                }

                                branchController.text="";
                                _packageController.text="";
                                _packageArController.text="";
                                serviceController.text="";
                                dateController.text="";
                                userController.text="";
                                timeController.text="";
                                amountController.text="";
                                placeController.text="";
                                genderController.text="";
                                couponController.text="";
                                categoryController.text="";
                                specialistController.text="";


                                pr.close();
                                Navigator.pop(context);
                                //Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BookingScreen()));
                              });
                            }
                            else if (payment == 'Card Payment') {
                              final ProgressDialog pr = ProgressDialog(context: context);
                              pr.show(max: 100, msg: "Adding");
                              FirebaseFirestore.instance
                                  .collection('appointments')
                                  .add({
                                'name': userController.text,
                                'amount': amountController.text,
                                'userId': userId,
                                'branchName': branchController.text,
                                'place': placeController.text,
                                'branchId': branchId,
                                'placeId': placeId,
                                'date': dateController.text,
                                'time': timeController.text,
                                'specialistId': specialistId,
                                'specialistName':
                                specialistController.text == ""
                                    ? "none"
                                    : specialistController.text,
                                'serviceId': serviceId,
                                'serviceName': serviceController.text,
                                'status': "Approved",
                                'isRated': false,
                                'rating': 0,
                                'paid': true,
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
                                'gender':genderController.text,
                                'adminId':FirebaseAuth.instance.currentUser!.uid,
                                'adminName':widget.admin.username,
                              }).then((value) {
                                if (couponId != "") {
                                  ids.add(couponId);
                                  FirebaseFirestore.instance
                                      .collection('redeemedCoupons')
                                      .doc(FirebaseAuth
                                      .instance.currentUser!.uid)
                                      .set({'coupons': ids});
                                }
                                pr.close();
                                Navigator.pop(context);

                              });
                            }
                          }
                        },
                        child: Container(
                          height: 50,
                          color: darkBrown,
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
            ),
          ],
        ),
      ),
    );
  }
}
