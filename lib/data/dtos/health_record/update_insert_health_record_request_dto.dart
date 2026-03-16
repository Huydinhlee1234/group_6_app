// class UpdateInsertHealthRecordRequestDto {
//   final String studentId;
//   final String campaignId;
//   final String? physical; // Chuỗi JSON
//   final String? vision; // Chuỗi JSON
//   final String? bloodPressure; // Chuỗi JSON
//   final String? general; // Chuỗi JSON
//   final String completedStations; // Chuỗi JSON Array (vd: "['physical', 'vision']")
//
//   UpdateInsertHealthRecordRequestDto({
//     required this.studentId,
//     required this.campaignId,
//     this.physical,
//     this.vision,
//     this.bloodPressure,
//     this.general,
//     required this.completedStations,
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'student_id': studentId,
//       'campaign_id': campaignId,
//       'physical': physical,
//       'vision': vision,
//       'blood_pressure': bloodPressure,
//       'general': general,
//       'completed_stations': completedStations,
//     };
//   }
// }

import 'dart:convert';

class UpdateInsertHealthRecordRequestDto {
  final String studentId;
  final String campaignId;
  final Map<String, dynamic>? physical;
  final Map<String, dynamic>? vision;
  final Map<String, dynamic>? bloodPressure;
  final Map<String, dynamic>? general;
  final List<String> completedStations;

  UpdateInsertHealthRecordRequestDto({
    required this.studentId,
    required this.campaignId,
    this.physical,
    this.vision,
    this.bloodPressure,
    this.general,
    required this.completedStations,
  });

  // Mã hóa từ Map/List thành chuỗi JSON Text để lưu vào SQLite
  Map<String, dynamic> toMap() {
    return {
      'student_id': studentId,
      'campaign_id': campaignId,
      'physical': physical != null ? jsonEncode(physical) : null,
      'vision': vision != null ? jsonEncode(vision) : null,
      'blood_pressure': bloodPressure != null ? jsonEncode(bloodPressure) : null,
      'general': general != null ? jsonEncode(general) : null,
      'completed_stations': jsonEncode(completedStations),
    };
  }
}