class AppUsage {
  final String packageName;
  final String startTime;
  String? endTime;

  AppUsage({
    required this.packageName,
    required this.startTime,
    this.endTime,
  });

  // JSON으로 변환
  Map<String, dynamic> toJson() => {
        'packageName': packageName,
        'start_time': startTime,
        'end_time': endTime,
      };

  // JSON에서 객체로 변환
  factory AppUsage.fromJson(Map<String, dynamic> json) {
    return AppUsage(
      packageName: json['packageName'],
      startTime: json['start_time'],
      endTime: json['end_time'],
    );
  }
}

class AppUsageDay {
  final String date;
  final List<AppUsage> usageData;

  AppUsageDay({
    required this.date,
    required this.usageData,
  });

  // JSON으로 변환
  Map<String, dynamic> toJson() => {
        date: usageData.map((data) => data.toJson()).toList(),
      };

  // JSON에서 객체로 변환
  factory AppUsageDay.fromJson(String date, Map<String, dynamic> json) {
    var usageData =
        (json[date] as List).map((data) => AppUsage.fromJson(data)).toList();
    return AppUsageDay(date: date, usageData: usageData);
  }
}

class AppUsageModel {
  final Map<String, List<AppUsageDay>> appUsage;

  AppUsageModel({
    required this.appUsage,
  });

  // 전체 데이터를 JSON으로 변환
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    appUsage.forEach((date, usageDays) {
      json[date] = usageDays.map((day) => day.toJson()).toList();
    });
    return json;
  }

  // JSON에서 전체 데이터를 객체로 변환
  factory AppUsageModel.fromJson(Map<String, dynamic> json) {
    Map<String, List<AppUsageDay>> appUsage = {};
    json.forEach((date, data) {
      var usageDays = (data as List)
          .map((dayJson) => AppUsageDay.fromJson(date, dayJson))
          .toList();
      appUsage[date] = usageDays;
    });
    return AppUsageModel(appUsage: appUsage);
  }
}
