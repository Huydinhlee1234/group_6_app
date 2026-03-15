// class CampaignDto {
//   final String id;
//   final String name;
//   final String startDate;
//   final String endDate;
//   final String location;
//   final String status;
//
//   CampaignDto({
//     required this.id,
//     required this.name,
//     required this.startDate,
//     required this.endDate,
//     required this.location,
//     required this.status,
//   });
//
//   factory CampaignDto.fromMap(Map<String, dynamic> map) {
//     return CampaignDto(
//       id: map['id'] as String,
//       name: map['name'] as String,
//       startDate: map['start_date'] as String,
//       endDate: map['end_date'] as String,
//       location: map['location'] as String,
//       status: map['status'] as String,
//     );
//   }
// }

class CampaignDto {
  final String id;
  final String name;
  final String startDate;
  final String endDate;
  final String location;
  final String status;

  CampaignDto({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.status,
  });

  factory CampaignDto.fromJson(Map<String, dynamic> json) {
    return CampaignDto(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      startDate: json['start_date'] ?? json['startDate'] ?? '',
      endDate: json['end_date'] ?? json['endDate'] ?? '',
      location: json['location'] ?? '',
      status: json['status'] ?? 'upcoming',
    );
  }
}