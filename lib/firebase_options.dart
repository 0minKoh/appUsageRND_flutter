// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDKq_EscIG5FBg5pEah5M1hdhMRBjoynpo',
    appId: '1:817671627570:web:8ddc336aac7d6cb88aed2b',
    messagingSenderId: '817671627570',
    projectId: 'appusagernd-flutter',
    authDomain: 'appusagernd-flutter.firebaseapp.com',
    databaseURL: 'https://appusagernd-flutter-default-rtdb.firebaseio.com',
    storageBucket: 'appusagernd-flutter.appspot.com',
    measurementId: 'G-Z5PR1M2FQG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCp-XVgzN66KwKVlHo5g6SsvxW3aY_e9Yo',
    appId: '1:817671627570:android:0626730ff2332d6f8aed2b',
    messagingSenderId: '817671627570',
    projectId: 'appusagernd-flutter',
    databaseURL: 'https://appusagernd-flutter-default-rtdb.firebaseio.com',
    storageBucket: 'appusagernd-flutter.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAVMWzrA7Jv_8WRFhsz-RQpOrFJS-aVXRs',
    appId: '1:817671627570:ios:0fa55fb4a9fb13798aed2b',
    messagingSenderId: '817671627570',
    projectId: 'appusagernd-flutter',
    databaseURL: 'https://appusagernd-flutter-default-rtdb.firebaseio.com',
    storageBucket: 'appusagernd-flutter.appspot.com',
    iosBundleId: 'com.example.appUsageRndAndroid',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAVMWzrA7Jv_8WRFhsz-RQpOrFJS-aVXRs',
    appId: '1:817671627570:ios:0fa55fb4a9fb13798aed2b',
    messagingSenderId: '817671627570',
    projectId: 'appusagernd-flutter',
    databaseURL: 'https://appusagernd-flutter-default-rtdb.firebaseio.com',
    storageBucket: 'appusagernd-flutter.appspot.com',
    iosBundleId: 'com.example.appUsageRndAndroid',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDKq_EscIG5FBg5pEah5M1hdhMRBjoynpo',
    appId: '1:817671627570:web:0e674084779648638aed2b',
    messagingSenderId: '817671627570',
    projectId: 'appusagernd-flutter',
    authDomain: 'appusagernd-flutter.firebaseapp.com',
    databaseURL: 'https://appusagernd-flutter-default-rtdb.firebaseio.com',
    storageBucket: 'appusagernd-flutter.appspot.com',
    measurementId: 'G-JZNW3WLJEK',
  );

}