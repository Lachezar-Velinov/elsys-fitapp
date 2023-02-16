import 'package:fitapp/provider/notification_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReminderWidget extends StatefulWidget {
  const ReminderWidget({Key? key}) : super(key: key);

  @override
  State<ReminderWidget> createState() => _ReminderWidgetState();
}

class _ReminderWidgetState extends State<ReminderWidget> {
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.initialiseNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: sendNotification,
        child: const Text('Test'),
      ),
    );
  }

  void sendNotification() {
    notificationServices.sendNotification(1, 'Test', 'Body');
  }
}
