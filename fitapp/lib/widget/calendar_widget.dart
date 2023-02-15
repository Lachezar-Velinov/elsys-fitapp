import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitapp/model/event.dart';
import 'package:fitapp/provider/event_provider.dart';
import 'package:fitapp/widget/tasks_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
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
    fireStoreReference
        .collection("CalendarAppointmentCollection")
        .snapshots()
        .listen((event) {
      event.docChanges.forEach((element) {
        if (element.type == DocumentChangeType.added) {
          if (!isInitialLoaded) {
            return;
          }

          Event app = Event.fromFireBaseSnapShotData(element, Colors.orange);
          setState(() {
            events!.appointments!.add(app);
            events!.notifyListeners(CalendarDataSourceAction.add, [app]);
          });
        } else if (element.type == DocumentChangeType.modified) {
          if (!isInitialLoaded) {
            return;
          }

          Event app = Event.fromFireBaseSnapShotData(element, Colors.orange);
          setState(() {
            int index = events!.appointments!
                .indexWhere((app) => app.key == element.doc.id);

            Event meeting = events!.appointments![index];

            events!.appointments!.remove(meeting);
            events!.notifyListeners(CalendarDataSourceAction.remove, [meeting]);
            events!.appointments!.add(app);
            events!.notifyListeners(CalendarDataSourceAction.add, [app]);
          });
        } else if (element.type == DocumentChangeType.removed) {
          if (!isInitialLoaded) {
            return;
          }

          setState(() {
            int index = events!.appointments!
                .indexWhere((app) => app.key == element.doc.id);

            Event event = events!.appointments![index];
            events!.appointments!.remove(event);
            events!.notifyListeners(CalendarDataSourceAction.remove, [event]);
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isInitialLoaded = true;
    //final events = Provider.of<EventProvider>(context).events;
    return SfCalendar(
      dataSource: events,
      view: CalendarView.month,
      initialSelectedDate: DateTime.now(),
      cellBorderColor: Colors.grey,
      onLongPress: (details) {
/*        final provider = Provider.of<EventProvider>(
          context,
          listen: false,
        );*/
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
