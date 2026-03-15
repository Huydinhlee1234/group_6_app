// class HealthRecordDto {
//   final String studentId;
//   final String campaignId;
//   final String? physical;
//   final String? vision;
//   final String? bloodPressure;
//   final String? general;
//   final String completedStations;
//
//   HealthRecordDto({
//     required this.studentId,
//     required this.campaignId,
//     this.physical,
//     this.vision,
//     this.bloodPressure,
//     this.general,
//     required this.completedStations,
//   });
//
//   factory HealthRecordDto.fromMap(Map<String, dynamic> map) {
//     return HealthRecordDto(
//       studentId: map['student_id'] as String,
//       campaignId: map['campaign_id'] as String,
//       physical: map['physical'] as String?,
//       vision: map['vision'] as String?,
//       bloodPressure: map['blood_pressure'] as String?,
//       general: map['general'] as String?,
//       completedStations: map['completed_stations'] as String,
//     );
//   }
// }

class HealthRecordDto {
  final String studentId;
  final String campaignId;
  final String? physical;
  final String? vision;
  final String? bloodPressure;
  final String? general;
  final String completedStations;

  HealthRecordDto({
    required this.studentId,
    required this.campaignId,
    this.physical,
    this.vision,
    this.bloodPressure,
    this.general,
    required this.completedStations,
  });

  factory HealthRecordDto.fromMap(Map<String, dynamic> map) {
    return HealthRecordDto(
      studentId: map['student_id'] ?? '',
      campaignId: map['campaign_id'] ?? '',
      physical: map['physical'],
      vision: map['vision'],
      bloodPressure: map['blood_pressure'],
      general: map['general'],
      completedStations: map['completed_stations'] ?? '[]',
    );
  }
}