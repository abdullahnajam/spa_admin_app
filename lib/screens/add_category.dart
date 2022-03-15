import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:spa_admin_app/models/multiple_selection.dart';
import 'package:spa_admin_app/utils/constants.dart';
import 'package:spa_admin_app/widgets/appbar.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({Key? key}) : super(key: key);

  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  var categoryController=TextEditingController();
  var tagController=TextEditingController();
  var genderCategory=TextEditingController();
  var _positionCategory=TextEditingController();
  var catNameARController=TextEditingController();
  bool? isFeatured=false;
  bool isAll=false;
  var branchController=TextEditingController();
  OfferServices? offerService;
  String service_error="";
  List<OfferServices> services=[];
  List<String> serviceIds=[];
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
  addCategory(String photo) async{
    print("rr");
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 100, msg: "Adding");
    String key=DateTime.now().millisecondsSinceEpoch.toString();
    //mainCategoryName,mainCategoryNameAr,mainCategoryId
    int position=0;
    await FirebaseFirestore.instance.collection('categories').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        position++;
      });
    });
    FirebaseFirestore.instance.collection('categories').doc(key).set({
      'name': categoryController.text,
      'name_ar':catNameARController.text,
      'image': photo,
      'gender':genderCategory.text,
      'tags':tagController.text,
      'isFeatured':isFeatured,
      'branchIds':serviceIds,
      'isAllBranchs':isAll,
      'isSubCategory':false,
      'mainCategoryName':categoryController.text,
      'mainCategoryNameAr':catNameARController.text,
      'mainCategoryId':"none",
      'position':position

    }).then((value) {
      for(int i=0;i<services.length;i++){
        FirebaseFirestore.instance.collection('category_branches').add({
          'branchId': services[i].id,
          'name_ar': services[i].name_ar,
          'name': services[i].name,
          'categoryId': key,
        });
      }
      pr.close();
      print("added");
      Navigator.pop(context);
    });
  }

  String imageUrl="";
  bool imageUploading=false;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar("Add Category"),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Category Name",
                        style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                      ),
                      TextFormField(
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
                        "Category Arabic Name",
                        style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                      ),
                      TextFormField(
                        controller: catNameARController,
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

                    title: const Text('Featured',style: TextStyle(color: Colors.black),),
                    value: isFeatured,
                    onChanged: (bool? value) {
                      setState(() {
                        isFeatured = value!;
                      });
                    },
                    secondary: const Icon(Icons.timer,color: Colors.black,),
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
                                                        genderCategory.text="${data['gender']}";
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
                        controller: genderCategory,
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
                        "Category Tags",
                        style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                      ),
                      TextFormField(
                        minLines: 2,
                        maxLines: 2,
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
                  !isAll?Row(
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
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service_error,
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
                              child: Text("Add Branch",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
                            ),
                          )

                        ],
                      ),


                    ],
                  ):Container(),

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
                  SizedBox(height: 10,),
                  Column(
                    children: [
                      Container(
                        height: 100,
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
                            :Image.network(imageUrl,height: 100,width: 150,fit: BoxFit.cover,),
                      ),
                      SizedBox(height: 10,),
                      InkWell(
                        onTap: (){
                          choiceDialog();
                        },
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width*0.9,
                          color: secondaryColor,
                          alignment: Alignment.center,
                          child: Text("Add Image",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: 15,),
                  InkWell(
                    onTap: (){
                      print("tap");
                      for(int i=0;i<services.length;i++){
                        serviceIds.add(services[i].id);
                      }
                      addCategory(imageUrl);
                    },
                    child: Container(
                      height: 50,
                      color: secondaryColor,
                      alignment: Alignment.center,
                      child: Text("Add Category",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
