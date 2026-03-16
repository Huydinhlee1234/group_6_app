class StudentDto {
  final String id;
  final String campaignId;
  final String studentCode;
  final String name;
  final String className;
  final String email; // ✨ Đã thêm email
  final String status;

  StudentDto({
    required this.id,
    required this.campaignId,
    required this.studentCode,
    required this.name,
    required this.className,
    required this.email,
    required this.status,
  });

  factory StudentDto.fromJson(Map<String, dynamic> json) {
    return StudentDto(
      id: json['id'],
      campaignId: json['campaign_id'],
      studentCode: json['student_code'],
      name: json['name'],
      className: json['class_name'],
      email: json['email'] ?? '', // Xử lý an toàn nếu DB cũ null
      status: json['status'],
    );
  }
}