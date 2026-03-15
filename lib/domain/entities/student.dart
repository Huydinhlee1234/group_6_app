class Student {
  final String id;
  final String campaignId; // ✨ BẮT BUỘC PHẢI CÓ
  final String studentCode;
  final String name;
  final String className;
  final String status;

  Student({
    required this.id,
    required this.campaignId,
    required this.studentCode,
    required this.name,
    required this.className,
    required this.status,
  });
}