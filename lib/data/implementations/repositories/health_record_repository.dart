import '../../../domain/entities/health_record.dart';
import '../../../interfaces/api/ihealth_record_api.dart';
import '../../../interfaces/repositories/ihealth_record_repository.dart';
import '../mapper/health_record_mapper.dart'; // ✨ THÊM DÒNG IMPORT NÀY

class HealthRecordRepository implements IHealthRecordRepository {
  final IHealthRecordApi _api;
  final _fromDto = HealthRecordFromDtoMapper(); // ✨ KHỞI TẠO MAPPER CHO GIỐNG BÊN API

  HealthRecordRepository(this._api);

  @override
  Future<List<HealthRecord>> getRecordsByCampaign(String campaignId) => _api.getRecordsByCampaign(campaignId);

  @override
  Future<HealthRecord?> getRecord(String studentId, String campaignId) => _api.getRecord(studentId, campaignId);

  @override
  Future<HealthRecord> saveOrUpdateRecord(HealthRecord record) => _api.saveOrUpdateRecord(record);

  @override
  Future<List<HealthRecord>> getAllRecords() async {
    final dtos = await _api.getAllRecords();

    // ✨ SỬA LẠI CÁCH GỌI MAPPER CHO KHỚP VỚI HÀM CỦA BẠN
    return dtos.map((dto) => _fromDto.map(dto)).toList();
  }
}