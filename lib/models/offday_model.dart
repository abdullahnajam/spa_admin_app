import 'package:cloud_firestore/cloud_firestore.dart';

class OffDayModel{
  String id,date;int dateInMilliSeconds;

  OffDayModel(this.id, this.date, this.dateInMilliSeconds);

  OffDayModel.fromMap(Map<String,dynamic> map,String key)
      : id= key,
        date = map['date'],
        dateInMilliSeconds = map['dateInMilliSeconds'];




  OffDayModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}