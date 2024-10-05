import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CustomNotification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;

  CustomNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });
}

class NotificationService {
  late FlutterLocalNotificationsPlugin localNotificationsPlugin;
  late AndroidNotificationDetails androidNotificationDetails;

  NotificationService() {
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _setupNotifications();
  }

  Future<void> _setupNotifications() async {
    await _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await localNotificationsPlugin.initialize(
      InitializationSettings(android: android),
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _onSelectNotification(response.payload);
      },
    );
  }

  Future<void> _onSelectNotification(String? payload) async {
    if (payload != null) {
      print("Notification Payload: $payload");
    }
  }

  void showNotification(CustomNotification notification) {
    androidNotificationDetails = const AndroidNotificationDetails(
      'testes_notifications',
      'Lembretes',
      importance: Importance.max,
      priority: Priority.max,
      enableVibration: true,
    );

    localNotificationsPlugin.show(
      notification.id,
      notification.title,
      notification.body,
      NotificationDetails(android: androidNotificationDetails),
      payload: notification.payload,
    );

    print("Notificação enviada: ${notification.title}");
  }

  Future<void> checkForNotifications() async {
    final details = await localNotificationsPlugin.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      print("App launched from notification");
    }
  }
}
