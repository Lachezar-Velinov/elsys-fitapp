import 'package:fitapp/model/notification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings _androidInitializationSettings =
      const AndroidInitializationSettings('@mipmap/ic_launcher');

  void initialiseNotification() async {
    InitializationSettings initializationSettings = InitializationSettings(
      android: _androidInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> sendNotification(int id, String? title, String? body) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      'reminders',
      'Reminders',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
    );
  }

  Future<void> schedulePeNotification(FitAppNotification notification) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      'reminders',
      'Reminders',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.periodicallyShow(
      notification.id,
      notification.title,
      notification.body,
      notification.repeatInterval,
      notificationDetails,
    );
  }
}
