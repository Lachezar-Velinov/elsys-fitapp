import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/model/event.dart';
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
      endAt = DateTime.now().add(
        const Duration(hours: 1),
      );
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
        padding: const EdgeInsets.all(8),
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
          onPressed: deleteForm,
          icon: const Icon(Icons.delete, color: Colors.white),
          label: const Text(
            'DELETE',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            side: const BorderSide(width: 0.5, color: Colors.white),
            backgroundColor: Colors.red,
            shadowColor: Colors.transparent,
          ),
        ),
        ElevatedButton.icon(
          onPressed: saveForm,
          icon: const Icon(Icons.done),
          label: const Text('SAVE'),
          style: ElevatedButton.styleFrom(
            shadowColor: Colors.transparent,
          ),
        ),
      ];

  Widget buildTitle() => TextFormField(
        style: const TextStyle(fontSize: 24),
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          hintText: 'Add title',
        ),
        validator: (title) =>
            (title != null && title.isEmpty) ? 'Tittle cannot be empty' : null,
        onFieldSubmitted: (_) => saveForm(),
        controller: titleController,
      );

  Widget buildDateTimePicker() => Column(
        children: [
          buildBeginAt(),
          buildEndAt(),
        ],
      );

  Widget buildBeginAt() => buildHeader(
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

  Widget buildEndAt() => buildHeader(
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
        trailing: const Icon(
          Icons.arrow_drop_down_circle_outlined,
        ),
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
            style: const TextStyle(
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
      ).add(const Duration(hours: 1));
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

    if (isValid) {
      final isCreating = widget.event == null;
      final fireStoreReference = FirebaseFirestore.instance;
      if (isCreating) {
        fireStoreReference.collection("events").doc().set({
          'title': titleController.text,
          'beginAt': Timestamp.fromDate(beginAt),
          'endAt': Timestamp.fromDate(endAt),
          'userID': FirebaseAuth.instance.currentUser!.uid,
        });
      } else {
        fireStoreReference.collection('events').doc(widget.event!.key).update({
          'title': titleController.text,
          'beginAt': Timestamp.fromDate(beginAt),
          'endAt': Timestamp.fromDate(endAt),
        });
      }
      Navigator.of(context).pop();
    }
  }

  Future deleteForm() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final fireStoreReference = FirebaseFirestore.instance;
      fireStoreReference.collection('events').doc(widget.event!.key).delete();
      Navigator.of(context).pop();
    }
  }
}
