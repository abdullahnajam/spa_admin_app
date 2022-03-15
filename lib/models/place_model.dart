import 'package:cloud_firestore/cloud_firestore.dart';

class PlaceModel{
  String id,name,name_ar,capcity;
  int order;


  PlaceModel(this.id, this.name, this.name_ar, this.capcity,this.order);

  PlaceModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        name_ar = map['name_ar'],
        order = map['order'],
        capcity = map['capacity'];



  PlaceModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}