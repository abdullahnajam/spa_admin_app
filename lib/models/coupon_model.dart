import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class CouponModel{
  String id,name,image,serviceName,serviceId,discount,discountType,startDate,endDate,code, usage;
  List branchId;

  CouponModel(
      this.id,
      this.name,
      this.image,
      this.serviceName,
      this.serviceId,
      this.discount,
      this.discountType,
      this.code,
      this.startDate,
      this.endDate,
      this.usage,
      this.branchId);

  CouponModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        image = map['image'],
        serviceName = map['serviceName'],
        serviceId = map['serviceId'],
        discount = map['discount'],
        branchId = map['branchId']??[],
        discountType = map['discountType'],
        code = map['code'],
        startDate = map['startDate'],
        endDate = map['endDate'],
        usage = map['usage'];



  CouponModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}

String generatePassword({
  bool letter = true,
  bool isNumber = true,
  bool isSpecial = true,
}) {
  final length = 5;
  final letterUpperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  final number = '0123456789';

  String chars = "";
  if (letter) chars += '$letterUpperCase';
  if (isNumber) chars += '$number';


  return List.generate(length, (index) {
    final indexRandom = Random.secure().nextInt(chars.length);
    return chars [indexRandom];
  }).join('');
}