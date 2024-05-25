import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../model/task_model.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void init() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleNotification(Task task) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      // 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // // Set notification time same as the deadline
    // final notificationTime = tz.TZDateTime.from(task.deadline, tz.local);

    // Set notification time 10 minutes before the deadline
    final notificationTime = tz.TZDateTime.from(
        task.deadline.subtract(const Duration(minutes: 10)), tz.local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      int.tryParse(task.id) ?? 0,
      'Task Reminder',
      'Your task "${task.title}" is due!',
      notificationTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    print(
        'Notification scheduled for task "${task.title}" at: $notificationTime');
  }

  Future<void> cancelNotification(String taskId) async {
    await flutterLocalNotificationsPlugin.cancel(int.parse(taskId, radix: 36));
  }
}
