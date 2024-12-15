import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

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
  // static bool _notifyOneDayBefore = false;
  // static bool _notifyOneWeekBefore = false;

  // static Future<void> _loadNotificationSettings() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   _notifyOneDayBefore = prefs.getBool('notify_one_day_before') ?? true;
  //   _notifyOneWeekBefore = prefs.getBool('notify_one_week_before') ?? true;
  // }

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
    final prefs = await SharedPreferences.getInstance();
    String selected_notification_option = prefs.getString('selected_notification_option') ?? "no_notification";

    if (selected_notification_option.compareTo("no_notification") == 0) {
      return;
    }

    DateTime today = DateTime.now().add(const Duration(seconds: 10));

    final tz.TZDateTime scheduleDate1 = tz.TZDateTime(
        tz.getLocation("America/Sao_Paulo"),
        customNotification.scheduleDate!.year,
        customNotification.scheduleDate!.month,
        customNotification.scheduleDate!.day,
        today.hour,
        today.minute,
        today.second
    );

    var scheduleDate = null;
    switch (selected_notification_option) {
      case "1_day_before" : scheduleDate = scheduleDate1.subtract(Duration(days: 1)); print("A"); break;
      case "1_week_before": scheduleDate = scheduleDate1.subtract(Duration(days: 7)); print("B"); break;
    }

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
