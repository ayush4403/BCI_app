

// ignore_for_file: unused_field, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {

  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, bool> dayStatus = {};

  final List<String> activities = [
    'Morning Meditation', //1
    'Night Music', //2
    'Mental Marathon', //4
    'Sherlock Holmes', //5
  ];

  final List<String> fetchedname = [
    'MeditationData',
    'NightMusicData',
    'mentalmarathon',
    'sherlockholmes'
  ];
  final List<String> fetchedday = [
    'MeditationDataforday',
    'NightDataforday',
    'mentalmarathondata',
    'sherlockdata'
  ];

  @override
  void initState() {
    super.initState();
    fetchWeekData("nodtaa").listen((data) {
      setState(() {
        dayStatus = data.map((key, value) {
          final date = DateTime(key.year, key.month, key.day);
          return MapEntry(date, value);
        });
      });
    });
  }

  Stream<Map<DateTime, bool>> fetchWeekData(String name) {
    final User? user = FirebaseAuth.instance.currentUser;
    String databasename = '';
    String databasepath = '';
    for (int i = 0; i < activities.length; i++) {
      if (name == activities[i]) {
        databasename = fetchedname[i];
        databasepath = fetchedday[i];
      }
    }
    if (user == null) {
      return Stream.value({});
    }
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection(databasepath)
        .doc('currentweekandday')
        .snapshots()
        .switchMap((snapshot) {
      if (!snapshot.exists) {
        return Stream.value({});
      }

      return FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection(databasename)
          .doc('data')
          .snapshots()
          .map((dataSnapshot) {
        final weekSnapshot = dataSnapshot.data();
        print("Your data: $weekSnapshot");
        final Map<DateTime, bool> dayStatus = {};
        if (weekSnapshot != null) {
          weekSnapshot.forEach((key, value) {
            if (key.startsWith('day')) {
              print("value ${value.runtimeType}");
              if (value is List<dynamic>) {
                final dayData = value as dynamic;
                final date = (dayData[2] as Timestamp).toDate();
                final status = dayData[1] as bool;
                final dateOnly = DateTime(date.year, date.month, date.day);
                dayStatus[dateOnly] = status;
              } else {
                final dayData = value as dynamic;
                final date = (dayData['TimeStamp'] as Timestamp).toDate();
                final status = dayData['done'] as bool;
                final dateOnly = DateTime(date.year, date.month, date.day);
                dayStatus[dateOnly] = status;
              }
            }
          });
        }
        return dayStatus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      body: TableCalendar(
        firstDay: DateTime(2024),
        lastDay: DateTime(3000),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        startingDayOfWeek: StartingDayOfWeek.monday,
        rowHeight: 60,
        daysOfWeekHeight: 60,
        headerStyle: HeaderStyle(
          titleTextStyle: const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          formatButtonTextStyle: const TextStyle(color: Colors.black),
          formatButtonDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue, width: 2),
              shape: BoxShape.rectangle),
          leftChevronIcon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 24,
          ),
          rightChevronIcon: const Icon(
            Icons.arrow_forward,
            color: Colors.black,
            size: 24,
          ),
        ),
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekendStyle: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
          weekdayStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        calendarStyle: CalendarStyle(
          isTodayHighlighted: false,
          weekendTextStyle: const TextStyle(color: Colors.red),
          todayDecoration: BoxDecoration(
            color: Colors.grey.withGreen(100),
            shape: BoxShape.rectangle,
          ),
          selectedDecoration: const BoxDecoration(
            color: Colors.teal,
            shape: BoxShape.circle,
          ),
        ),
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, date, _) {
            final dateOnly = DateTime(date.year, date.month, date.day);
            if (dayStatus.containsKey(dateOnly)) {
              bool status = dayStatus[dateOnly]!;
              return Container(
                margin: const EdgeInsets.all(6.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: status ? Colors.blue : null,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${date.day}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }
            return null;
          },
        ),
        // onDaySelected: (selectedDay, focusedDay) {
        //   if (!isSameDay(_selectedDay, selectedDay)) {
        //     setState(() {
        //       _selectedDay = selectedDay;
        //       _focusedDay = focusedDay;
        //     });
        //   }
        // },
        // selectedDayPredicate: (day) {
        //   return isSameDay(_selectedDay, day);
        // },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          setState(() {
            _focusedDay = focusedDay;
          });
        },
      ),
    );
  }
}
