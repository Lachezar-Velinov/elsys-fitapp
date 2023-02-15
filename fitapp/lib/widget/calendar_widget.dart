import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitapp/model/event.dart';
import 'package:fitapp/widget/tasks_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../model/event_data_source.dart';

class CalenderWidget extends StatefulWidget {
  const CalenderWidget({Key? key}) : super(key: key);

  @override
  State<CalenderWidget> createState() => _CalenderWidgetState();
}

class _CalenderWidgetState extends State<CalenderWidget> {
  final fireStoreReference = FirebaseFirestore.instance;
  EventDataSource? events;
  bool isInitialLoaded = false;

  @override
  void initState() {
    getDataFromFireStore().then((results) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isInitialLoaded = true;
    return SfCalendar(
      dataSource: events,
      view: CalendarView.month,
      initialSelectedDate: DateTime.now(),
      cellBorderColor: Colors.grey,
      onLongPress: (details) {
        events!.setSelectedDate(details.date!);
        showModalBottomSheet(
          context: context,
          builder: (context) => TasksWidget(events: events!),
        );
      },
    );
  }

  Future<void> getDataFromFireStore() async {
    var snapShotsValue = await fireStoreReference.collection("events").get();

    List<Event> list = snapShotsValue.docs
        .map(
          (e) => Event.nullValuesConstructor(e),
        )
        .toList();
    setState(() {
      events = EventDataSource(list);
    });
  }
}
