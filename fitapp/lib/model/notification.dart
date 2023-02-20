import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FitAppNotification {
  String userId;
  String key;
  int id;
  String? title;
  String? body;
  RepeatInterval repeatInterval;

  FitAppNotification({
    required this.key,
    required this.userId,
    required this.id,
    this.title,
    this.body,
    this.repeatInterval = RepeatInterval.weekly,
  });

  static FitAppNotification fromFireBaseSnapShotData(dynamic element) {
    String? repeatIntervalString = element.data()?['repeatInterval'];
    RepeatInterval repeatInterval = repeatIntervalString != null
        ? RepeatInterval.values.byName(repeatIntervalString)
        : RepeatInterval.weekly;

    return FitAppNotification(
      key: element.id,
      userId: element.data()?['userId'] ?? '',
      id: element.data()?['id'] ?? 0,
      title: element.data()?['title'] ?? '',
      body: element.data()?['body'] ?? '',
      repeatInterval: repeatInterval,
    );
  }
}
