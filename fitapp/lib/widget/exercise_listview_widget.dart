import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitapp/model/exercise.dart';
import 'package:fitapp/widget/exercise_listview_entry_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';

class ExerciseListView extends StatefulWidget {
  const ExerciseListView({Key? key}) : super(key: key);

  @override
  State<ExerciseListView> createState() => _ExerciseListViewState();
}

class _ExerciseListViewState extends State<ExerciseListView> {
  final fireStoreReference = FirebaseFirestore.instance;

  List<Exercise> exerciseList = [];

  @override
  void initState() {
    getDataFromFireStore().then((results) {
      SchedulerBinding.instance.addPostFrameCallback((
        timeStamp,
      ) {
        setState(() {});
      });
    });
    super.initState();
  }

  Future<void> getDataFromFireStore() async {
    var snapShotsValue = await fireStoreReference
        .collection("workouts")
        .where(
          'userID',
          isEqualTo: FirebaseAuth.instance.currentUser!.uid,
        )
        .get();

    List<Exercise> list = snapShotsValue.docs
        .map(
          (e) => Exercise.fromFireBaseSnapShotData(e),
        )
        .toList();
    setState(() {
      exerciseList = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: exerciseList.length,
        itemBuilder: (BuildContext context, int index) {
          return ExerciseLVEntry(
              exercise: exerciseList[index], context: context);
        });
  }
}
