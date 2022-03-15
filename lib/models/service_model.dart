import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceModel{
  String id,name,name_ar,description,description_ar,image,gender,categoryName,categoryId,tags;
  bool isActive,isFeatured,isRedeemable;
  int rating;
  List branchIds,packages;
  bool isAllBranchs,hasPackages;

  int totalRating,points,redeemPoints;
  String price,genderId;

  ServiceModel(this.id, this.name,this.name_ar,this.description,this.description_ar,
      this.isFeatured, this.image, this.gender, this.categoryName,
      this.categoryId, this.rating, this.price,this.totalRating,this.tags,this.isActive,
      this.points,this.genderId,this.isRedeemable,this.redeemPoints,this.branchIds,this.isAllBranchs,
      this.packages,this.hasPackages);

  ServiceModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        name_ar = map['name_ar'],
        packages = map['packages']??[],
        hasPackages = map['hasPackages']??false,
        description = map['description'],
        description_ar = map['description_ar'],
        isFeatured = map['isFeatured'],
        image = map['image'],
        gender = map['gender'],
        categoryName = map['categoryName'],
        categoryId = map['categoryId'],
        rating = map['rating'],
        price = map['price'],
        totalRating = map['totalRating'],
        tags = map['tags'],
        isActive = map['isActive'],
        points = map['points'],
        isRedeemable = map['isRedeemable'],
        redeemPoints = map['redeemPoints'],
        branchIds = map['branchIds'],
        isAllBranchs = map['isAllBranchs'],
        genderId = map['genderId'];



  ServiceModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}

class ServicePackageModel{
  String id,title,title_ar,status,serviceId;
  int price;


  ServicePackageModel(this.id, this.title, this.title_ar, this.status,
      this.serviceId, this.price);

  ServicePackageModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        title = map['title'],
        title_ar = map['title_ar'],
        price = map['price'],
        status = map['status'],
        serviceId = map['serviceId'];



  ServicePackageModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}