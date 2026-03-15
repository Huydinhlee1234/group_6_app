import '../../../domain/entities/student.dart';
import '../../../interfaces/mapper/imapper.dart';
import '../../dtos/student/student_dto.dart';
import '../../dtos/student/update_insert_student_request_dto.dart';

class StudentFromDtoMapper implements IMapper<StudentDto, Student> {
  @override
  Student map(StudentDto input) {
    return Student(
      id: input.id,
      campaignId: input.campaignId, // ✨ Đã thêm thuộc tính này
      studentCode: input.studentCode,
      name: input.name,
      className: input.className,
      status: input.status,
    );
  }
}

class StudentToDtoMapper implements IMapper<Student, UpdateInsertStudentRequestDto> {
  @override
  UpdateInsertStudentRequestDto map(Student input) {
    return UpdateInsertStudentRequestDto(
      id: input.id,
      campaignId: input.campaignId, // ✨ Đã thêm thuộc tính này
      studentCode: input.studentCode,
      name: input.name,
      className: input.className,
      status: input.status,
    );
  }
}