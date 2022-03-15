import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spa_admin_app/models/calendar.dart';
import 'package:spa_admin_app/widgets/appbar.dart';
import 'package:spa_admin_app/widgets/appbar_title.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarDisplay extends StatefulWidget {
  List<Meeting> calendarMeetings;

  CalendarDisplay(this.calendarMeetings);

  @override
  _CalendarDisplayState createState() => _CalendarDisplayState();
}

class _CalendarDisplayState extends State<CalendarDisplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar("Calendar"),
            Expanded(
              child: SfCalendar(
                view: CalendarView.month,
                showNavigationArrow: true,
                onTap: (CalendarTapDetails details) {
                  final f = new DateFormat('dd-MM-yyyy');
                  String date = f.format(details.date!).toString();
                },
                dataSource: MeetingDataSource(widget.calendarMeetings),
                monthViewSettings: MonthViewSettings(
                    appointmentDisplayMode:
                    MonthAppointmentDisplayMode.appointment),
              ),
            )
          ],
        ),
      ),
    );
  }
}
