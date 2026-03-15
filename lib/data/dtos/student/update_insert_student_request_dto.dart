import '../../../domain/entities/student.dart';

class UpdateInsertStudentRequestDto {
  final String id;
  final String campaignId;
  final String studentCode;
  final String name;
  final String className;
  final String status;

  UpdateInsertStudentRequestDto({
    required this.id,
    required this.campaignId,
    required this.studentCode,
    required this.name,
    required this.className,
    required this.status,
  });

  factory UpdateInsertStudentRequestDto.fromEntity(Student entity) {
    return UpdateInsertStudentRequestDto(
      id: entity.id,
      campaignId: entity.campaignId, // ✨ Lấy campaignId từ Entity
      studentCode: entity.studentCode,
      name: entity.name,
      className: entity.className,
      status: entity.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'campaign_id': campaignId, // ✨ Đẩy campaignId xuống DB/API
      'student_code': studentCode,
      'name': name,
      'class_name': className,
      'status': status,
    };
  }
}