import 'dart:convert';

import 'package:app_usage_rnd_android/models/app_usage_model.dart';
import 'package:app_usage_rnd_android/models/user_profile_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "user.db";
  static final _databaseVersion = 1;

  static final table = 'user';

  static final columnId = 'id';
  static final columnEmail = 'email';
  static final columnAge = 'age';
  static final columnGender = 'gender';
  static final columnDevice = 'device';
  static final columnAppUsage = 'app_usage';
  static final columnNotifications = 'notifications';
  static final columnHealthData = 'health_data';

  // Singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // DB 초기화
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  // DB Table 생성
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId TEXT PRIMARY KEY,
            $columnEmail TEXT NOT NULL,
            $columnAge INTEGER NOT NULL,
            $columnGender TEXT NOT NULL,
            $columnDevice TEXT NOT NULL,
            $columnAppUsage TEXT,
            $columnNotifications TEXT,
            $columnHealthData TEXT
          )
          ''');
  }

  // DB Table Schema 변경
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Implement schema upgrade logic if needed
  }

  // (INSERT) UserProfile 인스턴스 삽입
  Future<int> insertUserProfile(UserProfile user) async {
    Database db = await instance.database;
    return await db.insert(table, user.toJson());
  }

  // (GET) 모든 UserProfile 인스턴스 얻기
  Future<List<UserProfile>> queryAllUserProfiles() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (i) {
      return UserProfile.fromJson(maps[i]);
    });
  }

  // (GET) 특정 UserProfile 인스턴스 얻기
  Future<UserProfile?> queryUserProfileById(String id) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      table,
      columns: [
        columnId,
        columnEmail,
        columnAge,
        columnGender,
        columnDevice,
        columnAppUsage,
        columnNotifications,
        columnHealthData
      ],
      where: '$columnId = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return UserProfile.fromJson(maps.first);
    } else {
      return null;
    }
  }

  // (UPDATE) 특정 UserProfile 인스턴스 업데이트
  Future<int> updateUserProfile(UserProfile user) async {
    Database db = await instance.database;
    return await db.update(
      table,
      user.toJson(),
      where: '$columnId = ?',
      whereArgs: [user.id],
    );
  }

  // (DELETE) 특정 UserProfile 인스턴스 삭제
  Future<int> deleteUserProfile(String id) async {
    Database db = await instance.database;
    return await db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  // 특정 UserProfile의 app_usage 데이터에 AppUsage 추가
  // 특정 UserProfile의 app_usage 데이터에 AppUsage 추가
  Future<void> addAppUsage(String userId, AppUsageDay appUsageDay) async {
    Database db = await instance.database;

    // 1. 해당 유저의 app_usage 데이터를 가져옴
    final List<Map<String?, dynamic>> maps = await db.query(
      table,
      columns: [columnAppUsage],
      where: '$columnId = ?',
      whereArgs: [userId],
    );
    print("\n\n maps: \n $maps \n\n");

    // 2. 가져온 데이터를 JSON으로 변환
    String? appUsageJson = maps.isNotEmpty ? maps.first[columnAppUsage] : null;
    Map<String, List<dynamic>> appUsageMap = {};

    if (appUsageJson != null) {
      List<dynamic> appUsageList = jsonDecode(appUsageJson) as List<dynamic>;
      for (var entry in appUsageList) {
        if (entry is Map<String, dynamic>) {
          entry.forEach((key, value) {
            appUsageMap[key] = List<dynamic>.from(value);
          });
        }
      }
    }

    // 3. newUsageList 데이터를 날짜별로 분류하여 추가
    List<AppUsage> newUsageList = appUsageDay.usageData;
    String date = appUsageDay.date;

    if (!appUsageMap.containsKey(date)) {
      appUsageMap[date] = [];
    }

    for (AppUsage newUsage in newUsageList) {
      appUsageMap[date]?.add(newUsage.toJson());
    }

    // 4. 갱신된 데이터를 다시 JSON으로 변환하여 DB에 저장
    String updatedAppUsageJson =
        jsonEncode(appUsageMap.entries.map((e) => {e.key: e.value}).toList());
    print("\n\n updatedAppUsageJson: \n $updatedAppUsageJson \n\n");
    await db.update(
      table,
      {columnAppUsage: updatedAppUsageJson},
      where: '$columnId = ?',
      whereArgs: [userId],
    );
  }

  // (UPDATE) 특정 UserProfile의 app_usage 값을 빈 리스트로 초기화
  Future<int> resetAppUsage(String userId) async {
    Database db = await instance.database;

    // 빈 리스트로 초기화된 JSON 문자열
    String emptyAppUsage = jsonEncode([]);

    // 업데이트 쿼리 실행
    return await db.update(
      table,
      {columnAppUsage: emptyAppUsage},
      where: '$columnId = ?',
      whereArgs: [userId],
    );
  }
}
