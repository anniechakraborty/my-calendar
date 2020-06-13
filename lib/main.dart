import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Calendar',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CalendarController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = CalendarController();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.teal.shade900,
        title:Text(
          ' My Calendar'
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TableCalendar(
              initialCalendarFormat: CalendarFormat.month,
              calendarStyle: CalendarStyle(
                todayColor: Colors.teal,
                selectedColor: Colors.deepPurpleAccent,
                selectedStyle: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
                todayStyle: TextStyle(fontWeight: FontWeight.bold),
                weekendStyle: TextStyle(
                  color: Colors.deepPurpleAccent,
                  fontStyle: FontStyle.italic,
                  fontSize: 14.0,
                )
              ),
              calendarController: _controller,
//              We can also change the headers of the calendar
              headerStyle: HeaderStyle(
                centerHeaderTitle: true,
                formatButtonDecoration: BoxDecoration(
                  color: Colors.teal.shade800,
                ),
                formatButtonPadding: EdgeInsets.all(12.0),
                formatButtonShowsNext: false,
              ),
              startingDayOfWeek: StartingDayOfWeek.monday,
//              Deciding actions to occur when a date os selected
              onDaySelected: (date, events){
                print(date.toIso8601String());
              },
//              We can provide more customisations using builders
              builders: CalendarBuilders(
                selectedDayBuilder: (context, date, event) => Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
//                    color: Theme.of(context).primaryColor,
                    color: Colors.deepPurpleAccent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(
                      color : Colors.white,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                todayDayBuilder: (context, date, event) => Container(
                  alignment: Alignment.center,
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade800,
                    shape: BoxShape.circle,
                  ),
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}
