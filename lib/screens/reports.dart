import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spa_admin_app/models/appointment_model.dart';
import 'package:spa_admin_app/models/expense_model.dart';
import 'package:spa_admin_app/utils/constants.dart';
import 'package:spa_admin_app/widgets/appbar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
class Reports extends StatefulWidget {
  List<String> months;
  List<int> income;

  Reports(this.months, this.income);

  @override
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            CustomAppBar("Reports"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Revenue",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
            ),
            Container(
                child: SfCartesianChart(
                  // Initialize category axis
                    primaryXAxis: CategoryAxis(),

                    series: <LineSeries<SalesData, String>>[
                      LineSeries<SalesData, String>(
                        // Bind data source
                          dataSource:  <SalesData>[
                            SalesData(widget.months[4], widget.income[4].toDouble()),
                            SalesData(widget.months[3], widget.income[3].toDouble()),
                            SalesData(widget.months[2], widget.income[2].toDouble()),
                            SalesData(widget.months[1], widget.income[1].toDouble()),
                            SalesData(widget.months[0], widget.income[0].toDouble()),
                          ],
                          xValueMapper: (SalesData sales, _) => sales.year,
                          yValueMapper: (SalesData sales, _) => sales.sales
                      )
                    ]
                )
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Statistics",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
            ),
            Column(
              children: [
                Container(
                  margin:EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: lightBrown,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pending",
                            style: Theme.of(context).textTheme.subtitle1!.apply(color: Colors.white),
                          ),
                          SizedBox(height: 10),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('appointments')
                                .where("status",isEqualTo: "Pending")
                               .snapshots(),
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text('Error');
                              }
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Text(
                                  "-",
                                  style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.white),
                                );
                              }
                              return Text(
                                "${snapshot.data!.size}",
                                style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.white),
                              );
                            },
                          ),

                        ],
                      ),
                      CircleAvatar(
                        backgroundColor: darkBrown,
                        child: Icon(Icons.assignment_returned,color: Colors.white,),
                      )
                    ],
                  ),
                ),
                Container(
                  margin:EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: lightBrown,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Completed",
                            style: Theme.of(context).textTheme.subtitle1!.apply(color: Colors.white),
                          ),
                          SizedBox(height: 10),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('appointments')
                                .where("status",isEqualTo: "Completed")
                               .snapshots(),
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text('Error');
                              }
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Text(
                                  "-",
                                  style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.white),
                                );
                              }
                              return Text(
                                "${snapshot.data!.size}",
                                style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.white),
                              );
                            },
                          ),

                        ],
                      ),
                      CircleAvatar(
                        backgroundColor: darkBrown,
                        child: Icon(Icons.assignment_turned_in,color: Colors.white,),
                      )
                    ],
                  ),
                ),
                Container(
                  margin:EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: lightBrown,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Cancelled",
                            style: Theme.of(context).textTheme.subtitle1!.apply(color: Colors.white),
                          ),
                          SizedBox(height: 10),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('appointments')
                                .where("status",isEqualTo: "Cancelled")
                               .snapshots(),
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text('Error');
                              }
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Text(
                                  "-",
                                  style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.white),
                                );
                              }
                              return Text(
                                "${snapshot.data!.size}",
                                style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.white),
                              );
                            },
                          ),

                        ],
                      ),
                      CircleAvatar(
                        backgroundColor: darkBrown,
                        child: Icon(Icons.assignment_late_rounded,color: Colors.white,),
                      )
                    ],
                  ),
                ),
                Container(
                  margin:EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: lightBrown,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Revenue",
                            style: Theme.of(context).textTheme.subtitle1!.apply(color: Colors.white),
                          ),
                          SizedBox(height: 10),
                          Text(
                            revenue,
                            style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.white),
                          )
                        ],
                      ),
                      CircleAvatar(
                        backgroundColor: darkBrown,
                        child: Icon(Icons.monetization_on,color: Colors.white,),
                      )
                    ],
                  ),
                ),
                Container(
                  margin:EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: lightBrown,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Expenses",
                            style: Theme.of(context).textTheme.subtitle1!.apply(color: Colors.white),
                          ),
                          SizedBox(height: 10),
                          Text(
                            expenses,
                            style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.white),
                          )
                        ],
                      ),
                      CircleAvatar(
                        backgroundColor: darkBrown,
                        child: Icon(Icons.list_alt,color: Colors.white,),
                      )
                    ],
                  ),
                ),
                Container(
                  margin:EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: lightBrown,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Points Booking",
                            style: Theme.of(context).textTheme.subtitle1!.apply(color: Colors.white),
                          ),
                          SizedBox(height: 10),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('appointments')
                                .where("paymentMethod",isEqualTo: "Points Redemption").snapshots(),
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text('Error');
                              }
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Text(
                                  "-",
                                  style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.white),
                                );
                              }
                              return Text(
                                "${snapshot.data!.size}",
                                style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.white),
                              );
                            },
                          ),

                        ],
                      ),
                      CircleAvatar(
                        backgroundColor: darkBrown,
                        child: Icon(Icons.wallet_giftcard_rounded,color: Colors.white,),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String revenue="-";
  String expenses="-";
  @override
  void initState() {
    super.initState();
    int tempCount=0;
    int tempExpenseCount=0;
    FirebaseFirestore.instance.collection('appointments')
        .where("status",isEqualTo: "Completed").get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        AppointmentModel model=AppointmentModel.fromMap(data, doc.reference.id);
        tempCount+=int.parse(model.amount);
      });
      setState(() {
        revenue=tempCount.toString();
      });
    });
    FirebaseFirestore.instance.collection('expenses')
        .get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        ExpenseModel model=ExpenseModel.fromMap(data, doc.reference.id);
        tempExpenseCount+=int.parse(model.amount);
      });
      setState(() {
        expenses=tempExpenseCount.toString();
      });
    });
    for(int i =0;i<5;i++){
      print("data ${widget.months[i]} ${widget.income[i]}");
    }

  }
}
class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
