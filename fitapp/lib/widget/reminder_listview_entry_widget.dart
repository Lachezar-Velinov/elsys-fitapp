import 'package:fitapp/model/notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screen/reminder_editing_screen.dart';

class ReminderLVEntry extends StatelessWidget {
  const ReminderLVEntry(
      {Key? key, required this.notification, required this.context})
      : super(key: key);
  final FitAppNotification notification;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ReminderEditingScreen(reminder: notification),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
          color: Colors.black,
          width: 1,
          style: BorderStyle.solid,
        )),
        height: 50,
        child: Center(
          child: Text('Entry ${notification.title}'),
        ),
      ),
    );
  }
}
