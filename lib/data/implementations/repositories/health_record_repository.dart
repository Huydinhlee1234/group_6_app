import '../../../domain/entities/health_record.dart';
import '../../../interfaces/api/ihealth_record_api.dart';
import '../../../interfaces/repositories/ihealth_record_repository.dart';
import '../mapper/health_record_mapper.dart';

class HealthRecordRepository implements IHealthRecordRepository {
  final IHealthRecordApi _api;

  HealthRecordRepository(this._api);

  @override
  Future<List<HealthRecord>> getAllRecords() async {
    final dtos = await _api.getAllRecords();
    return dtos.map((dto) => HealthRecordMapper.toEntity(dto)).toList();
  }

  @override
  Future<List<HealthRecord>> getRecordsByCampaign(String campaignId) async {
    final dtos = await _api.getRecordsByCampaign(campaignId);
    return dtos.map((dto) => HealthRecordMapper.toEntity(dto)).toList();
  }

  @override
  Future<HealthRecord?> getRecord(String studentId, String campaignId) async {
    final dto = await _api.getRecord(studentId, campaignId);
    if (dto != null) {
      return HealthRecordMapper.toEntity(dto);
    }
    return null;
  }

  @override
  Future<HealthRecord> saveOrUpdateRecord(HealthRecord record) async {
    final requestDto = HealthRecordMapper.toInsertRequest(record);
    final responseDto = await _api.saveOrUpdateRecord(requestDto);
    return HealthRecordMapper.toEntity(responseDto);
  }
}