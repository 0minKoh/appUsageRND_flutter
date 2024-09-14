import 'dart:io';

import 'package:app_usage_rnd_android/core/services/firebase_db_upload.dart';
import 'package:app_usage_rnd_android/widgets/custom_elevated_button.dart';
import 'package:app_usage_rnd_android/widgets/custom_modal.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:usage_stats/usage_stats.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isUsagePermissionGranted = false;
  bool isNotificationPermissionGranted = false;
  bool isHealthPermissionGranted = false;

  final Health _health = Health();

  Map<Permission, bool> permissionsStatus = {
    Permission.notification: false,
    Permission.manageExternalStorage: false,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 여기에서 mounted가 된 후 실행할 코드를 작성합니다.
      // uploadTest();
      if (mounted) {
        // 예: 권한 요청이나 데이터 로딩 등
        checkAllPermissions();
      }
    });
  }

  // Start:: showModal
  void _showCustomModal(
      BuildContext context,
      String title,
      String content,
      String confirmText,
      String cancelText,
      Function onConfirm,
      Function onCancel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomModal(
          title: title,
          content: content,
          confirmText: confirmText,
          cancelText: cancelText,
          onConfirm: () {
            Navigator.of(context).pop(); // 모달 닫기
            onConfirm();
          },
          onCancel: () {
            Navigator.of(context).pop(); // 모달 닫기
            onCancel();
          },
        );
      },
    );
  }
  // End:: showModal

  // Start:: checkAllPermissions
  Future<void> checkAllPermissions() async {
    await _checkAppUsagePermission();
    await _checkNotificationPermission();
    await _checkHealthPermission();

    if (!isUsagePermissionGranted) {
      _showCustomModal(context, '(필수) 앱 사용 기록 액세스', '앱 사용 기록 권한 허용이 필요합니다.',
          '확인', '취소', _requestAppUsagePermission, () {});
    }
    if (!isNotificationPermissionGranted) {
      _showCustomModal(context, '(필수) 알림 허용', '알림 허용이 필요합니다.', '확인', '취소',
          _requestNotificationPermission, () {});
    }
    if (!isHealthPermissionGranted) {
      _showCustomModal(context, '(필수) 건강 데이터 액세스', '건강 데이터 접근 권한 허용이 필요합니다.',
          '확인', '취소', _requestHealthPermission, () {});
    }
  }

  // End:: checkAllPermissions
  // Start:: Check App Usage Permission
  Future<void> _checkAppUsagePermission() async {
    final bool isPermissionGranted =
        await UsageStats.checkUsagePermission() ?? false;
    setState(() {
      isUsagePermissionGranted = isPermissionGranted;
    });
  }

  Future<void> _requestAppUsagePermission() async {
    await UsageStats.grantUsagePermission();
  }

  // End:: Check App Usage Permission
  // Start:: Check Notification Permission
  Future<void> _checkNotificationPermission() async {
    final bool isPermissionGranted =
        await Permission.notification.status.isGranted;
    setState(() {
      isNotificationPermissionGranted = isPermissionGranted;
    });
  }

  Future<void> _requestNotificationPermission() async {
    await Permission.notification.request();
  }

  // End:: Check Notification Permission
  // Start:: Check Health Permission
  Future<void> _checkHealthPermission() async {
    _health.configure();

    // Health 데이터 타입 정의 (걸음 수, 이동 거리, 심박수)
    var types = [
      HealthDataType.STEPS,
      HealthDataType.DISTANCE_DELTA,
      HealthDataType.HEART_RATE,
    ];

    // 권한 요청
    bool requested = await _health.requestAuthorization(types);
    setState(() {
      isHealthPermissionGranted = requested;
    });
  }

  Future<void> _requestHealthPermission() async {
    await Permission.activityRecognition.request();
    await Permission.location.request();
  }
  // End:: Check Health Permission

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PermissionStatusItem(
              permission: '앱 사용기록 액세스 권한',
              isGranted: isUsagePermissionGranted,
              grantedIcon: Icons.app_registration,
              deniedIcon: Icons.app_blocking,
              grantedColor: Colors.green,
              deniedColor: Colors.red,
            ),
            SizedBox(height: 20),
            PermissionStatusItem(
              permission: '알림 권한',
              isGranted: isNotificationPermissionGranted,
              grantedIcon: Icons.notifications,
              deniedIcon: Icons.notifications_off,
              grantedColor: Colors.green,
              deniedColor: Colors.red,
            ),
            SizedBox(height: 20),
            PermissionStatusItem(
              permission: '건강 데이터 접근 권한',
              isGranted: isHealthPermissionGranted,
              grantedIcon: Icons.health_and_safety,
              deniedIcon: Icons.health_and_safety_outlined,
              grantedColor: Colors.green,
              deniedColor: Colors.red,
            ),
            SizedBox(height: 40),
            CustomElevatedButton(text: '권한 확인', onPressed: checkAllPermissions)
          ],
        ),
      ),
    );
  }
}

class PermissionStatusItem extends StatelessWidget {
  final String permission;
  final bool isGranted;
  final IconData grantedIcon;
  final IconData deniedIcon;
  final Color grantedColor;
  final Color deniedColor;

  PermissionStatusItem({
    required this.permission,
    required this.isGranted,
    required this.grantedIcon,
    required this.deniedIcon,
    required this.grantedColor,
    required this.deniedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                isGranted ? grantedIcon : deniedIcon,
                color: isGranted ? grantedColor : deniedColor,
                size: 30,
              ),
              SizedBox(width: 10),
              Text(
                permission,
                style: TextStyle(
                  fontSize: 16,
                  color: isGranted ? grantedColor : deniedColor,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                isGranted ? '허용됨' : '거부됨',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isGranted ? grantedColor : deniedColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
