import 'package:fitapp/screen/event_editing_screen.dart';
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
        leading: CloseButton(),
        actions: buildViewingActions(context, event),
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
        icon: Icon(Icons.edit),
      )
    ];
  }
}
