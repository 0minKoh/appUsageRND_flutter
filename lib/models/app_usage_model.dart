class AppUsageDay {
  final String date;
  final List<AppUsage> usageData;

  AppUsageDay({
    required this.date,
    required this.usageData,
  });

  factory AppUsageDay.fromJson(Map<String, dynamic> json) {
    return AppUsageDay(
      date: json.keys.first,
      usageData: (json[json.keys.first] as List)
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
  String? endTime;

  AppUsage({
    required this.appBundleId,
    required this.startTime,
    this.endTime,
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
