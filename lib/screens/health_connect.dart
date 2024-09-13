import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:health/health.dart';

class HealthConnect extends StatefulWidget {
  const HealthConnect({super.key});

  @override
  State<HealthConnect> createState() => _HealthConnectState();
}

class _HealthConnectState extends State<HealthConnect> {
  // HealthFactory 인스턴스 생성
  final Health _health = Health();

  // 심박수, 걸음수, 이동거리 저장할 변수
  int? _totalSteps;
  double? _totalDistance;
  double? _maxHeartRate;
  double? _minHeartRate;

  @override
  void initState() {
    super.initState();
    _permissionWithActivityRecognition();
    _permissionWithLocation();
    _initializeHealth();
  }

  // 권한 요청 및 Health 데이터 가져오기
  Future<void> _initializeHealth() async {
    // Health 플러그인 구성
    _health.configure();

    // Health 데이터 타입 정의 (걸음 수, 이동 거리, 심박수)
    var types = [
      HealthDataType.STEPS,
      HealthDataType.DISTANCE_DELTA,
      HealthDataType.HEART_RATE,
    ];

    // 권한 요청
    bool requested = await _health.requestAuthorization(types);

    if (requested) {
      await _fetchHealthData(types);
    }
  }

  // Health 데이터를 가져오는 함수
  Future<void> _fetchHealthData(types) async {
    var now = DateTime.now();
    var midnight = DateTime(now.year, now.month, now.day);

    // 지난 24시간의 Health 데이터 가져오기
    List<HealthDataPoint> healthData = await _health.getHealthDataFromTypes(
        startTime: midnight, endTime: now, types: types);

    // 심박수 데이터 처리
    var heartRates = healthData
        .where((point) => point.type == HealthDataType.HEART_RATE)
        .map((point) => point.value as double)
        .toList();

    // 걸음 수 및 이동 거리 데이터 처리
    var steps = healthData
        .where((point) => point.type == HealthDataType.STEPS)
        .fold(0, (sum, point) => sum + (point.value as int));

    var distance = healthData
        .where((point) => point.type == HealthDataType.DISTANCE_DELTA)
        .fold(0.0, (sum, point) => sum + (point.value as double));

    // 최대, 최소 심박수 계산
    if (heartRates.isNotEmpty) {
      setState(() {
        _maxHeartRate = heartRates.reduce((a, b) => a > b ? a : b);
        _minHeartRate = heartRates.reduce((a, b) => a < b ? a : b);
      });
    }

    // 걸음 수 및 이동 거리 상태 업데이트
    setState(() {
      _totalSteps = steps;
      _totalDistance = distance;
    });
  }

  // 권한 허용
  void _permissionWithActivityRecognition() async {
    await Permission.activityRecognition.request();
  }

  void _permissionWithLocation() async {
    await Permission.location.request();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(title: Text("Health Data"), actions: [
        IconButton(
          onPressed: _initializeHealth,
          icon: Icon(Icons.refresh),
        )
      ]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Total Steps: $_totalSteps"),
            Text("Total Distance: $_totalDistance"),
            Text("Max Heart Rate: $_maxHeartRate"),
            Text("Min Heart Rate: $_minHeartRate"),
          ],
        ),
      ),
    ));
  }
}
