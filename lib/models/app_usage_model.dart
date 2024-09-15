class AppUsageDay {
  final String date;
  final List<AppUsage> usageData;

  AppUsageDay({
    required this.date,
    required this.usageData,
  });

  factory AppUsageDay.fromJson(Map<String, dynamic> json) {
    return AppUsageDay(
      date: json['date'],
      usageData: (json['usageData'] as List)
          .map((data) => AppUsage.fromJson(data))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'usageData': usageData.map((data) => data.toJson()).toList(),
      };
}

class AppUsage {
  final String appBundleId;
  final String startTime;
  final String endTime;

  AppUsage({
    required this.appBundleId,
    required this.startTime,
    required this.endTime,
  });

  factory AppUsage.fromJson(Map<String, dynamic> json) {
    return AppUsage(
      appBundleId: json['app_bundle_id'],
      startTime: json['start_time'],
      endTime: json['end_time'],
    );
  }

  Map<String, dynamic> toJson() => {
        'app_bundle_id': appBundleId,
        'start_time': startTime,
        'end_time': endTime,
      };
}


// AppUsageModel Schema
// {
//   "YYYY-MM-DD": [
//     {
//       "date": [
//         {
//           "packageName": "com.example.app",
//           "start_time": "2024-09-14T09:00:00",
//           "end_time": "2024-09-14T10:00:00"
//         },
//         {
//           "packageName": "com.example.app2",
//           "start_time": "2024-09-14T11:00:00",
//           "end_time": null
//         }
//       ]
//     }
//   ]
// }

