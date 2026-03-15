import 'package:sqflite/sqflite.dart';
import '../../../domain/entities/student.dart';
import '../../../interfaces/api/istudent_api.dart';
import '../../dtos/student/student_dto.dart';
import '../local/app_database.dart';
import '../mapper/student_mapper.dart';

class StudentApi implements IStudentApi {
  final _fromDto = StudentFromDtoMapper();
  final _toDto = StudentToDtoMapper();

  @override
  Future<List<Student>> getAllStudents() async {
    final db = await AppDatabase.instance.db;
    final maps = await db.query('students');
    // ✨ Sửa .fromMap thành .fromJson để khớp với file StudentDto
    return maps.map((map) => _fromDto.map(StudentDto.fromJson(map))).toList();
  }

  @override
  Future<Student> createStudent(Student student) async {
    final db = await AppDatabase.instance.db;
    final dto = _toDto.map(student);
    // ✨ Sửa .toMap thành .toJson để khớp với file UpdateInsertStudentRequestDto
    await db.insert('students', dto.toJson());
    return student;
  }

  @override
  Future<Student> updateStudent(Student student) async {
    final db = await AppDatabase.instance.db;
    final dto = _toDto.map(student);
    // ✨ Sửa .toMap thành .toJson
    await db.update('students', dto.toJson(), where: 'id = ?', whereArgs: [student.id]);
    return student;
  }

  @override
  Future<void> deleteStudent(String id) async {
    final db = await AppDatabase.instance.db;
    await db.delete('students', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<void> importStudents(List<Student> students) async {
    final db = await AppDatabase.instance.db;
    Batch batch = db.batch();
    for (var student in students) {
      final dto = _toDto.map(student);
      // ✨ Sửa .toMap thành .toJson
      batch.insert('students', dto.toJson(), conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    await batch.commit(noResult: true);
  }
}