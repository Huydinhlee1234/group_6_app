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

import 'dart:convert';

class HealthRecordDto {
  final String studentId;
  final String campaignId;
  final Map<String, dynamic>? physical;
  final Map<String, dynamic>? vision;
  final Map<String, dynamic>? bloodPressure;
  final Map<String, dynamic>? general;
  final List<String> completedStations;

  HealthRecordDto({
    required this.studentId,
    required this.campaignId,
    this.physical,
    this.vision,
    this.bloodPressure,
    this.general,
    required this.completedStations,
  });

  // Giải mã JSON từ SQLite Text ra Map/List
  factory HealthRecordDto.fromMap(Map<String, dynamic> map) {
    return HealthRecordDto(
      studentId: map['student_id'],
      campaignId: map['campaign_id'],
      physical: map['physical'] != null ? jsonDecode(map['physical']) : null,
      vision: map['vision'] != null ? jsonDecode(map['vision']) : null,
      bloodPressure: map['blood_pressure'] != null ? jsonDecode(map['blood_pressure']) : null,
      general: map['general'] != null ? jsonDecode(map['general']) : null,
      completedStations: map['completed_stations'] != null
          ? List<String>.from(jsonDecode(map['completed_stations']))
          : [],
    );
  }
}