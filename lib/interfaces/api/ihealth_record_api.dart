import '../../data/dtos/health_record/health_record_dto.dart';
import '../../data/dtos/health_record/update_insert_health_record_request_dto.dart';

abstract class IHealthRecordApi {
  Future<List<HealthRecordDto>> getAllRecords();
  Future<List<HealthRecordDto>> getRecordsByCampaign(String campaignId);
  Future<HealthRecordDto?> getRecord(String studentId, String campaignId);
  Future<HealthRecordDto> saveOrUpdateRecord(UpdateInsertHealthRecordRequestDto request);
}