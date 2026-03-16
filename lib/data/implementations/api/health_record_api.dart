import 'package:sqflite/sqflite.dart';

import '../../../domain/entities/health_record.dart';
import '../../../interfaces/api/ihealth_record_api.dart';
import '../../dtos/health_record/health_record_dto.dart';
import '../local/app_database.dart';
import '../mapper/health_record_mapper.dart';


class HealthRecordApi implements IHealthRecordApi {
  final _fromDto = HealthRecordFromDtoMapper();
  final _toDto = HealthRecordToDtoMapper();

  @override
  Future<List<HealthRecord>> getRecordsByCampaign(String campaignId) async {
    final db = await AppDatabase.instance.db;
    final maps = await db.query('health_records', where: 'campaign_id = ?', whereArgs: [campaignId]);
    return maps.map((map) => _fromDto.map(HealthRecordDto.fromMap(map))).toList();
  }

  @override
  Future<HealthRecord?> getRecord(String studentId, String campaignId) async {
    final db = await AppDatabase.instance.db;
    final maps = await db.query('health_records', where: 'student_id = ? AND campaign_id = ?', whereArgs: [studentId, campaignId]);
    if (maps.isNotEmpty) {
      return _fromDto.map(HealthRecordDto.fromMap(maps.first));
    }
    return null;
  }

  @override
  Future<HealthRecord> saveOrUpdateRecord(HealthRecord record) async {
    final db = await AppDatabase.instance.db;
    await db.insert('health_records', _toDto.map(record).toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return record;
  }

  @override
  Future<List<HealthRecordDto>> getAllRecords() async {
    final db = await AppDatabase.instance.db;
    final List<Map<String, dynamic>> maps = await db.query('health_records');

    // ✨ FIX LỖI: Sửa fromJson thành fromMap cho đồng bộ với các hàm trên
    return maps.map((e) => HealthRecordDto.fromMap(e)).toList();
  }
}