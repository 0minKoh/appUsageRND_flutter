// main.dart
import 'package:app_usage_rnd_android/background/app_usage_worker.dart';
import 'package:app_usage_rnd_android/screens/app_usage_screen.dart';
import 'package:app_usage_rnd_android/screens/auth/login.dart';
import 'package:app_usage_rnd_android/screens/auth/signup.dart';
import 'package:app_usage_rnd_android/screens/db/db_screen.dart';
import 'package:app_usage_rnd_android/screens/health_connect.dart';
import 'package:app_usage_rnd_android/screens/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:workmanager/workmanager.dart';
import 'firebase_options.dart';
import 'package:app_usage_rnd_android/screens/main/home.dart';

void main() async {
  // Firebase 초기화
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // worker 초기화
  Workmanager().initialize(
    callbackDispatcher, // 분리된 파일의 함수 호출
    isInDebugMode: true, // 디버그 모드 활성화
  );

  Workmanager().registerPeriodicTask(
    "appUsageTracker_v0",
    "appUsageTracker",
    frequency: const Duration(minutes: 1), // 매 1분마다 실행
  );

  runApp(MainWidget());
}

class MainWidget extends StatelessWidget {
  const MainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Usage R&D',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/home': (context) => HomeScreen(),
        '/db-read': (context) => DbScreen(),
      },
    );
  }
}
