import 'package:cloud_firestore/cloud_firestore.dart';

class SurveyModel{
  String id,question,attempts;
  List choices;

  SurveyModel(this.id, this.question,this.choices,this.attempts);

  SurveyModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        question = map['question'],
        choices = map['choices'],
        attempts = map['attempts'];



  SurveyModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}
class SurveyAttemptModel{
  String id,userId,username,choice,questionID,question;

  SurveyAttemptModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        question = map['question'],
        userId = map['userId'],
        choice = map['choice'],
        questionID = map['questionID'],
        username = map['username'];



  SurveyAttemptModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}
