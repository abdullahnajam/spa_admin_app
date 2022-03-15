import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:spa_admin_app/models/multiple_selection.dart';
import 'package:spa_admin_app/models/service_model.dart';
import 'package:spa_admin_app/utils/constants.dart';
import 'package:spa_admin_app/widgets/appbar.dart';
import 'dart:ui' as UI;
class AddService extends StatefulWidget {
  const AddService({Key? key}) : super(key: key);

  @override
  _AddServiceState createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {

  registerService(ServiceModel model,List<OfferServices> service,List<ServicePackageModel> packages,context) async{
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 100, msg: "Adding");
    String key=DateTime.now().millisecondsSinceEpoch.toString();
    if(model.hasPackages){
      packages.sort((a, b) => a.price.compareTo(b.price));
      print("smallest price ${packages[0].price}");
      model.price=packages[0].price.toString();
    }

    int position=0;
    await FirebaseFirestore.instance.collection('services').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        position++;
      });
    });
    FirebaseFirestore.instance.collection('services').doc(key).set({
      'name': model.name,
      'name_ar': model.name_ar,
      'image': model.image,
      'description':model.description,
      'description_ar':model.description_ar,
      'isFeatured':model.isFeatured,
      'gender': model.gender,
      'categoryName': model.categoryName,
      'categoryId': model.categoryId,
      'rating': 0,
      'totalRating':0,
      'price': model.price,
      'tags':model.tags,
      'points':model.points,
      'isActive':model.isActive,
      'genderId':model.genderId,
      'isRedeemable':false,
      'redeemPoints':0,
      'branchIds':model.branchIds,
      'isAllBranchs':model.isAllBranchs,
      'packages':model.packages,
      'hasPackages':model.hasPackages,
      'position':position
    }).then((value) {
      for(int i=0;i<service.length;i++){
        FirebaseFirestore.instance.collection('service_branches').add({
          'branchId': service[i].id,
          'name_ar': service[i].name_ar,
          'name': service[i].name,
          'serviceId': key,

        });
      }
      for(int i=0;i<packages.length;i++){
        FirebaseFirestore.instance.collection('service_packages').add({
          'title': packages[i].title,
          'title_ar': packages[i].title_ar,
          'status': packages[i].status,
          'serviceId': key,
          'price': packages[i].price,
        });
      }
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
  List<ServicePackageModel> packages=[];
  List<OfferServices> services=[];
  List<String> serviceIds=[];
  String imageUrl="";
  bool imageUploading=false;
  bool isActive=true;
  bool hasPackages=true;
  bool isFeatured=true;
  bool isAll=false;
  var _titleController=TextEditingController();
  var _titleARController=TextEditingController();
  var _packagePriceController=TextEditingController();

  var nameController=TextEditingController();
  var nameARController=TextEditingController();
  var desController=TextEditingController();
  var desArController=TextEditingController();
  var priceController=TextEditingController();
  var categoryName=TextEditingController();
  var tagController=TextEditingController();
  var pointsController=TextEditingController();
  var gender=TextEditingController();
  var branchController=TextEditingController();
  OfferServices? offerService;
  String service_error="";
  String? categoryId,genderId;
  int _step = 0;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar("Add Service"),
            Expanded(
              child: Stepper(
                type: StepperType.vertical,
                controlsBuilder: (BuildContext context, {UI.VoidCallback? onStepContinue, UI.VoidCallback? onStepCancel}) {
                  return Row(
                    children: <Widget>[
                      TextButton(
                        onPressed: onStepContinue,
                        child: _step==3?  Text('Add Service'):Text('Continue'),
                      ),
                      TextButton(
                        onPressed: onStepCancel,
                        child: const Text('Back'),
                      ),
                    ],
                  );
                },
                currentStep: _step,
                onStepCancel: () {
                  if (_step > 0) {
                    setState(() { _step -= 1; });
                  }
                },
                onStepContinue: () {
                  if (_step == 0) {
                    if (_formKey.currentState!.validate()) {
                      setState(() { _step += 1; });
                      print("step continue $_step");
                    }
                  }
                  else if(_step==1){
                    List<String> packagesId=[];
                    for(int i=0;i<services.length;i++){
                      serviceIds.add(services[i].id);
                    }
                    for(int i=0;i<services.length;i++){
                      serviceIds.add(services[i].id);
                    }
                    for(int i=0;i<packages.length;i++){
                      packagesId.add(packages[i].id);
                    }
                    ServiceModel model=new ServiceModel(
                      "",
                      nameController.text,
                      nameARController.text,
                      desController.text,
                      desArController.text,
                      isFeatured,
                      imageUrl,
                      gender.text,
                      categoryName.text,
                      categoryId!,
                      0,
                      priceController.text,
                      0,
                      tagController.text,
                      isActive,
                      int.parse(pointsController.text),
                      genderId!,
                      false,
                      0,
                      serviceIds,
                      isAll,
                      packagesId,
                      hasPackages,


                    );
                    registerService(model,services,packages,context);
                  }
                },
                onStepTapped: (int index) {
                  setState(() { _step = index; });
                },
                steps: <Step>[
                  Step(
                    isActive: _step >= 0?true:false,
                    state: _step >= 1 ? StepState.complete : StepState.disabled,
                    title: Text('Service Data'),
                    content: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Name",
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
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Name (Arabic)",
                                style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                              ),
                              TextFormField(
                                controller: nameARController,
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
                                "Description",
                                style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                              ),
                              TextFormField(
                                maxLines: 3,
                                minLines: 3,
                                controller: desController,
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
                                "Description (Arabic)",
                                style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                              ),
                              TextFormField(
                                maxLines: 3,
                                minLines: 3,
                                controller: desArController,
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
                                "Price",
                                style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                              ),
                              TextFormField(
                                inputFormatters: [
                                ],
                                controller: priceController,
                                style: TextStyle(color: Colors.black),
                                validator: (value) {
                                  if (double.tryParse(value!)== null) {
                                    return "please enter a number";
                                  }
                                  else if (value == null || value.isEmpty) {
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
                                "Tags",
                                style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                              ),
                              TextFormField(
                                controller: tagController,
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
                                "Points",
                                style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                              ),
                              TextFormField(
                                controller: pointsController,
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
                          CheckboxListTile(

                            title: const Text('Active',style: TextStyle(color: Colors.black),),
                            value: isActive,
                            onChanged: (bool? value) {
                              setState(() {
                                isActive = value!;
                              });
                            },
                            secondary: const Icon(Icons.timer,color: Colors.black,),
                          ),
                          CheckboxListTile(

                            title: const Text('Featured',style: TextStyle(color: Colors.black),),
                            value: isFeatured,
                            onChanged: (bool? value) {
                              setState(() {
                                isFeatured = value!;
                              });
                            },
                            secondary: const Icon(Icons.star_border,color: Colors.black,),
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
                                                                gender.text="${data['gender']}";
                                                                genderId=document.reference.id;
                                                                print("gender set ${gender.text}");
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
                                controller: gender,
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

                                  if(gender.text==""){
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
                                                        .where("gender",isEqualTo:gender.text).snapshots(),
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
                                                                  categoryName.text="${data['name']}";
                                                                  categoryId=document.reference.id;
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
                                controller: categoryName,
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
                              SizedBox(height: 10,),
                              InkWell(
                                onTap: (){
                                  showDialog<void>(
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
                                },
                                child: Container(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width*0.9,
                                  color: secondaryColor,
                                  alignment: Alignment.center,
                                  child: Text("Add Photo",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
                                ),
                              ),

                            ],
                          ),
                          SizedBox(height: 10),
                          CheckboxListTile(

                            title: const Text('All Branches',style: TextStyle(color: Colors.black),),
                            value: isAll,
                            onChanged: (bool? value) {
                              setState(() {
                                isAll = value!;
                              });
                            },
                            secondary: const Icon(Icons.star_border,color: Colors.black,),
                          ),
                          SizedBox(height: 10,),
                          !isAll?
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Branches",
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
                                                                  Text("No Data",style: TextStyle(color: Colors.black))

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
                                                                      branchController.text=data['name'];
                                                                      offerService=new OfferServices(document.reference.id,data['name'],"none");
                                                                      /*services.add(offerService);
                                                                          print(services.length);*/
                                                                    });
                                                                    Navigator.pop(context);
                                                                  },

                                                                  title: Text("${data['name']}",style: TextStyle(color: Colors.black),),
                                                                  subtitle: Text("${data['location']}",maxLines: 1,style: TextStyle(color: Colors.black),),

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
                                      controller:branchController,
                                      style: TextStyle(color: Colors.black),
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
                              SizedBox(width: 10),
                              Column(
                                children: [
                                  Text(
                                    "",
                                    style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.red),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      if(branchController.text==""){
                                        setState(() {
                                          service_error="No branches selected";
                                        });
                                      }
                                      else{
                                        setState(() {
                                          service_error="";
                                          branchController.text="";
                                          services.add(offerService!);
                                          print(services.length);
                                        });
                                      }

                                      //uploadImage();
                                    },
                                    child: Container(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width*0.15,
                                      color: secondaryColor,
                                      alignment: Alignment.center,
                                      child: Text("Add",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
                                    ),
                                  )

                                ],
                              ),


                            ],
                          )
                              :
                          Container(),

                          if(!isAll)
                            Text(
                              service_error,
                              style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.red),
                            ),

                          SizedBox(height: 10),
                          !isAll?services.length>0?Container(
                            height: 100,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: services.length,
                              itemBuilder: (context,int index){
                                return ListTile(
                                  title: Text(services[index].name,style: TextStyle(color: Colors.black),),
                                  trailing: IconButton(
                                    onPressed: (){
                                      setState((){
                                        services.removeAt(index);
                                      });

                                    },
                                    icon: Icon(Icons.delete_forever,color: Colors.black,),

                                  ),
                                );
                              },
                            ),
                          ):
                          Container():Container(),
                        ],
                      ),
                    ),
                  ),
                  Step(
                      isActive: _step >= 1?true:false,
                      state: _step >= 2 ? StepState.complete : StepState.disabled,
                      title: Text('Packages'),
                      content: Column(
                        children: [
                          CheckboxListTile(

                            title: const Text('Packages',style: TextStyle(color: Colors.black),),
                            value: hasPackages,
                            onChanged: (bool? value) {
                              setState(() {
                                hasPackages = value!;
                              });
                            },
                            secondary: const Icon(Icons.list_alt_sharp,color: Colors.black,),
                          ),
                          SizedBox(height: 10,),
                          if(hasPackages)
                            Column(
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Title (Arabic)",
                                      style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                                    ),
                                    TextFormField(
                                      controller: _titleARController,
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
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Title",
                                      style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                                    ),
                                    TextFormField(
                                      controller: _titleController,
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
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Price",
                                      style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                                    ),
                                    TextFormField(
                                      controller: _packagePriceController,
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
                                InkWell(
                                  onTap: (){
                                    ServicePackageModel _package=new ServicePackageModel(
                                        "id",
                                        _titleController.text,
                                        _titleARController.text,
                                        "Active",
                                        "serviceId",
                                        int.parse(_packagePriceController.text)
                                    );
                                    setState((){
                                      packages.add(_package);
                                    });

                                  },
                                  child: Container(
                                    height: 50,
                                    color: secondaryColor,
                                    alignment: Alignment.center,
                                    child: Text("Add Package",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
                                  ),
                                ),
                                SizedBox(height: 10),
                                if(packages.length==0)
                                  Container(
                                    child: Text('No packages',style: TextStyle(color: Colors.black),),
                                  )
                                else
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: packages.length,
                                      itemBuilder: (context,int i){
                                        return Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: ListTile(
                                              title: Text(packages[i].title,style: TextStyle(color: Colors.black),),
                                              leading: IconButton(
                                                onPressed: (){
                                                  setState((){
                                                    packages.removeAt(i);
                                                  });
                                                },
                                                icon: Icon(Icons.delete,color: Colors.black,),
                                              ),
                                              subtitle: Text(packages[i].title_ar,style: TextStyle(color: Colors.black),),
                                              trailing: Text(packages[i].price.toString(),style: TextStyle(color: Colors.black),),

                                            )
                                        );
                                      },
                                    ),
                                  ),
                              ],
                            )
                        ],
                      )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
