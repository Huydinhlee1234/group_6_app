import '../../../domain/entities/student.dart';
import '../../../interfaces/api/istudent_api.dart';
import '../../../interfaces/repositories/istudent_repository.dart';

class StudentRepository implements IStudentRepository {
  final IStudentApi _api;

  StudentRepository(this._api);

  @override
  Future<List<Student>> getAllStudents() => _api.getAllStudents();

  @override
  Future<Student> createStudent(Student student) => _api.createStudent(student);

  @override
  Future<Student> updateStudent(Student student) => _api.updateStudent(student);

  @override
  Future<void> deleteStudent(String id) => _api.deleteStudent(id);

  @override
  Future<void> importStudents(List<Student> students) => _api.importStudents(students);
}