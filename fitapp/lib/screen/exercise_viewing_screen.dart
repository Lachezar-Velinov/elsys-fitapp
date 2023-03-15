import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitapp/model/exercise.dart';
import 'package:flutter/material.dart';

class ExerciseViewingScreen extends StatelessWidget {
  const ExerciseViewingScreen(
      {Key? key, required this.exercise, required this.context})
      : super(key: key);

  final Exercise exercise;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        actions: buildViewingActions(context, exercise),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          buildInfo('Glucose', exercise.glucose.toString()),
          buildInfo('Body Temperature', exercise.bodyTemp.toString()),
          buildInfo('Diastolic', exercise.bpDiastolic.toString()),
          buildInfo('Systolic', exercise.bpSystolic.toString()),
          buildRow('Duration:', exercise.duration),
        ],
      ),
    );
  }
  Widget buildInfo(String name, String value) {
    if (value.length > 6) {
      value = value.substring(0, 5);
    }
    return buildRow(name, value);
  }

  Widget buildRow(String name, String value) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
      ),
      child: Center(
        child: Expanded(
          child: Text(
            '$name: $value',
            style: const TextStyle(
              overflow: TextOverflow.fade,
              fontWeight: FontWeight.w600,
              fontSize: 26,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildViewingActions(BuildContext context, Exercise exercise) {
    return [
      IconButton(
        onPressed: () {
          final fireStoreReference = FirebaseFirestore.instance;
          fireStoreReference.collection('workouts').doc(exercise.key).delete();
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.delete),
      )
    ];
  }
}
