// usage_service.dart
import 'package:app_usage_rnd_android/core/constants/constants.dart';
import 'package:app_usage_rnd_android/db/database_helper.dart';
import 'package:app_usage_rnd_android/models/app_usage_model.dart';
import 'package:app_usage_rnd_android/repositories/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usage_stats/usage_stats.dart';

class UsageService {
  Future<void> getForegroundApp(DateTime endDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime lastEndDate;

    try {
      // 마지막으로 저장된 endDate가 있는지 확인
      if (prefs.containsKey('lastEndDate')) {
        lastEndDate = DateTime.parse(prefs.getString('lastEndDate')!);
      } else {
        // 없으면 현재 시각을 사용
        lastEndDate =
            endDate.subtract(const Duration(minutes: CHECK_PERIOD_MINUTES));
      }
      AppUsageDay usageDay = await getAppUsage(lastEndDate, endDate);
      List<AppUsage> usageList = usageDay.usageData;

      if (usageList.isNotEmpty) {
        // 사용자 ID
        String userId = "vCTvVnWzTTW7xhvKs285ZDk6Scs1";

        // local DB에 업로드
        await DatabaseHelper.instance.addAppUsage(userId, usageDay);

        String lastEvent = usageList.last.appBundleId;
        if (prefs.containsKey('lastApp')) {
          String lastApp = prefs.getString('lastApp')!;
          if (lastApp == lastEvent) {
            PreferencesRepository().setTotalAppUsageTime(1);
          } else {
            PreferencesRepository().initTotalAppUsageTime();
          }
        }

        // 작업이 끝난 후 현재 endDate를 저장
        prefs.setString('lastEndDate', endDate.toIso8601String());

        // 작업이 끝난 후 마지막으로 사용한 앱을 저장
        prefs.setString('lastApp', lastEvent);
      }
    } catch (e) {
      print("get_app_usage.dart > UsageService.getForegroundApp Error: $e");
    }
  }

  Future<AppUsageDay> getAppUsage(startDate, endDate) async {
    final List<EventUsageInfo> queryEvents =
        await UsageStats.queryEvents(startDate, endDate);

    Map<String, List<AppUsage>> tempAppUsageMap = {};

    try {
      for (var event in queryEvents) {
        // Date: 2024 09 14
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
              appBundleId: event.packageName!,
              startTime: DateTime.fromMillisecondsSinceEpoch(
                      int.parse(event.timeStamp!))
                  .toLocal()
                  .toIso8601String()
                  .substring(11, 19),
            ),
          );
        } else if (event.eventType == "2") {
          for (int i = tempAppUsageMap[datekey]!.length - 1; i >= 0; i--) {
            if (tempAppUsageMap[datekey]![i].appBundleId == event.packageName) {
              tempAppUsageMap[datekey]![i].endTime =
                  DateTime.fromMillisecondsSinceEpoch(
                          int.parse(event.timeStamp!))
                      .toLocal()
                      .toIso8601String()
                      .substring(11, 19);
              break;
            }
          }
        }
      }
    } catch (e) {
      print("get_app_usage.dart > UsageService.getAppUsage Error: $e");
    }

    // final Map<String, List<AppUsageDay>> finalAppUsageMap = {};
    // tempAppUsageMap.forEach((date, usageList) {
    //   usageList.removeWhere((entry) => entry.endTime == null);

    //   if (usageList.isNotEmpty) {
    //     finalAppUsageMap['app_usage'] = [
    //       AppUsageDay(date: date, usageData: usageList)
    //     ];
    //   }
    // });

    // print("tempAppUsageMap: $tempAppUsageMap");

    return AppUsageDay(
        date: tempAppUsageMap.keys.first,
        usageData: tempAppUsageMap[tempAppUsageMap.keys.first]!);
  }
}
