import '../../domain/entities/student.dart';

abstract class IStudentRepository {
  Future<List<Student>> getAllStudents();
  Future<bool> createStudent(Student student);
  Future<bool> updateStudent(Student student);
  Future<bool> deleteStudent(String id);

  // ✨ THÊM HÀM IMPORT NHẬN LIST ENTITY
  Future<bool> importStudents(List<Student> students);
}