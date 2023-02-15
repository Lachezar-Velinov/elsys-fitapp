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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(
              'Event name: ${event.title}',
              style: const TextStyle(
                overflow: TextOverflow.fade,
                fontWeight: FontWeight.w600,
                fontSize: 32,
              ),
            ),
          ),
          Text(
            'Username:${FirebaseAuth.instance.currentUser!.displayName ?? 'No name'}',
          ),
          Text(
            'Event description:\n${event.description}',
          ),
          Text(Utils.toDate(event.beginAt))
        ],
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
