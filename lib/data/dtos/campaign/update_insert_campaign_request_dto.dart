// class UpdateInsertCampaignRequestDto {
//   final String? id;
//   final String name;
//   final String startDate;
//   final String endDate;
//   final String location;
//   final String status;
//
//   UpdateInsertCampaignRequestDto({
//     this.id,
//     required this.name,
//     required this.startDate,
//     required this.endDate,
//     required this.location,
//     required this.status,
//   });
//
//   Map<String, dynamic> toMap() {
//     final map = <String, dynamic>{
//       'name': name,
//       'start_date': startDate,
//       'end_date': endDate,
//       'location': location,
//       'status': status,
//     };
//
//     if (id != null) {
//       map['id'] = id;
//     }
//
//     return map;
//   }
// }

class UpdateInsertCampaignRequestDto {
  final String id;
  final String name;
  final String startDate;
  final String endDate;
  final String location;
  final String status;

  UpdateInsertCampaignRequestDto({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'start_date': startDate,
      'end_date': endDate,
      'location': location,
      'status': status,
    };
  }
}