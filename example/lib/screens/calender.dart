import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:math';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final Map<DateTime, Color> _highlightedDates = {};

  @override
  void initState() {
    super.initState();
    _generateHighlightedDates();
  }

  void _generateHighlightedDates() {
    final random = Random();
    final colors = [Colors.red, Colors.blue, Colors.green, Colors.yellow];
    for (int i = 1; i <= 11; i++) {
      final date = DateTime(2024, 6, i);
      _highlightedDates[date] = colors[random.nextInt(colors.length)];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          titleTextStyle: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          formatButtonTextStyle: TextStyle(color: Colors.black),
          formatButtonDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue, width: 2),
              shape: BoxShape.rectangle),
          leftChevronIcon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 24,
          ),
          rightChevronIcon: Icon(
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
            if (_highlightedDates.containsKey(dateOnly)) {
              return Container(
                margin: const EdgeInsets.all(6.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _highlightedDates[dateOnly],
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${date.day}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }
            return Container(
              margin: const EdgeInsets.all(6.0),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${date.day}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          },
        ),
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
