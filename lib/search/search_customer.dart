import 'package:flutter/material.dart';
import 'package:spa_admin_app/models/service_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:spa_admin_app/models/user_model.dart';
class CustomerSearch extends SearchDelegate<String> {
  final List<UserModel> service;
  String? result;
  CustomerSearch(this.service);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final suggestions = service.where((service) {
      return "${service.firstName} ${service.lastName}".contains(query);
    });

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: (){
            
              //Navigator.push(context, new MaterialPageRoute(builder: (context) => ServiceDetail(suggestions.elementAt(index),'Arabic')));
          },
          child: Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: ClipRRect(
                child: Image.network(suggestions.elementAt(index).profilePicture),
              ),
              title: Text("${suggestions.elementAt(index).firstName} ${suggestions.elementAt(index).lastName}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
              subtitle: Text(suggestions.elementAt(index).email,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = service.where((service) {
      return "${service.firstName} ${service.lastName}".contains(query);
    });

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: (){
           
             // Navigator.push(context, new MaterialPageRoute(builder: (context) => ServiceDetail(suggestions.elementAt(index),'Arabic')));
          },
          child: Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: ClipRRect(
                child: Image.network(suggestions.elementAt(index).profilePicture),
              ),
              title: Text("${suggestions.elementAt(index).firstName} ${suggestions.elementAt(index).lastName}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
              subtitle: Text(suggestions.elementAt(index).email,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

            ),
          ),
        );
      },
    );
  }
}