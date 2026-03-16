import 'package:sqflite/sqflite.dart';
import '../../../interfaces/api/istudent_api.dart';
import '../../dtos/student/student_dto.dart';
import '../../dtos/student/update_insert_student_request_dto.dart';
import '../local/app_database.dart';

class StudentApi implements IStudentApi {
  @override
  Future<List<StudentDto>> getAllStudents() async {
    final db = await AppDatabase.instance.db;
    final List<Map<String, dynamic>> maps = await db.query('students');
    return maps.map((e) => StudentDto.fromJson(e)).toList();
  }

  @override
  Future<bool> createStudent(UpdateInsertStudentRequestDto request) async {
    final db = await AppDatabase.instance.db;
    try {
      await db.insert('students', request.toJson());
      return true;
    } catch (e) {
      return false; // Lỗi (ví dụ: trùng lặp UNIQUE)
    }
  }

  @override
  Future<bool> updateStudent(UpdateInsertStudentRequestDto request) async {
    final db = await AppDatabase.instance.db;
    final count = await db.update(
        'students',
        request.toJson(),
        where: 'id = ?',
        whereArgs: [request.id]
    );
    return count > 0;
  }

  @override
  Future<bool> deleteStudent(String id) async {
    final db = await AppDatabase.instance.db;
    final count = await db.delete(
        'students',
        where: 'id = ?',
        whereArgs: [id]
    );
    return count > 0;
  }

  // ✨ HÀM IMPORT TỐI ƯU BẰNG BATCH (Ghi hàng loạt cực nhanh)
  @override
  Future<bool> importStudents(List<UpdateInsertStudentRequestDto> requests) async {
    final db = await AppDatabase.instance.db;
    try {
      // Khởi tạo 1 lô (batch) các câu lệnh
      Batch batch = db.batch();
      for (var request in requests) {
        // conflictAlgorithm.ignore: Nếu sinh viên bị trùng mã trong chiến dịch, sẽ tự động bỏ qua người đó thay vì báo lỗi toàn bộ file
        batch.insert('students', request.toJson(), conflictAlgorithm: ConflictAlgorithm.ignore);
      }

      // Chạy toàn bộ lệnh cùng 1 lúc
      await batch.commit(noResult: true);
      return true;
    } catch (e) {
      return false;
    }
  }
}