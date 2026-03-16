import '../../../domain/entities/student.dart';
import '../../dtos/student/student_dto.dart';
import '../../dtos/student/update_insert_student_request_dto.dart';

class StudentMapper {
  static Student toEntity(StudentDto dto) {
    return Student(
      id: dto.id,
      campaignId: dto.campaignId,
      studentCode: dto.studentCode,
      name: dto.name,
      className: dto.className,
      email: dto.email, // ✨ Ánh xạ email
      status: dto.status,
    );
  }

  static UpdateInsertStudentRequestDto toInsertRequest(Student entity) {
    return UpdateInsertStudentRequestDto(
      id: entity.id,
      campaignId: entity.campaignId,
      studentCode: entity.studentCode,
      name: entity.name,
      className: entity.className,
      email: entity.email, // ✨ Ánh xạ email
      status: entity.status,
    );
  }
}