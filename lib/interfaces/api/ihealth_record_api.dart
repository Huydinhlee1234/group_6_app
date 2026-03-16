// lib/interfaces/api/ihealth_record_api.dart


import '../../data/dtos/health_record/health_record_dto.dart';
import '../../domain/entities/health_record.dart';

abstract class IHealthRecordApi {
  Future<List<HealthRecordDto>> getAllRecords(); // ✨ THÊM HÀM NÀY
  Future<List<HealthRecord>> getRecordsByCampaign(String campaignId);
  Future<HealthRecord?> getRecord(String studentId, String campaignId);
  Future<HealthRecord> saveOrUpdateRecord(HealthRecord record);
}

