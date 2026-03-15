// lib/interfaces/api/ihealth_record_api.dart


import '../../domain/entities/health_record.dart';

abstract class IHealthRecordApi {
  Future<List<HealthRecord>> getRecordsByCampaign(String campaignId);
  Future<HealthRecord?> getRecord(String studentId, String campaignId);
  Future<HealthRecord> saveOrUpdateRecord(HealthRecord record);
}

