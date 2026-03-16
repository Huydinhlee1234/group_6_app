import '../../data/dtos/student/student_dto.dart';
import '../../data/dtos/student/update_insert_student_request_dto.dart';

abstract class IStudentApi {
  Future<List<StudentDto>> getAllStudents();
  Future<bool> createStudent(UpdateInsertStudentRequestDto request); // Đổi tên cho giống code bạn muốn
  Future<bool> updateStudent(UpdateInsertStudentRequestDto request);
  Future<bool> deleteStudent(String id);

  // ✨ THÊM HÀM IMPORT NHẬN LIST DTO
  Future<bool> importStudents(List<UpdateInsertStudentRequestDto> requests);
}