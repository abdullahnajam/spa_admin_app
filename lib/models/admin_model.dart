import 'package:cloud_firestore/cloud_firestore.dart';

class AdminModel{
  String id,username,email,phone,profilePicture,password,role,roleId;
  String branchId,branchName;
  String gender,genderId;

  AdminModel(this.id, this.username, this.email, this.phone,
      this.profilePicture, this.password, this.role, this.roleId,this.branchId,this.branchName
      ,this.gender,this.genderId);

  AdminModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        username = map['username'],
        email = map['email'],
        phone = map['phone'],
        profilePicture = map['profilePicture'],
        role = map['role'],
        password = map['password'],
        branchId = map['branchId']??"none",
        branchName = map['branchName']??"no branch",
        gender = map['gender']??"no gender",
        genderId = map['genderId']??"no gender",
        roleId = map['roleId'];



  AdminModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}