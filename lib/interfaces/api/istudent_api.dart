// lib/interfaces/api/istudent_api.dart
import '../../domain/entities/student.dart';

abstract class IStudentApi {
  Future<List<Student>> getAllStudents();
  Future<Student> createStudent(Student student);
  Future<Student> updateStudent(Student student);
  Future<void> deleteStudent(String id);
  Future<void> importStudents(List<Student> students);
}

