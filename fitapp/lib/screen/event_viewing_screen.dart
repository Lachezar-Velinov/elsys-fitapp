import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitapp/screen/event_editing_screen.dart';
import 'package:fitapp/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/event.dart';

class EventViewingScreen extends StatelessWidget {
  final Event event;

  const EventViewingScreen({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        actions: buildViewingActions(context, event),
      ),
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1, style: BorderStyle.solid)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            buildContainer('Event name:\n${event.title}'),
            const Divider(color: Colors.black, thickness: 1),
            buildContainer('Event begins at:\n${Utils.toDateTime(event.beginAt)}'),
            const Divider(color: Colors.black, thickness: 1),
            buildContainer('Event ends at:\n${Utils.toDateTime(event.endAt)}'),
            const Divider(color: Colors.black, thickness: 1),
            buildContainer('Event description:\n${event.description}'),
            // Text(Utils.toDate(event.beginAt))
          ],
        ),
      ),
    );
  }

  Container buildContainer(String text) {
    return Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              '$text\n',
              style: const TextStyle(
                overflow: TextOverflow.fade,
                fontWeight: FontWeight.w500,
                fontSize: 28,
              ),
            ),
          );
  }

  List<Widget> buildViewingActions(BuildContext context, Event event) {
    return [
      IconButton(
        onPressed: () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => EventEditingScreen(
              event: event,
            ),
          ),
        ),
        icon: const Icon(Icons.edit),
      )
    ];
  }
}
