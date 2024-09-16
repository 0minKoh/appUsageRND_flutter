import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeNotification() async {
    AndroidInitializationSettings android =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    InitializationSettings settings = InitializationSettings(android: android);
    await _local.initialize(settings);

    // 알림 채널 생성
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'app_usage_notification', // 채널 ID
      'app_usage_notification', // 채널 이름
      description: 'This channel is used for app usage notifications.',
      importance: Importance.max,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    // 알림 채널 등록
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> showNotification(String title, String body) async {
    NotificationDetails details = const NotificationDetails(
      android: AndroidNotificationDetails(
        "app_usage_notification",
        "app_usage_notification",
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
    await _local.show(
      0,
      title,
      body,
      details,
    );
  }
}
