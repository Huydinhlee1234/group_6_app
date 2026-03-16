import '../../domain/entities/health_record.dart';

abstract class IHealthRecordRepository {
  Future<List<HealthRecord>> getAllRecords();
  Future<List<HealthRecord>> getRecordsByCampaign(String campaignId);
  Future<HealthRecord?> getRecord(String studentId, String campaignId);
  Future<HealthRecord> saveOrUpdateRecord(HealthRecord record);
}