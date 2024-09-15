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
  // Workmanager().initialize(
  //   callbackDispatcher, // 분리된 파일의 함수 호출
  //   isInDebugMode: true, // 디버그 모드 활성화
  // );

  // // 백그라운드 작업 등록
  // Workmanager().registerOneOffTask(
  //   "task-test-240914v1",
  //   "task-test-240914v1", // 등록할 작업의 이름
  // );

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
      home: SignUpPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/home': (context) => HomeScreen(),
        '/db-read': (context) => DbScreen(),
      },
    );
  }
}
