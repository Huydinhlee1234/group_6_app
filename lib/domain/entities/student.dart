class Student {
  final String id;
  final String campaignId;
  final String studentCode;
  final String name;
  final String className;
  final String email; // ✨ Đã thêm trường email
  final String status;

  Student({
    required this.id,
    required this.campaignId,
    required this.studentCode,
    required this.name,
    required this.className,
    required this.email,
    required this.status,
  });

  Student copyWith({
    String? id,
    String? campaignId,
    String? studentCode,
    String? name,
    String? className,
    String? email,
    String? status,
  }) {
    return Student(
      id: id ?? this.id,
      campaignId: campaignId ?? this.campaignId,
      studentCode: studentCode ?? this.studentCode,
      name: name ?? this.name,
      className: className ?? this.className,
      email: email ?? this.email,
      status: status ?? this.status,
    );
  }
}