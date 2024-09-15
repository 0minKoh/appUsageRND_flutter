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
}
