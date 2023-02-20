import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitapp/model/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '/model/event.dart';
import '../utils.dart';

class ReminderEditingScreen extends StatefulWidget {
  const ReminderEditingScreen({Key? key, this.reminder}) : super(key: key);
  final FitAppNotification? reminder;

  @override
  State<ReminderEditingScreen> createState() => _ReminderEditingScreenState();
}

class _ReminderEditingScreenState extends State<ReminderEditingScreen> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  List<RepeatInterval> repeatIntervalOptions = RepeatInterval.values;
  RepeatInterval repeatInterval = RepeatInterval.daily;

  @override
  void initState() {
    super.initState();

    if (widget.reminder == null) {
    } else {
      final reminder = widget.reminder;

      titleController.text = reminder!.title!;
      bodyController.text = reminder.body!;
      repeatInterval = reminder.repeatInterval;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
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
              //buildHeader(header: 'Header', child: Icon(icon)),
              buildTitle(),
              buildBody(),
              buildDropDownButton(),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Container(),
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

  Widget buildDropDownButton() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Text('Add Repeat time'),
          Expanded(
            child: DropdownButton(
                isExpanded: true,
                value: repeatInterval,
                items: repeatIntervalOptions
                    .map<DropdownMenuItem<RepeatInterval>>((value) {
                  return DropdownMenuItem<RepeatInterval>(
                    value: value,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        value.name,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    repeatInterval = value!;
                  });
                }),
          ),
        ],
      );

  List<Widget> buildEditingActions() => [
        if (!isCreating())
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

  Widget buildBody() => TextFormField(
        minLines: 3,
        maxLines: 3,
        style: const TextStyle(fontSize: 24),
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          hintText: 'Add body',
        ),
        validator: (title) =>
            (title != null && title.isEmpty) ? 'Body cannot be empty' : null,
        onFieldSubmitted: (_) => saveForm(),
        controller: bodyController,
      );

  Widget buildHeader({
    required String header,
    Widget? child,
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
          child ?? Container(),
        ],
      );

  bool isCreating() {
    return widget.reminder == null;
  }

  Future saveForm() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final fireStoreReference = FirebaseFirestore.instance;
      if (isCreating()) {
        fireStoreReference.collection("reminders").doc().set({
          'title': titleController.text,
          'body': bodyController.text,
          'repeatInterval': repeatInterval.name,
          'userID': FirebaseAuth.instance.currentUser!.uid,
        });
      } else {
        fireStoreReference.collection('reminders')
            .doc(widget.reminder!.key)
            .update({
          'title': titleController.text,
          'body': bodyController.text,
          'repeatInterval': repeatInterval.name,
        });
      }
      Navigator.of(context).pop();
    }
  }

  Future deleteForm() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final fireStoreReference = FirebaseFirestore.instance;
      fireStoreReference.collection('reminders').doc(widget.reminder!.key).delete();
      Navigator.of(context).pop();
    }
  }
}

