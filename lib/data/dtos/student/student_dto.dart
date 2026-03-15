import '../../../domain/entities/student.dart';

class StudentDto {
  final String id;
  final String campaignId;
  final String studentCode;
  final String name;
  final String className;
  final String status;

  StudentDto({
    required this.id,
    required this.campaignId,
    required this.studentCode,
    required this.name,
    required this.className,
    required this.status,
  });

  // Từ Database (hoặc API) chuyển thành DTO
  factory StudentDto.fromJson(Map<String, dynamic> json) {
    return StudentDto(
      id: json['id'] ?? '',
      campaignId: json['campaign_id'] ?? json['campaignId'] ?? '', // ✨ Map campaign_id
      studentCode: json['student_code'] ?? json['studentCode'] ?? '',
      name: json['name'] ?? '',
      className: json['class_name'] ?? json['className'] ?? '',
      status: json['status'] ?? 'not_started',
    );
  }

  // Từ DTO chuyển xuống Database (hoặc API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'campaign_id': campaignId, // ✨ Đẩy campaign_id xuống DB
      'student_code': studentCode,
      'name': name,
      'class_name': className,
      'status': status,
    };
  }

  // Chuyển DTO thành Entity dùng cho UI
  Student toEntity() {
    return Student(
      id: id,
      campaignId: campaignId,
      studentCode: studentCode,
      name: name,
      className: className,
      status: status,
    );
  }

  // Chuyển Entity thành DTO
  factory StudentDto.fromEntity(Student entity) {
    return StudentDto(
      id: entity.id,
      campaignId: entity.campaignId,
      studentCode: entity.studentCode,
      name: entity.name,
      className: entity.className,
      status: entity.status,
    );
  }
}