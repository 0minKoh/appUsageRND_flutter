import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point') // Flutter 3.1+에서는 이 부분이 필수입니다.
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("백그라운드 작업 실행 중: $task");

    // 실제 백그라운드에서 실행될 작업을 여기에 작성합니다.
    // 예시: 서버에서 데이터를 가져와 로컬 DB에 저장하는 작업 등
    // 현재는 단순 로그만 출력합니다.

    return Future.value(true); // 작업 성공 시 true 반환
  });
}
