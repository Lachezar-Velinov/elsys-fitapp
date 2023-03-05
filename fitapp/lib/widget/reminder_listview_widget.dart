import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitapp/model/notification.dart';
import 'package:fitapp/provider/notification_service.dart';
import 'package:fitapp/widget/reminder_listview_entry_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ReminderListViewWidget extends StatefulWidget {
  const ReminderListViewWidget({Key? key}) : super(key: key);

  @override
  State<ReminderListViewWidget> createState() => _ReminderListViewWidgetState();
}

class _ReminderListViewWidgetState extends State<ReminderListViewWidget> {
  NotificationServices notificationServices = NotificationServices();
  final fireStoreReference = FirebaseFirestore.instance;

  List<FitAppNotification> reminderList = [];

  @override
  void initState() {
    getDataFromFireStore().then((results) {
      SchedulerBinding.instance.addPostFrameCallback((
        timeStamp,
      ) {
        setState(() {});
      });
    });
    setNotifications();
    super.initState();
  }

  void setNotifications() async {
    notificationServices.initialiseNotification();

    notificationServices.schedulePeNotifications(reminderList);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildScheduleRow(),
          const Divider(
            color: Colors.black,
          ),
          buildListView(),
        ],
      ),
    );
  }

  Widget buildScheduleRow() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('Schedule notifications'),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.orange,
            shadowColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            side: const BorderSide(width: 0.5, color: Colors.black38),
          ),
          child: const Text('Schedule'),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget buildListView() {
    return Expanded(
      child: ListView.builder(
          itemCount: reminderList.length,
          itemBuilder: (BuildContext context, int index) {
            return ReminderLVEntry(
              notification: reminderList[reminderList.length - (index + 1)],
              context: context,
            );
          }),
    );
  }

  Future<void> getDataFromFireStore() async {
    var snapShotsValue = await fireStoreReference
        .collection("reminders")
        .where(
          'userID',
          isEqualTo: FirebaseAuth.instance.currentUser!.uid,
        )
        .get();

    List<FitAppNotification> list = snapShotsValue.docs
        .map(
          (e) => FitAppNotification.fromFireBaseSnapShotData(e),
        )
        .toList();
    setState(() {
      reminderList = list;
    });
  }

  void sendNotification() {
    notificationServices.sendNotification(1, 'Test', 'Body');
  }

// void scheduleNotification() {
//   notificationServices.schedulePeNotification(notification)
// }
}
