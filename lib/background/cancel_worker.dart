import 'package:workmanager/workmanager.dart';

void cancelAllWorkers() {
  Workmanager().cancelAll(); // 모든 작업 취소
  print("모든 백그라운드 작업이 취소되었습니다.");
}
