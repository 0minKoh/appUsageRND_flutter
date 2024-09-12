// usage_service.dart
import 'package:app_usage_rnd_android/models/app_usage_model.dart';
import 'package:usage_stats/usage_stats.dart';

class UsageService {
  Future<AppUsageModel> getAppUsage(startDate, endDate) async {
    final List<EventUsageInfo> queryEvents =
        await UsageStats.queryEvents(startDate, endDate);

    Map<String, List<AppUsage>> tempAppUsageMap = {};

    for (var event in queryEvents) {
      String datekey =
          DateTime.fromMillisecondsSinceEpoch(int.parse(event.timeStamp!))
              .toLocal()
              .toIso8601String()
              .substring(0, 10);

      if (!tempAppUsageMap.containsKey(datekey)) {
        tempAppUsageMap[datekey] = [];
      }

      if (event.packageName == "com.google.android.apps.nexuslauncher") {
        continue;
      }

      if (event.eventType == "1") {
        tempAppUsageMap[datekey]!.add(
          AppUsage(
            packageName: event.packageName!,
            startTime:
                DateTime.fromMillisecondsSinceEpoch(int.parse(event.timeStamp!))
                    .toLocal()
                    .toIso8601String()
                    .substring(11, 19),
          ),
        );
      } else if (event.eventType == "2") {
        for (int i = tempAppUsageMap[datekey]!.length - 1; i >= 0; i--) {
          if (tempAppUsageMap[datekey]![i].packageName == event.packageName) {
            tempAppUsageMap[datekey]![i].endTime =
                DateTime.fromMillisecondsSinceEpoch(int.parse(event.timeStamp!))
                    .toLocal()
                    .toIso8601String()
                    .substring(11, 19);
            break;
          }
        }
      }
    }

    final Map<String, List<AppUsageDay>> finalAppUsageMap = {};
    tempAppUsageMap.forEach((date, usageList) {
      usageList.removeWhere((entry) => entry.endTime == null);

      if (usageList.isNotEmpty) {
        finalAppUsageMap['app_usage'] = [
          AppUsageDay(date: date, usageData: usageList)
        ];
      }
    });

    return AppUsageModel(appUsage: finalAppUsageMap);
  }
}
