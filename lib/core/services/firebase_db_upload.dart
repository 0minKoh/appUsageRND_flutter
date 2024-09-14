import 'package:firebase_database/firebase_database.dart';

Future<void> uploadAppUsageIfNotExists(
    String userId, List<Map<String, dynamic>> mockData) async {
  final _database = FirebaseDatabase.instance.ref();

  try {
    // mock_data 불러오기
    var dates = [];
    for (var date_map in mockData) {
      String date = date_map.keys.first;
      dates.add(date);
    }

    for (var date in dates) {
      final snapshot = await _database
          .child('users')
          .child(userId)
          .child('app_usage')
          .child(date)
          .get();
      if (!snapshot.exists) {
        var upload_data =
            mockData.firstWhere((element) => element.keys.first == date);
        await _database
            .child('users')
            .child(userId)
            .child('app_usage')
            .child(date)
            .set(upload_data[date]);
        print('Uploaded app usage for date: $date');
      } else {
        print('Date $date already exists, skipping upload.');
      }
    }
  } catch (e) {
    print('Failed to upload app usage data: $e');
  }
}

void uploadTest() async {
  String userId = 'E3V5NjAWCORHwSKqOu1vXnJqQAu2';

  // mock_data 예시
  List<Map<String, dynamic>> mockData = [
    {
      "2024 09 13": [
        {
          "app_bundle_id": "com.kakao.talk",
          "start_time": "14 35 51",
          "end_time": "14 36 01"
        },
        {
          "app_bundle_id": "com.nhn.pay",
          "start_time": "14 36 01",
          "end_time": "14 37 02"
        },
      ]
    },
    {
      "2024 09 14": [
        {
          "app_bundle_id": "com.nhn.search",
          "start_time": "09 01 01",
          "end_time": "09 02 02"
        },
        {
          "app_bundle_id": "com.nhn.pay",
          "start_time": "09 02 02",
          "end_time": "09 04 01"
        },
      ]
    }
  ];

  // 업로드 함수 호출
  await uploadAppUsageIfNotExists(userId, mockData);
}
