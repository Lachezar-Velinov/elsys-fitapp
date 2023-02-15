import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/model/event.dart';
import '../provider/event_provider.dart';
import '../utils.dart';

class EventEditingScreen extends StatefulWidget {
  const EventEditingScreen({Key? key, this.event}) : super(key: key);
  final Event? event;

  @override
  State<EventEditingScreen> createState() => _EventEditingScreenState();
}

class _EventEditingScreenState extends State<EventEditingScreen> {
  final _formKey = GlobalKey<FormState>();
  late DateTime beginAt;
  late DateTime endAt;

  final titleController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.event == null) {
      beginAt = DateTime.now();
      endAt = DateTime.now().add(const Duration(hours: 1));
    } else {
      final event = widget.event;
      beginAt = event!.beginAt;
      endAt = event.endAt;
      titleController.text = event.title;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTitle(),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: buildDateTimePicker(),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        leading: const CloseButton(),
        actions: buildEditingActions(),
      ),
    );
  }

  List<Widget> buildEditingActions() => [
        ElevatedButton.icon(
            onPressed: saveForm,
            icon: Icon(Icons.done),
            label: Text('SAVE'),
            style: ElevatedButton.styleFrom(shadowColor: Colors.transparent)),
      ];

  Widget buildTitle() => TextFormField(
        style: TextStyle(fontSize: 24),
        decoration: InputDecoration(
            border: UnderlineInputBorder(), hintText: 'Add title'),
        validator: (title) =>
            title != null && title.isEmpty ? 'Tittle cannot be empty' : null,
        onFieldSubmitted: (_) => saveForm(),
        controller: titleController,
      );

  Widget buildDateTimePicker() => Column(
        children: [
          buildFrom(),
          buildTo(),
        ],
      );

  Widget buildFrom() => buildHeader(
        header: 'FROM',
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: buildDropDownField(
                onClicked: () => pickFromDateTime(pickDate: true),
                text: Utils.toDate(beginAt),
              ),
            ),
            Expanded(
              flex: 3,
              child: buildDropDownField(
                onClicked: () => pickFromDateTime(pickDate: false),
                text: Utils.toTime(beginAt),
              ),
            ),
          ],
        ),
      );

  Widget buildTo() => buildHeader(
        header: 'TO',
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: buildDropDownField(
                onClicked: () => pickToDateTime(pickDate: true),
                text: Utils.toDate(endAt),
              ),
            ),
            Expanded(
              flex: 3,
              child: buildDropDownField(
                onClicked: () => pickToDateTime(pickDate: false),
                text: Utils.toTime(endAt),
              ),
            ),
          ],
        ),
      );

  Widget buildDropDownField({
    required String text,
    required VoidCallback onClicked,
  }) =>
      ListTile(
        title: Text(text),
        trailing: Icon(Icons.arrow_drop_down_circle_outlined),
        onTap: onClicked,
      );

  Widget buildHeader({
    required String header,
    required Widget child,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          child,
        ],
      );

  Future pickFromDateTime({
    required bool pickDate,
  }) async {
    final date = await pickDateTIme(beginAt, pickDate: pickDate);
    if (date == null) {
      return;
    }
    if (date.isAfter(beginAt)) {
      endAt = DateTime(
        date.year,
        date.month,
        date.day,
        date.hour,
        date.minute,
      ).add(Duration(hours: 1));
    }
    setState(() {
      beginAt = date;
    });
  }

  Future pickToDateTime({
    required bool pickDate,
  }) async {
    final date = await pickDateTIme(
      endAt,
      pickDate: pickDate,
      firstDate: pickDate ? beginAt : null,
    );
    if (date == null) {
      return;
    }
    setState(() {
      endAt = date;
    });
  }

  Future<DateTime?> pickDateTIme(
    DateTime beginAt, {
    required bool pickDate,
    DateTime? firstDate,
  }) async {
    if (pickDate) {
      final date = await showDatePicker(
        context: context,
        initialDate: beginAt,
        firstDate: firstDate ?? DateTime(2012, 2),
        lastDate: DateTime(2122, 2),
      );
      if (date == null) {
        return null;
      }
      final time = Duration(
        hours: beginAt.hour,
        minutes: beginAt.minute,
      );

      return date.add(time);
    } else {
      final dayTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (dayTime == null) {
        return null;
      }
      final date = DateTime(beginAt.year, beginAt.month, beginAt.day);
      final time = Duration(hours: dayTime.hour, minutes: dayTime.minute);
      return date.add(time);
    }
  }

  Future saveForm() async {
    final isValid = _formKey.currentState!.validate();

    // checkpoint
    if (isValid) {
      final event = Event(
        title: titleController.text,
        description: 'Description',
        isAllDay: false,
        isRepeating: false,
        beginAt: beginAt,
        endAt: endAt,
      );
      final isCreating = widget.event == null;
      // final provider = Provider.of<EventProvider>(context, listen: false);
      final fireStoreReference = FirebaseFirestore.instance;
      if (isCreating) {
        // provider.addEvent(event);
        fireStoreReference
            .collection("events")
            .doc().set({
          'title': titleController.text,
          'beginAt': Timestamp.fromDate(beginAt),
          'endAt': Timestamp.fromDate(endAt),
        });
      } else {
        // provider.editEvent(event, widget.event!);
      }
      Navigator.of(context).pop();
      print("Event added");
    }
  }
}