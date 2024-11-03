import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class CustomNotification {
  final int id;
  final String? title;
  final String? body;
  final DateTime? scheduleDate;

  CustomNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduleDate
  });
}

class NotificationService {

  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static AndroidNotificationDetails? _androidPlatformChannelSpecifics;
  static NotificationDetails? _platformChannelSpecifics;

  static Future<void> initializeNotifications() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    _androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'channelNotification',
        'channelNotification',
        importance: Importance.max,
        priority: Priority.high
        //showWhen: true
    );
    _platformChannelSpecifics = NotificationDetails(android: _androidPlatformChannelSpecifics);
  }

  static Future<void> scheduleNotification(CustomNotification customNotification) async {
    DateTime today = DateTime.now().add(const Duration(seconds: 10));

    final tz.TZDateTime scheduleDate = tz.TZDateTime(
        tz.getLocation("America/Sao_Paulo"),
        customNotification.scheduleDate!.year,
        customNotification.scheduleDate!.month,
        customNotification.scheduleDate!.day,
        today.hour,
        today.minute,
        today.second
    );

    cancelNotification(customNotification.id);
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        customNotification.id,
        customNotification.title,
        customNotification.body,
        scheduleDate,
        _platformChannelSpecifics!,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
    );
  }

  static Future<void> cancelNotification(int id) async {
    _flutterLocalNotificationsPlugin.cancel(id);
  }

}
