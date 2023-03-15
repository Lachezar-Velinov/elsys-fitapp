class Exercise {
  String duration;
  double glucose;
  double bpDiastolic;
  double bpSystolic;
  double bodyTemp;
  String key;
  
  Exercise({
    required this.duration,
    required this.glucose,
    required this.bpDiastolic,
    required this.bpSystolic,
    required this.bodyTemp,
    required this.key,
  });
  
  

  static Exercise fromFireBaseSnapShotData(dynamic element) {

    return Exercise(duration: element.data()?['duration'] ?? '',
      glucose: double.parse(element.data()?['BLOOD_GLUCOSE'] ?? '0'),
      bpDiastolic: double.parse(element.data()?['BLOOD_PRESSURE_DIASTOLIC'] ?? '0'),
      bpSystolic: double.parse(element.data()?['BLOOD_PRESSURE_SYSTOLIC'] ?? '0'),
      bodyTemp: double.parse(element.data()?['BODY_TEMPERATURE'] ?? '0'),
      key: element.id,
    );
  }
}
