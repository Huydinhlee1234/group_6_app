// import 'dart:convert';
//
// import '../../../domain/entities/health_record.dart';
// import '../../../interfaces/mapper/imapper.dart';
// import '../../dtos/health_record/health_record_dto.dart';
// import '../../dtos/health_record/update_insert_health_record_request_dto.dart';
//
// class HealthRecordFromDtoMapper implements IMapper<HealthRecordDto, HealthRecord> {
//   @override
//   HealthRecord map(HealthRecordDto input) {
//     return HealthRecord(
//       studentId: input.studentId,
//       campaignId: input.campaignId,
//       physical: input.physical != null ? jsonDecode(input.physical!) : null,
//       vision: input.vision != null ? jsonDecode(input.vision!) : null,
//       bloodPressure: input.bloodPressure != null ? jsonDecode(input.bloodPressure!) : null,
//       general: input.general != null ? jsonDecode(input.general!) : null,
//       completedStations: List<String>.from(jsonDecode(input.completedStations)),
//     );
//   }
// }
//
// class HealthRecordToDtoMapper implements IMapper<HealthRecord, UpdateInsertHealthRecordRequestDto> {
//   @override
//   UpdateInsertHealthRecordRequestDto map(HealthRecord input) {
//     return UpdateInsertHealthRecordRequestDto(
//       studentId: input.studentId,
//       campaignId: input.campaignId,
//       physical: input.physical != null ? jsonEncode(input.physical) : null,
//       vision: input.vision != null ? jsonEncode(input.vision) : null,
//       bloodPressure: input.bloodPressure != null ? jsonEncode(input.bloodPressure) : null,
//       general: input.general != null ? jsonEncode(input.general) : null,
//       completedStations: jsonEncode(input.completedStations),
//     );
//   }
// }

import 'dart:convert';
import '../../../domain/entities/health_record.dart';
import '../../../interfaces/mapper/imapper.dart';
import '../../dtos/health_record/health_record_dto.dart';
import '../../dtos/health_record/update_insert_health_record_request_dto.dart';

class HealthRecordFromDtoMapper implements IMapper<HealthRecordDto, HealthRecord> {
  @override
  HealthRecord map(HealthRecordDto input) {
    // 1. Giải mã danh sách trạm
    List<String> stations = [];
    try {
      if (input.completedStations.isNotEmpty) {
        final decoded = jsonDecode(input.completedStations);
        if (decoded is List) stations = decoded.map((e) => e.toString()).toList();
      }
    } catch (_) {}

    // 2. Hàm hỗ trợ giải mã String thành Map
    Map<String, dynamic>? decodeMap(String? source) {
      if (source == null || source.isEmpty) return null;
      try { return jsonDecode(source) as Map<String, dynamic>; }
      catch (_) { return null; }
    }

    return HealthRecord(
      studentId: input.studentId,
      campaignId: input.campaignId,
      physical: decodeMap(input.physical),
      vision: decodeMap(input.vision),
      bloodPressure: decodeMap(input.bloodPressure),
      general: decodeMap(input.general),
      completedStations: stations,
    );
  }
}

class HealthRecordToDtoMapper implements IMapper<HealthRecord, UpdateInsertHealthRecordRequestDto> {
  @override
  UpdateInsertHealthRecordRequestDto map(HealthRecord input) {
    return UpdateInsertHealthRecordRequestDto(
      studentId: input.studentId,
      campaignId: input.campaignId,
      // ✨ Mã hóa Map thành chuỗi JSON String để lưu SQLite
      physical: input.physical != null ? jsonEncode(input.physical) : null,
      vision: input.vision != null ? jsonEncode(input.vision) : null,
      bloodPressure: input.bloodPressure != null ? jsonEncode(input.bloodPressure) : null,
      general: input.general != null ? jsonEncode(input.general) : null,
      completedStations: jsonEncode(input.completedStations),
    );
  }
}