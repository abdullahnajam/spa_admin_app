import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  String id,firstName,lastName,email,phone,token,profilePicture,topic,gender,status;
  int wallet,points;
  String behaviourStatus,dateOfBirth;

  UserModel(this.id,this.firstName,this.lastName, this.email, this.phone, this.token,
      this.profilePicture, this.topic,this.points,this.wallet,this.gender,this.status,this.behaviourStatus,this.dateOfBirth);

  UserModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        firstName = map['firstName']??"firstName",
        lastName = map['lastName']??"lastName",
        gender = map['gender']??"Not Specified",
        email = map['email']??"Not Specified",
        dateOfBirth = map['dateOfBirth']??'01-01-2000',
        behaviourStatus = map['behaviourStatus']??'Not Assigned',
        phone = map['phone']??"Not Specified",
        token = map['token']??"Not Specified",
        profilePicture = map['profilePicture']??"none",
        topic = map['topic']??"Not Specified",
        points = map['points']??0,
        status = map['status']??"Active",
        wallet = map['wallet']??0;



  UserModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}