import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:spa_admin_app/models/checklist_model.dart';
import 'package:spa_admin_app/models/coupon_model.dart';
import 'package:spa_admin_app/utils/constants.dart';
import 'package:spa_admin_app/widgets/appbar.dart';

class AddPromoCode extends StatefulWidget {
  List<CheckListModel> list;

  AddPromoCode(this.list);

  @override
  _AddPromoCodeState createState() => _AddPromoCodeState();
}

class _AddPromoCodeState extends State<AddPromoCode> {
  String imageUrl="";
  bool imageUploading=false;

  register(CouponModel model) async{
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 100, msg: "Adding");
    FirebaseFirestore.instance.collection('coupons').add({
      'name': model.name,
      'image': model.image,
      'serviceName': model.serviceName,
      'serviceId': model.serviceId,
      'discount': model.discount,
      'discountType': model.discountType,
      'usage':model.usage,
      'startDate': model.startDate,
      'code':model.code,
      'endDate': model.endDate,
      'branchId': model.branchId,
    }).then((value) {
      pr.close();
      print("added");
      Navigator.pop(context);
    });
  }

  File? _imageFile;

  final picker = ImagePicker();

  Future uploadImageToFirebase(BuildContext context) async {
    setState((){
      imageUploading=true;
    });
    var storage = FirebaseStorage.instance;
    TaskSnapshot snapshot = await storage.ref().child('bookingPics/${DateTime.now().millisecondsSinceEpoch}').putFile(_imageFile!);
    if (snapshot.state == TaskState.success) {
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        imageUrl = downloadUrl;
        imageUploading=false;
      });
    }
  }
  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _imageFile = File(pickedFile!.path);
    });
    uploadImageToFirebase(context);
  }

  Future pickImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile!.path);
    });
    uploadImageToFirebase(context);
  }

  choiceDialog(){
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Card(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.8),
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(30.0),
              topLeft: Radius.circular(30.0),
            ),
          ),
          elevation: 2,

          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: (){
                    pickImage();
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.maxFinite,
                    height: 40,
                    margin: EdgeInsets.only(left: 40,right: 40),
                    child:Text("Take Picture From Camera",style: TextStyle(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w400),),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30)
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                    pickImageFromGallery();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.maxFinite,
                    height: 40,
                    margin: EdgeInsets.only(left: 40,right: 40),
                    child:Text("Choose From Gallery",style: TextStyle(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w400),),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30)
                    ),
                  ),
                ),

              ],
            ),
          ),
        );
      },
    );
  }

  var nameController=TextEditingController();
  var discountController=TextEditingController();
  var usageController=TextEditingController();
  var codeController=TextEditingController();
  var startController=TextEditingController();
  var endController=TextEditingController();
  var serviceController=TextEditingController();
  String? _serviceId;
  var branchController=TextEditingController();
  var _genderController=TextEditingController();
  var _categoryController=TextEditingController();
  String branchId="";

  final f = new DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    super.initState();
    startController.text=f.format(DateTime.now()).toString();
    endController.text=f.format(DateTime.now()).toString();
  }

  String? discountType='Percentage';
  DateTime? start;
  DateTime? end;
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
        startController.text=f.format(start!).toString();

      });
  }
  _selectEndDate(BuildContext context) async {
    end = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Refer step 1
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (end != null && end != DateTime.now())
      setState(() {
        final f = new DateFormat('dd-MM-yyyy');
        endController.text=f.format(end!).toString();

      });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar("Add Promo Code"),
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Expanded(
                      child: ListView(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Title",
                                style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                              ),
                              TextFormField(
                                controller: nameController,
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
                                        color: primaryColor,
                                        width: 0.5
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                      width: 0.5,
                                    ),
                                  ),
                                  hintText: "",
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),

                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Code",
                                      style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                                    ),
                                    TextFormField(
                                      controller: codeController,
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
                                              color: primaryColor,
                                              width: 0.5
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(7.0),
                                          borderSide: BorderSide(
                                            color: primaryColor,
                                            width: 0.5,
                                          ),
                                        ),
                                        hintText: "",
                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "",
                                    style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                                  ),
                                  SizedBox(width: 10,),
                                  InkWell(
                                    onTap: (){
                                      setState((){
                                        codeController.text=generatePassword();
                                      });
                                    },
                                    child: Container(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width*0.15,
                                      color: secondaryColor,
                                      alignment: Alignment.center,
                                      child: Text("Generate",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
                                    ),
                                  )
                                ],
                              ),

                            ],
                          ),

                          SizedBox(height: 10,),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Branch",
                                style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                              ),
                              TextFormField(
                                readOnly: true,
                                onTap: (){
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context){
                                        return StatefulBuilder(
                                          builder: (context,setState){
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
                                                width: MediaQuery.of(context).size.width*0.3,
                                                child: StreamBuilder<QuerySnapshot>(
                                                  stream: FirebaseFirestore.instance.collection('branches').snapshots(),
                                                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                    if (snapshot.hasError) {
                                                      return Center(
                                                        child: Column(
                                                          children: [
                                                            Image.asset("assets/images/wrong.png",width: 150,height: 150,),
                                                            Text("Something Went Wrong",style: TextStyle(color: Colors.black))

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
                                                      return Center(
                                                        child: Column(
                                                          children: [
                                                            Image.asset("assets/images/empty.png",width: 150,height: 150,),
                                                            Text("No Branches Added",style: TextStyle(color: Colors.black))

                                                          ],
                                                        ),
                                                      );

                                                    }

                                                    return new ListView(
                                                      shrinkWrap: true,
                                                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                                                        return new Padding(
                                                          padding: const EdgeInsets.only(top: 15.0),
                                                          child: ListTile(
                                                            onTap: (){
                                                              setState(() {
                                                                branchController.text="${data['name']}";
                                                                branchId=document.reference.id;
                                                              });
                                                              Navigator.pop(context);
                                                            },

                                                            title: Text("${data['name']}",style: TextStyle(color: Colors.black),),
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
                                      }
                                  );
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
                                      color: primaryColor,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                        color: primaryColor,
                                        width: 0.5
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                      width: 0.5,
                                    ),
                                  ),
                                  hintText: "",
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child:Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Start Date",
                                      style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                                    ),
                                    TextFormField(
                                      readOnly: true,
                                      onTap: ()=>_selectDate(context),
                                      controller:startController,
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
                                              color: primaryColor,
                                              width: 0.5
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(7.0),
                                          borderSide: BorderSide(
                                            color: primaryColor,
                                            width: 0.5,
                                          ),
                                        ),
                                        hintText: "",
                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                flex: 1,
                                child:Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "End Date",
                                      style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                                    ),
                                    TextFormField(
                                      readOnly: true,
                                      onTap: ()=>_selectEndDate(context),
                                      controller:endController,
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
                                              color: primaryColor,
                                              width: 0.5
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(7.0),
                                          borderSide: BorderSide(
                                            color: primaryColor,
                                            width: 0.5,
                                          ),
                                        ),
                                        hintText: "",
                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),

                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Expanded(
                                flex: 6,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Discount",
                                      style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                                    ),
                                    TextFormField(
                                      controller:discountController,
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
                                              color: primaryColor,
                                              width: 0.5
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(7.0),
                                          borderSide: BorderSide(
                                            color: primaryColor,
                                            width: 0.5,
                                          ),
                                        ),
                                        hintText: "",
                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "",
                                      style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7.0),
                                        border: Border.all(
                                            color: primaryColor,
                                            width: 0.5
                                        ),
                                      ),
                                      child: DropdownButton<String>(
                                        value: discountType,
                                        elevation: 16,
                                        isExpanded:true,
                                        style: const TextStyle(color: Colors.black),
                                        underline: Container(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            discountType = newValue!;
                                          });
                                        },
                                        items: <String>['Percentage', 'Amount']
                                            .map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 10,),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Gender",
                                style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                              ),
                              TextFormField(
                                readOnly: true,
                                onTap: (){
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context){
                                        return StatefulBuilder(
                                          builder: (context,setState){
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
                                                padding: EdgeInsets.all(10),
                                                width: MediaQuery.of(context).size.width*0.3,
                                                child: StreamBuilder<QuerySnapshot>(
                                                  stream: FirebaseFirestore.instance.collection('genders').snapshots(),
                                                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                    if (snapshot.hasError) {
                                                      return Center(
                                                        child: Column(
                                                          children: [
                                                            Image.asset("assets/images/wrong.png",width: 150,height: 150,),
                                                            Text("Something Went Wrong",style: TextStyle(color: Colors.black))

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
                                                      return Center(
                                                          child: Text("No Genders Added",style: TextStyle(color: Colors.black))
                                                      );

                                                    }

                                                    return new ListView(
                                                      shrinkWrap: true,
                                                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                                                        return new Padding(
                                                          padding: const EdgeInsets.only(top: 15.0),
                                                          child: ListTile(
                                                            onTap: (){
                                                              setState(() {
                                                                _genderController.text="${data['gender']}";
                                                              });
                                                              Navigator.pop(context);
                                                            },
                                                            leading: CircleAvatar(
                                                              radius: 25,
                                                              backgroundImage: NetworkImage(data['image']),
                                                              backgroundColor: Colors.indigoAccent,
                                                              foregroundColor: Colors.white,
                                                            ),
                                                            title: Text("${data['gender']}",style: TextStyle(color: Colors.black),),
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
                                      }
                                  );
                                },
                                controller: _genderController,
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
                                        color: primaryColor,
                                        width: 0.5
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                      width: 0.5,
                                    ),
                                  ),
                                  hintText: "",
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Category",
                                style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                              ),
                              TextFormField(
                                readOnly: true,
                                onTap: (){

                                  if(_genderController.text==""){
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
                                        builder: (BuildContext context){
                                          return StatefulBuilder(
                                            builder: (context,setState){
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
                                                  width: MediaQuery.of(context).size.width*0.3,
                                                  child: StreamBuilder<QuerySnapshot>(
                                                    stream: FirebaseFirestore.instance.collection('categories')
                                                        .where("gender",isEqualTo:_genderController.text).snapshots(),
                                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                      if (snapshot.hasError) {
                                                        return Center(
                                                          child: Column(
                                                            children: [
                                                              Image.asset("assets/images/wrong.png",width: 150,height: 150,),
                                                              Text("Something Went Wrong",style: TextStyle(color: Colors.black))

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
                                                        return Center(
                                                          child: Column(
                                                            children: [
                                                              Image.asset("assets/images/empty.png",width: 150,height: 150,),
                                                              Text("No Categories Added",style: TextStyle(color: Colors.black))

                                                            ],
                                                          ),
                                                        );

                                                      }

                                                      return new ListView(
                                                        shrinkWrap: true,
                                                        children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                                          Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                                                          return new Padding(
                                                            padding: const EdgeInsets.only(top: 15.0),
                                                            child: ListTile(
                                                              onTap: (){
                                                                setState(() {
                                                                  _categoryController.text="${data['name']}";
                                                                });
                                                                Navigator.pop(context);
                                                              },
                                                              leading: CircleAvatar(
                                                                radius: 25,
                                                                backgroundImage: NetworkImage(data['image']),
                                                                backgroundColor: Colors.indigoAccent,
                                                                foregroundColor: Colors.white,
                                                              ),
                                                              title: Text("${data['name']}",style: TextStyle(color: Colors.black),),
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
                                        }
                                    );
                                  }

                                },
                                controller: _categoryController,
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
                                        color: primaryColor,
                                        width: 0.5
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                      width: 0.5,
                                    ),
                                  ),
                                  hintText: "",
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Service",
                                style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                              ),
                              TextFormField(
                                readOnly: true,
                                onTap: (){
                                  if(_genderController.text=="" || _categoryController.text==""){
                                    showDialog<void>(
                                      context: context,
                                      barrierDismissible: false, // user must tap button!
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('No Gender\\Category Selected',style: TextStyle(color: Colors.black),),
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              children: const <Widget>[
                                                Text("Please select gender and category",style: TextStyle(color: Colors.black)),
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
                                        builder: (BuildContext context){
                                          return StatefulBuilder(
                                            builder: (context,setState){
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
                                                  width: MediaQuery.of(context).size.width*0.3,
                                                  child: StreamBuilder<QuerySnapshot>(
                                                    stream: FirebaseFirestore.instance.collection('services')
                                                        .where("gender",isEqualTo:_genderController.text)
                                                        .where("categoryName",isEqualTo:_categoryController.text).snapshots(),
                                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                      if (snapshot.hasError) {
                                                        return Center(
                                                          child: Column(
                                                            children: [
                                                              Image.asset("assets/images/wrong.png",width: 150,height: 150,),
                                                              Text("Something Went Wrong",style: TextStyle(color: Colors.black))

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
                                                        return Center(
                                                          child: Column(
                                                            children: [
                                                              Image.asset("assets/images/empty.png",width: 150,height: 150,),
                                                              Text("No Services Added",style: TextStyle(color: Colors.black))

                                                            ],
                                                          ),
                                                        );

                                                      }

                                                      return new ListView(
                                                        shrinkWrap: true,
                                                        children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                                          Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                                                          return new Padding(
                                                            padding: const EdgeInsets.only(top: 15.0),
                                                            child: ListTile(
                                                              onTap: (){
                                                                setState(() {
                                                                  serviceController.text="${data['name']}";
                                                                  _serviceId=document.reference.id;
                                                                });
                                                                Navigator.pop(context);
                                                              },
                                                              leading: CircleAvatar(
                                                                radius: 25,
                                                                backgroundImage: NetworkImage(data['image']),
                                                                backgroundColor: Colors.indigoAccent,
                                                                foregroundColor: Colors.white,
                                                              ),
                                                              title: Text("${data['name']}",style: TextStyle(color: Colors.black),),
                                                              subtitle: Text("${data['categoryName']}",style: TextStyle(color: Colors.black),),

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
                                        }
                                    );
                                  }


                                },
                                controller:serviceController,
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
                                        color: primaryColor,
                                        width: 0.5
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                      width: 0.5,
                                    ),
                                  ),
                                  hintText: "",
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Usage",
                                style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                controller:usageController,
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
                                        color: primaryColor,
                                        width: 0.5
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                      width: 0.5,
                                    ),
                                  ),
                                  hintText: "",
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Column(
                            children: [
                              Container(
                                height: 150,
                                width: MediaQuery.of(context).size.width*0.9,
                                child: imageUploading?Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Uploading",style: TextStyle(color: primaryColor),),
                                      SizedBox(width: 10,),
                                      CircularProgressIndicator()
                                    ],),
                                ):imageUrl==""?
                                Image.asset("assets/images/placeholder.png",height: 100,width: MediaQuery.of(context).size.width*0.9,fit: BoxFit.cover,)
                                    :Image.network(imageUrl,height: 100,width: 100,fit: BoxFit.cover,),
                              ),
                              SizedBox(height: 10),
                              InkWell(
                                onTap: (){
                                   choiceDialog();
                                },
                                child: Container(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width*0.9,
                                  color: secondaryColor,
                                  alignment: Alignment.center,
                                  child: Text("Add Photo",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Branches",
                                style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Container(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: widget.list.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context,int index){
                                return Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: CheckboxListTile(
                                      title: Text(widget.list[index].model.name,style: TextStyle(color: Colors.black),),
                                      value: widget.list[index].check,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          widget.list[index].check = value!;
                                        });
                                      },
                                    )
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 15,),
                          GestureDetector(
                            onTap: (){
                              print("ov");
                              if (_formKey.currentState!.validate()) {
                                List<String> ids=[];
                                for(int i=0;i<widget.list.length;i++){
                                  if(widget.list[i].check)
                                    ids.add(widget.list[i].model.id);
                                }
                                CouponModel model=new CouponModel(
                                  "",
                                  nameController.text,
                                  imageUrl,
                                  serviceController.text,
                                  _serviceId!,
                                  discountController.text,
                                  discountType!,
                                  codeController.text,
                                  startController.text,
                                  endController.text,
                                  usageController.text,
                                  ids,
                                );
                                register(model);
                              }
                            },
                            child: Container(
                              height: 50,
                              color: secondaryColor,
                              alignment: Alignment.center,
                              child: Text("Add Promo Code",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
