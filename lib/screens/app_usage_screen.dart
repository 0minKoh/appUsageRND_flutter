// main.dart
import 'package:app_usage_rnd_android/core/services/usage_service.dart';
import 'package:app_usage_rnd_android/models/app_usage_model.dart';
import 'package:flutter/material.dart';
import 'package:usage_stats/usage_stats.dart';
import 'dart:convert'; // JSON 인코딩을 위해 추가

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<AppUsage> events = [];
  AppUsageModel appUsageModel = AppUsageModel(appUsage: {});

  @override
  void initState() {
    super.initState();
    initUsage();
  }

  Future<void> initUsage() async {
    try {
      UsageStats.grantUsagePermission();
      final usageService = UsageService();

      final DateTime endDate = DateTime.now();
      final DateTime startDate = endDate.subtract(const Duration(minutes: 1));
      appUsageModel = await usageService.getAppUsage(startDate, endDate);

      // JSON 형식으로 변환 및 출력
      String jsonOutput = jsonEncode(appUsageModel.toJson());
      print(jsonOutput);

      setState(() {
        events = appUsageModel.appUsage.values.first.first.usageData;
      });
    } catch (err) {
      print("Error: $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Usage Stats"), actions: const [
          IconButton(
            onPressed: UsageStats.grantUsagePermission,
            icon: Icon(Icons.settings),
          )
        ]),
        body: Container(
          child: RefreshIndicator(
            onRefresh: initUsage,
            child: ListView.separated(
              itemBuilder: (context, index) {
                var event = events[index];
                return ListTile(
                  title: Text(event.packageName ?? 'Unknown App'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("StartTime: ${event.startTime}"),
                      Text("EndTime: ${event.endTime ?? 'Currently in use'}"),
                    ],
                  ),
                  trailing: Text('Duration: seconds'),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: events.length,
            ),
          ),
        ),
      ),
    );
  }
}
