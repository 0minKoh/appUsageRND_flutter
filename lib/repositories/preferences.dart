import 'package:app_usage_rnd_android/core/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesRepository {
  Future<void> initTotalAppUsageTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('totalAppUsageTime', 0);
  }

  Future<void> setTotalAppUsageTime(int MinuteToAdd) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int totalAppUsageTime = prefs.getInt('totalAppUsageTime') ?? 0;
    int notificationThreshold = 1;
    if (totalAppUsageTime >= notificationThreshold) {
      NotificationService().showNotification(
          '앱 사용시간 알림', '앱 사용 시간이 ${notificationThreshold}분을 넘었습니다.');
      prefs.setInt('totalAppUsageTime', 0);
    } else {
      totalAppUsageTime += MinuteToAdd;
      prefs.setInt('totalAppUsageTime', totalAppUsageTime);
    }
  }

  Future<void> initLastEndDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("initLastEndDate");
    prefs.remove('lastEndDate');
  }
}

// lastEndDate