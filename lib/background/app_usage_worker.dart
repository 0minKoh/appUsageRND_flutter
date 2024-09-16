import 'package:app_usage_rnd_android/core/services/get_app_usage.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point') // Flutter 3.1+에서는 이 부분이 필수입니다.
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("백그라운드 작업 실행 중: $task");
    try {
      DateTime currentDateTime = DateTime.now();
      await UsageService().getForegroundApp(currentDateTime);
      print("백그라운드 작업 완료: $task");
    } catch (e) {
      print("에러 발생: $e");
    }

    return Future.value(true); // 작업 성공 시 true 반환
  });
}
