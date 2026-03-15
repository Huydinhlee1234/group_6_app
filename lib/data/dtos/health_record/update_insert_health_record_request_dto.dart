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

class UpdateInsertHealthRecordRequestDto {
  final String studentId;
  final String campaignId;
  final String? physical;
  final String? vision;
  final String? bloodPressure;
  final String? general;
  final String completedStations;

  UpdateInsertHealthRecordRequestDto({
    required this.studentId,
    required this.campaignId,
    this.physical,
    this.vision,
    this.bloodPressure,
    this.general,
    required this.completedStations,
  });

  Map<String, dynamic> toMap() {
    return {
      'student_id': studentId,
      'campaign_id': campaignId,
      'physical': physical,
      'vision': vision,
      'blood_pressure': bloodPressure,
      'general': general,
      'completed_stations': completedStations,
    };
  }
}