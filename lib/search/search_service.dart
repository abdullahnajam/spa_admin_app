import 'package:flutter/material.dart';
import 'package:spa_admin_app/models/service_model.dart';
import 'package:easy_localization/easy_localization.dart';
class ServiceSearch extends SearchDelegate<String> {
  final List<ServiceModel> service;
  String? result;
  ServiceSearch(this.service);

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
      if(context.locale.languageCode=="en"){
        return service.name.contains(query);
      }
      else
        return service.name_ar.contains(query);
    });

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: (){

            if(context.locale.languageCode=="en")
              print("");
             // Navigator.push(context, new MaterialPageRoute(builder: (context) => ServiceDetail(suggestions.elementAt(index),'English')));
            else
              print("");
              //Navigator.push(context, new MaterialPageRoute(builder: (context) => ServiceDetail(suggestions.elementAt(index),'Arabic')));
          },
          child: Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: ClipRRect(
                child: Image.network(suggestions.elementAt(index).image),
              ),
              title: Text(context.locale.languageCode=="en"?suggestions.elementAt(index).name:suggestions.elementAt(index).name_ar,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
              //subtitle: Text(suggestions.elementAt(index).categoryName,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = service.where((service) {
      if(context.locale.languageCode=="en"){
        return service.name.contains(query);
      }
      else
        return service.name_ar.contains(query);
    });

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: (){
            if(context.locale.languageCode=="en")
              print("");
              //Navigator.push(context, new MaterialPageRoute(builder: (context) => ServiceDetail(suggestions.elementAt(index),'English')));
            else
            print("");
             // Navigator.push(context, new MaterialPageRoute(builder: (context) => ServiceDetail(suggestions.elementAt(index),'Arabic')));
          },
          child: Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: ClipRRect(
                child: Image.network(suggestions.elementAt(index).image),
              ),
              title: Text(context.locale.languageCode=="en"?suggestions.elementAt(index).name:suggestions.elementAt(index).name_ar,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
              //subtitle: Text(suggestions.elementAt(index).categoryName,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

            ),
          ),
        );
      },
    );
  }
}