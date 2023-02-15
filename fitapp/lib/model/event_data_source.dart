import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'event.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> events) {
    appointments = events;
  }

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;
  void setSelectedDate(DateTime date) => _selectedDate = date;

  Event getEvent(int index) => appointments![index] as Event;

  @override
  DateTime getStartTime(int index) {
    return getEvent(index).beginAt;
  }

  @override
  DateTime getEndTime(int index) {
    return getEvent(index).endAt;
  }

  @override
  bool isAllDay(int index) {
    return getEvent(index).isAllDay;
  }

  @override
  Color getColor(int index) {
    return getEvent(index).backgroundColor;
  }

  @override
  String getSubject(int index) {
    return getEvent(index).title;
  }
}
