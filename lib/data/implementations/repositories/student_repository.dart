import '../../../domain/entities/student.dart';
import '../../../interfaces/api/istudent_api.dart';
import '../../../interfaces/repositories/istudent_repository.dart';
import '../mapper/student_mapper.dart';

class StudentRepository implements IStudentRepository {
  final IStudentApi _api;

  StudentRepository(this._api);

  @override
  Future<List<Student>> getAllStudents() async {
    final dtos = await _api.getAllStudents();
    return dtos.map((dto) => StudentMapper.toEntity(dto)).toList();
  }

  @override
  Future<bool> createStudent(Student student) {
    return _api.createStudent(StudentMapper.toInsertRequest(student));
  }

  @override
  Future<bool> updateStudent(Student student) {
    return _api.updateStudent(StudentMapper.toInsertRequest(student));
  }

  @override
  Future<bool> deleteStudent(String id) {
    return _api.deleteStudent(id);
  }

  // ✨ NHẬN LIST ENTITY TỪ VIEWMODEL -> ĐỔI SANG LIST DTO -> TRUYỀN XUỐNG API
  @override
  Future<bool> importStudents(List<Student> students) {
    final requests = students.map((s) => StudentMapper.toInsertRequest(s)).toList();
    return _api.importStudents(requests);
  }
}