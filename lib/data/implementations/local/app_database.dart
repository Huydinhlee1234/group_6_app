import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'password_hasher.dart';

class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();

  Database? _db;

  Future<Database> get db async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'health_check.db');

    // ✨ QUAN TRỌNG NHẤT: XÓA DB CŨ ĐỂ ÁP DỤNG LUẬT UNIQUE MỚI VÀ CỘT MỚI
    //await deleteDatabase(path);

    return openDatabase(
      path,
      version: 3,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE users(
            id TEXT PRIMARY KEY,
            username TEXT NOT NULL UNIQUE,
            password_hash TEXT NOT NULL,
            role TEXT NOT NULL,
            name TEXT NOT NULL
          );
        ''');

        await db.execute('''
          CREATE TABLE session(
            id INTEGER PRIMARY KEY CHECK (id = 1),
            user_id TEXT NOT NULL,
            token TEXT NOT NULL,
            created_at TEXT NOT NULL 
          ); 
        ''');

        // ✨ BẢNG STUDENTS ĐÃ CHUẨN: Có campaign_id và Ràng buộc UNIQUE Kép
        await db.execute('''
          CREATE TABLE students(
            id TEXT PRIMARY KEY,
            campaign_id TEXT NOT NULL,
            student_code TEXT NOT NULL,
            name TEXT NOT NULL,
            class_name TEXT NOT NULL,
            status TEXT NOT NULL,
            UNIQUE(campaign_id, student_code)
          ); 
        ''');

        await db.execute('''
          CREATE TABLE campaigns(
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            start_date TEXT NOT NULL,
            end_date TEXT NOT NULL,
            location TEXT NOT NULL,
            status TEXT NOT NULL
          ); 
        ''');

        await db.execute('''
          CREATE TABLE health_records(
            student_id TEXT NOT NULL,
            campaign_id TEXT NOT NULL,
            physical TEXT,
            vision TEXT,
            blood_pressure TEXT,
            general TEXT,
            completed_stations TEXT NOT NULL,
            PRIMARY KEY (student_id, campaign_id)
          ); 
        ''');

        await db.execute('''
          CREATE TABLE stations(
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL
          ); 
        ''');

        // --- DỮ LIỆU MẪU ---
        await db.insert('users', {
          'id': '1', 'username': 'admin', 'password_hash': PasswordHasher.sha256Hash('admin123'), 'role': 'admin', 'name': 'Quản trị viên'
        });
        await db.insert('users', {
          'id': '2', 'username': 'nvyt1', 'password_hash': PasswordHasher.sha256Hash('123456'), 'role': 'healthStaff', 'name': 'Nguyễn Văn A'
        });

        await db.insert('stations', {'id': 'physical', 'name': 'Đo thể lực'});
        await db.insert('stations', {'id': 'vision', 'name': 'Khám thị lực'});
        await db.insert('stations', {'id': 'blood_pressure', 'name': 'Đo huyết áp'});
        await db.insert('stations', {'id': 'general', 'name': 'Khám tổng quát'});

        await db.insert('campaigns', {
          'id': '1', 'name': 'Khám sức khỏe đầu năm học 2026', 'start_date': '03-03-2026', 'end_date': '28-03-2026', 'location': 'Phòng Y tế Trường', 'status': 'ongoing'
        });
        await db.insert('campaigns', {
          'id': '2', 'name': 'Khám sức khỏe cuối khóa', 'start_date': '01-05-2026', 'end_date': '15-05-2026', 'location': 'Trạm y tế khu B', 'status': 'upcoming'
        });

        // Chú ý: Đã cấp campaign_id cho sinh viên mẫu
        await db.insert('students', {
          'id': '1', 'campaign_id': '1', 'student_code': 'SV001', 'name': 'Nguyễn Văn An', 'class_name': 'CNTT-K64', 'status': 'completed'
        });
        await db.insert('students', {
          'id': '2', 'campaign_id': '1', 'student_code': 'SV002', 'name': 'Trần Thị Bình', 'class_name': 'CNTT-K64', 'status': 'in_progress'
        });

        await db.insert('health_records', {
          'student_id': '1', 'campaign_id': '1',
          'physical': jsonEncode({'height': 170, 'weight': 65, 'bmi': 22.5, 'bmiCategory': 'normal'}),
          'vision': jsonEncode({'leftEye': '10/10', 'rightEye': '10/10'}),
          'blood_pressure': jsonEncode({'systolic': 120, 'diastolic': 80}),
          'general': jsonEncode({'healthStatus': 'good', 'notes': 'Sức khỏe tốt'}),
          'completed_stations': jsonEncode(['physical', 'vision', 'blood_pressure', 'general'])
        });
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {},
    );
  }
}