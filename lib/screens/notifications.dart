import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spa_admin_app/models/notification_model.dart';
import 'package:spa_admin_app/screens/add_notification.dart';
import 'package:spa_admin_app/utils/constants.dart';
import 'package:spa_admin_app/widgets/appbar.dart';
import 'package:easy_localization/easy_localization.dart';
class NotificationList extends StatefulWidget {
  const NotificationList({Key? key}) : super(key: key);

  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(context, new MaterialPageRoute(
              builder: (context) => AddNotification()));
        },
        backgroundColor: darkBrown,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            CustomAppBar("Notifications"),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('notifications').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                        child: Text("Something Went Wrong")

                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data!.size==0){
                    return Center(
                        child: Text('noNotifications'.tr())

                    );

                  }
                  return new ListView(
                    shrinkWrap: true,
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      NotificationModel model=NotificationModel.fromMap(data, document.reference.id);
                      return new Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: InkWell(
                            child: Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: lightBrown,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.all(10),

                                    decoration: BoxDecoration(
                                        color: darkBrown,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10)
                                        )
                                    ),
                                    child: Text(model.type,style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),),
                                  ),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.all(10),
                                              height: 30,width: 30,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(100),
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(model.image)
                                                  )
                                              ),

                                            ),
                                            Expanded(
                                              child: Text(model.title,style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white),maxLines: 1,),
                                            )
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(10),
                                          child: Text(model.detail,style: TextStyle(color: Colors.white),),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
