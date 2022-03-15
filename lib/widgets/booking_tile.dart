import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:spa_admin_app/models/appointment_model.dart';
import 'package:spa_admin_app/screens/booking_detail.dart';
import 'package:spa_admin_app/utils/constants.dart';

class BookingTile extends StatefulWidget {
  AppointmentModel _appointmentModel;


  BookingTile(this._appointmentModel);

  @override
  _BookingTileState createState() => _BookingTileState();
}

class _BookingTileState extends State<BookingTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => BookingDetail(widget._appointmentModel)));

      },
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            //border: Border.all(color:Colors.black54),
          ),

          margin: EdgeInsets.all(5),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //SizedBox(height: size.height*0.01,),
                        Text(widget._appointmentModel.serviceName,style: TextStyle(
                          color: Colors.black87,
                          //fontFamily: 'Georgia Regular',
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),),
                        Row(
                          children: [
                            Text("\$${widget._appointmentModel.amount}",style: TextStyle(
                              color: Colors.black87,
                              //fontFamily: 'Georgia Regular',
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                            ),),
                            SizedBox(width: 10,),
                            Text(widget._appointmentModel.paymentMethod,style: TextStyle(
                              color: Colors.black87,
                              //fontFamily: 'Georgia Regular',
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                            ),),
                          ],
                        ),
                        //SizedBox(height: size.height*0.0055,),
                        Text("Booked By ${widget._appointmentModel.name}",style: TextStyle(
                          color: Colors.black87,
                          //fontFamily: 'Georgia Regular',
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),),
                        Text("${widget._appointmentModel.date}   ${widget._appointmentModel.time}",style: TextStyle(
                          color: Colors.black87,
                          //fontFamily: 'Georgia Regular',
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),),
                        //SizedBox(height: size.height*0.0055,),
                      ],
                    ),
                  ),


                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0,8, 0, 0),

                          //width: MediaQuery.of(context).size.width*0.2,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: darkBrown
                            ),
                            alignment: Alignment.center,
                            child: Text(widget._appointmentModel.status,textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
                          ),
                        ),
                        //SizedBox(height: size.height*0.005,),
                        widget._appointmentModel.status == 'Completed'?
                        widget._appointmentModel.isRated ? RatingBar(
                          initialRating: widget._appointmentModel.rating.toDouble(),
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          ratingWidget: RatingWidget(
                            full: Icon(Icons.star,color: darkBrown),
                            half: Icon(Icons.star_half,color: darkBrown),
                            empty:Icon(Icons.star_border,color: darkBrown),
                          ),
                          ignoreGestures: true,
                          itemSize: 14,
                          itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ) : Container(child: Text("NOT RATED",style: TextStyle(fontSize: 10,color: Colors.grey),) , )
                            :Container(),

                      ],
                    ),
                  )


                ],
              ),
            ],
          )

      ),
    );
  }
}
