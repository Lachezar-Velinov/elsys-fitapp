import 'package:fitapp/screen/event_viewing_screen.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../model/event_data_source.dart';

class TasksWidget extends StatefulWidget {
  const TasksWidget({Key? key, required this.events}) : super(key: key);
  final EventDataSource events;

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  @override
  Widget build(BuildContext context) {
    //final provider = Provider.of<EventProvider>(context);
    final selectedEvents = widget.events.appointments!;

    if (selectedEvents.isEmpty) {
      return const Center(
        child: Text(
          'No events found',
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
      );
    }
    return SfCalendar(
      view: CalendarView.timelineDay,
      dataSource: widget.events,
      initialDisplayDate: widget.events.selectedDate,
      appointmentBuilder: appointmentBuilder,
      onTap: (details) {
        if (details.appointments == null) {
          return;
        }
        final event = details.appointments!.first;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EventViewingScreen(event: event),
          ),
        );
      },
    );
  }

  Widget appointmentBuilder(
      BuildContext context, CalendarAppointmentDetails details) {
    final event = details.appointments.first;
    return Container(
      width: details.bounds.width,
      height: details.bounds.height,
      decoration: BoxDecoration(
        color: event.backgroundColor.withOpacity(0.35),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          event.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
