import '../../../domain/entities/health_record.dart';
import '../../../interfaces/api/ihealth_record_api.dart';
import '../../../interfaces/repositories/ihealth_record_repository.dart';

class HealthRecordRepository implements IHealthRecordRepository {
  final IHealthRecordApi _api;

  // BẠN ĐANG THIẾU DÒNG DƯỚI NÀY NÊN NÓ BÁO ĐỎ Ở DI.DART
  HealthRecordRepository(this._api);

  @override
  Future<List<HealthRecord>> getRecordsByCampaign(String campaignId) => _api.getRecordsByCampaign(campaignId);

  @override
  Future<HealthRecord?> getRecord(String studentId, String campaignId) => _api.getRecord(studentId, campaignId);

  @override
  Future<HealthRecord> saveOrUpdateRecord(HealthRecord record) => _api.saveOrUpdateRecord(record);
}