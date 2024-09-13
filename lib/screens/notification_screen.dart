import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class LocalNotification extends StatefulWidget {
  const LocalNotification({super.key});

  @override
  State<LocalNotification> createState() => _LocalNotificationState();
}

class _LocalNotificationState extends State<LocalNotification> {
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _permissionWithNotification();
    _initialization();
  }

  void _permissionWithNotification() async {
    await [Permission.notification].request();
  }

  void _initialization() async {
    AndroidInitializationSettings android =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    InitializationSettings settings = InitializationSettings(android: android);
    await _local.initialize(settings);

    // 알림 채널 생성
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'show_test', // 채널 ID
      'Test Notifications', // 채널 이름
      description: 'This channel is used for test notifications.',
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

  void _show() async {
    NotificationDetails details = const NotificationDetails(
      android: AndroidNotificationDetails(
        "show_test",
        "Test Notifications",
        channelDescription: "Test Local notications",
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
    await _local.show(
      0,
      "타이틀이 보여지는 영역입니다.",
      "컨텐츠 내용이 보여지는 영역입니다.",
      details,
    );
    await _uploadNotificationData();
  }

  Future<void> _uploadNotificationData() async {
    // 알림 데이터를 업로드하는 코드
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Local Notification"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _show,
                child: const Text("노티 보이기"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
