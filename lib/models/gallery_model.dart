import 'package:cloud_firestore/cloud_firestore.dart';

class GalleryModel{
  String id,serviceId,image;
  int position;


  GalleryModel(this.id, this.serviceId, this.position, this.image);

  GalleryModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        image = map['image'],
        serviceId = map['serviceId'],
        position = map['position'];



  GalleryModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}