import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitapp/utils.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({Key? key, required this.duration}) : super(key: key);

  final Duration duration;

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  List<HealthDataPoint> _healthDataList = [];
  HealthFactory health = HealthFactory();

  Future writeDummyData() async {
    // define the types to get
    final types = [
      HealthDataType.BLOOD_GLUCOSE,
      HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
      HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
      //HealthDataType.BLOOD_OXYGEN,
      HealthDataType.BODY_TEMPERATURE
    ];
    // with coresponsing permissions
    final permissions = [
      HealthDataAccess.WRITE,
      HealthDataAccess.WRITE,
      HealthDataAccess.WRITE,
      //HealthDataAccess.WRITE,
      HealthDataAccess.WRITE,
    ];

    bool? hasPermissions =
        await HealthFactory.hasPermissions(types, permissions: permissions);
    if (hasPermissions == false) {
      await health.requestAuthorization(types, permissions: permissions);
    }

    await health.requestAuthorization(types, permissions: permissions);

    final workOutEndAt = DateTime.now();
    final workOutBeginAt = workOutEndAt.subtract(widget.duration);

    bool success = await health.writeHealthData(
        10.0, HealthDataType.BLOOD_GLUCOSE, workOutBeginAt, workOutEndAt);
    success =
        await health.writeBloodPressure(120, 90, workOutBeginAt, workOutEndAt);
    //success = await health.writeHealthData(10.0, HealthDataType.BLOOD_OXYGEN, workOutBeginAt, workOutEndAt);
    success = await health.writeHealthData(
        10.0, HealthDataType.BODY_TEMPERATURE, workOutBeginAt, workOutEndAt);
  }

  Future fetchData() async {
    // define the types to get
    final types = [
      HealthDataType.BLOOD_GLUCOSE,
      HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
      HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
      //HealthDataType.BLOOD_OXYGEN,
      HealthDataType.BODY_TEMPERATURE
    ];
    // with coresponsing permissions
    final permissions = [
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      //HealthDataAccess.READ,
      HealthDataAccess.READ,
    ];
    final workOutEndAt = DateTime.now();
    final workOutBeginAt = workOutEndAt.subtract(widget.duration);

    bool requested =
        await health.requestAuthorization(types, permissions: permissions);

    if (requested) {
      print('requested');
      try {
        // fetch health data
        List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
            workOutBeginAt, workOutEndAt, types);
        // save all the new data points (only the first 100)
        _healthDataList.addAll((healthData.length < 100)
            ? healthData
            : healthData.sublist(0, 100));
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }

      // filter out duplicates
      _healthDataList = HealthFactory.removeDuplicates(_healthDataList);

      // print the results
      _healthDataList.forEach((x) => print(x));
    } else {
      print("Authorization not granted");
      //setState(() {} /*_state = AppState.DATA_NOT_FETCHED*/);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    //writeDummyData();

    super.initState();

    writeDummyData().then((_) => fetchData()).then((_) => setState(() {}));
  }

  Widget buildPeriod() {
    String text = 'Workout Duration';
    String value = Utils.durationToTime(widget.duration);
    return buildInfoRow(text, value);
  }

  Widget buildInfo(HealthDataPoint dataPoint) {
    String value = dataPoint.value.toString();
    String text = dataPoint.typeString;
    if (value.length > 6) {
      value = value.substring(0, 5);
    }
    return buildInfoRow(text, value);
  }

  Padding buildInfoRow(String text, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: const TextStyle(fontSize: 16)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  void save() {
    final fireStoreReference = FirebaseFirestore.instance;
    final duration = Utils.durationToTime(widget.duration);
    fireStoreReference.collection("workouts").doc().set({
      for(var datapoint in _healthDataList) '${datapoint.typeString}':'${datapoint.value}',
      'duration':duration,
      'userID': FirebaseAuth.instance.currentUser!.uid,
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        leading: const CloseButton(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        onPressed: (){
          save();
          Navigator.of(context).pop();
        },
        label: const Text('Add to Workout history'),
      ),
      body: Column(
        children: [
          ..._healthDataList.map((e) => buildInfo(e)).toList(),
          buildPeriod(),
        ],
      ),
    );
  }
}
