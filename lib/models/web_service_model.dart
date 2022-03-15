import 'package:cloud_firestore/cloud_firestore.dart';

class WebServiceModel{
  String id,name,description,image,description_ar,name_ar;



  WebServiceModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        description = map['description'],
        name_ar = map['name_ar'],
        description_ar = map['description_ar'],
        image = map['icon'];



  WebServiceModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}