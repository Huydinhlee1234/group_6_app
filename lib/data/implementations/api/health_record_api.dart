import 'package:sqflite/sqflite.dart';
import '../../../interfaces/api/ihealth_record_api.dart';
import '../../dtos/health_record/health_record_dto.dart';
import '../../dtos/health_record/update_insert_health_record_request_dto.dart';
import '../local/app_database.dart';

class HealthRecordApi implements IHealthRecordApi {
  @override
  Future<List<HealthRecordDto>> getAllRecords() async {
    final db = await AppDatabase.instance.db;
    final List<Map<String, dynamic>> maps = await db.query('health_records');
    return maps.map((e) => HealthRecordDto.fromMap(e)).toList();
  }

  @override
  Future<List<HealthRecordDto>> getRecordsByCampaign(String campaignId) async {
    final db = await AppDatabase.instance.db;
    final maps = await db.query('health_records', where: 'campaign_id = ?', whereArgs: [campaignId]);
    return maps.map((map) => HealthRecordDto.fromMap(map)).toList();
  }

  @override
  Future<HealthRecordDto?> getRecord(String studentId, String campaignId) async {
    final db = await AppDatabase.instance.db;
    final maps = await db.query(
        'health_records',
        where: 'student_id = ? AND campaign_id = ?',
        whereArgs: [studentId, campaignId]
    );
    if (maps.isNotEmpty) {
      return HealthRecordDto.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<HealthRecordDto> saveOrUpdateRecord(UpdateInsertHealthRecordRequestDto request) async {
    final db = await AppDatabase.instance.db;

    // ConflictAlgorithm.replace: Tự động ghi đè lên dòng cũ nếu bị trùng cặp (student_id, campaign_id)
    await db.insert(
        'health_records',
        request.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );

    // Tạo giả một DTO để trả về cho logic tầng trên nếu cần
    return HealthRecordDto(
        studentId: request.studentId,
        campaignId: request.campaignId,
        physical: request.physical,
        vision: request.vision,
        bloodPressure: request.bloodPressure,
        general: request.general,
        completedStations: request.completedStations
    );
  }
}