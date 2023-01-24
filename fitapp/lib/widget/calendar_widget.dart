import 'package:fitapp/provider/event_provider.dart';
import 'package:fitapp/widget/tasks_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../model/event_data_source.dart';

class CalenderWidget extends StatelessWidget {
  const CalenderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;
    return SfCalendar(
      dataSource: EventDataSource(events),
      view: CalendarView.month,
      initialSelectedDate: DateTime.now(),
      cellBorderColor: Colors.grey,
      onLongPress: (details) {
        final provider = Provider.of<EventProvider>(context, listen: false); //listens:
        provider.setSelectedDate(details.date!);
        showModalBottomSheet(
          context: context,
          builder: (context) => const TasksWidget(),
        );
      },
    );
  }
}
