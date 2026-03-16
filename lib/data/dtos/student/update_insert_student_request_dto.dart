class UpdateInsertStudentRequestDto {
  final String id;
  final String campaignId;
  final String studentCode;
  final String name;
  final String className;
  final String email; // ✨ Đã thêm email
  final String status;

  UpdateInsertStudentRequestDto({
    required this.id,
    required this.campaignId,
    required this.studentCode,
    required this.name,
    required this.className,
    required this.email,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'campaign_id': campaignId,
      'student_code': studentCode,
      'name': name,
      'class_name': className,
      'email': email,
      'status': status,
    };
  }
}