import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitapp/model/notification.dart';
import 'package:fitapp/provider/notification_service.dart';
import 'package:fitapp/widget/reminder_listview_entry_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ReminderListViewWidget extends StatefulWidget {
  const ReminderListViewWidget({Key? key}) : super(key: key);

  @override
  State<ReminderListViewWidget> createState() => _ReminderListViewWidgetState();
}

class _ReminderListViewWidgetState extends State<ReminderListViewWidget> {
  NotificationServices notificationServices = NotificationServices();
  final fireStoreReference = FirebaseFirestore.instance;

  List<FitAppNotification> proba2 = [];

  @override
  void initState() {
    getDataFromFireStore().then((results) {
      SchedulerBinding.instance.addPostFrameCallback((
          timeStamp,
          ) {
        setState(() {});
      });
    });
    super.initState();
    notificationServices.initialiseNotification();

  }


  @override
  Widget build(BuildContext context) {
    List<FitAppNotification> proba = [
      FitAppNotification(
          userId: 'Proba',
          id: 1,
          title: 'Oho',
          body: 'Oha,',
          repeatInterval: RepeatInterval.daily,
          key: ''),
      FitAppNotification(
          userId: 'Probi',
          id: 1,
          title: 'Oho',
          body: 'Oha,',
          repeatInterval: RepeatInterval.daily,
          key: ''),
    ];


    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: proba2.length,
        itemBuilder: (BuildContext context, int index) {
          return ReminderLVEntry(
            notification: proba2[index],
            context: context,
          );
        });
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
      proba2 = list;
    });
  }

  void sendNotification() {
    notificationServices.sendNotification(1, 'Test', 'Body');
  }

  // void scheduleNotification() {
  //   notificationServices.schedulePeNotification(notification)
  // }
}
