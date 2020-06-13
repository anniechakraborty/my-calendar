import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Calendar',
      color: Colors.teal.shade800,
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
  TextEditingController _eventController;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _eventController = TextEditingController();
    _events = {};
    _selectedEvents = [];
    initPrefs();
  }

  initPrefs() async{
//    loading events from shared preferences
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _events = Map<DateTime, List<dynamic>>.from(decodeMap(json.decode(prefs.getString("events") ?? {})));
    });
  }

//  Writing helper functions to encode and decode events

  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    return newMap;
  }

  Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[DateTime.parse(key)] = map[key];
    });
    return newMap;
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
              events: _events,
              initialCalendarFormat: CalendarFormat.month,
              calendarStyle: CalendarStyle(
                selectedStyle: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
                todayStyle: TextStyle(fontWeight: FontWeight.bold),
                weekendStyle: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 13.0,
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
                setState(() {
                  _selectedEvents = events;
                });
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
            ),
            ..._selectedEvents.map((event) => ListTile(
              title: Text(event),
            )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white,),
        onPressed: _showAddDialog,
        backgroundColor: Colors.deepPurpleAccent,
      ),
    );
  }
  _showAddDialog(){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: _eventController,
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Save',
            ),
            onPressed: (){
              if(_eventController.text.isEmpty)
                return;
              setState(() {
                if(_events[_controller.selectedDay] != null) {
                  _events[_controller.selectedDay].add(
                    _eventController.text
                  );
                }
                else{
                  _events[_controller.selectedDay] = [_eventController.text];
                }
                prefs.setString("events", json.encode(encodeMap(_events)));
                _eventController.clear();
                Navigator.pop(context);
              });
            },
          )
        ],
      ),
    );
  }
}
