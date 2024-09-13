// main.dart
import 'package:app_usage_rnd_android/screens/app_usage_screen.dart';
import 'package:app_usage_rnd_android/screens/health_connect.dart';
import 'package:app_usage_rnd_android/screens/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(HealthConnect());
}
