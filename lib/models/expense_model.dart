import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel{
  String id,type,typeId,amount,date,note;
  int datePosted,dateExpenseAdded;


  ExpenseModel(this.id, this.type, this.typeId, this.amount, this.date,
      this.note,this.datePosted,this.dateExpenseAdded);

  ExpenseModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        type = map['type'],
        typeId = map['typeId'],
        date = map['date'],
        note = map['note'],
        datePosted = map['datePosted']??DateTime.now().millisecondsSinceEpoch,
        dateExpenseAdded = map['dateExpenseAdded']??DateTime.now().millisecondsSinceEpoch,
        amount = map['amount'];



  ExpenseModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}