// class HealthRecord {
//   final String studentId;
//   final String campaignId;
//   final Map<String, dynamic>? physical; // Chiều cao, cân nặng, BMI...
//   final Map<String, dynamic>? vision; // Mắt trái, mắt phải...
//   final Map<String, dynamic>? bloodPressure; // Huyết áp tâm thu, tâm trương
//   final Map<String, dynamic>? general; // Khám tổng quát
//   final List<String> completedStations; // Danh sách các trạm đã khám xong
//
//   HealthRecord({
//     required this.studentId,
//     required this.campaignId,
//     this.physical,
//     this.vision,
//     this.bloodPressure,
//     this.general,
//     required this.completedStations,
//   });
// }

class HealthRecord {
  final String studentId;
  final String campaignId;
  final Map<String, dynamic>? physical;
  final Map<String, dynamic>? vision;
  final Map<String, dynamic>? bloodPressure;
  final Map<String, dynamic>? general;
  final List<String> completedStations;

  HealthRecord({
    required this.studentId,
    required this.campaignId,
    this.physical,
    this.vision,
    this.bloodPressure,
    this.general,
    required this.completedStations,
  });

  HealthRecord copyWith({
    String? studentId,
    String? campaignId,
    Map<String, dynamic>? physical,
    Map<String, dynamic>? vision,
    Map<String, dynamic>? bloodPressure,
    Map<String, dynamic>? general,
    List<String>? completedStations,
  }) {
    return HealthRecord(
      studentId: studentId ?? this.studentId,
      campaignId: campaignId ?? this.campaignId,
      physical: physical ?? this.physical,
      vision: vision ?? this.vision,
      bloodPressure: bloodPressure ?? this.bloodPressure,
      general: general ?? this.general,
      completedStations: completedStations ?? this.completedStations,
    );
  }
}