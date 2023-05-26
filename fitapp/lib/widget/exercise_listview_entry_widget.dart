import 'package:fitapp/model/notification.dart';
import 'package:fitapp/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/exercise.dart';
import '../screen/exercise_viewing_screen.dart';
import '../screen/reminder_editing_screen.dart';

class ExerciseLVEntry extends StatelessWidget {
  const ExerciseLVEntry(
      {Key? key, required this.exercise, required this.context})
      : super(key: key);
  final Exercise exercise;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ExerciseViewingScreen(exercise: exercise, context: context),
        ),
      ),
      child: Container(
        margin: EdgeInsets.all(3),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 1,
              style: BorderStyle.solid,
            )),
        height: 50,
        child: Center(
          child: Text(Utils.toDateTime(exercise.beginAt)),
        ),
      ),
    );
  }
}
