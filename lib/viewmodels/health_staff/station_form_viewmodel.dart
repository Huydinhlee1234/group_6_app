import 'package:flutter/material.dart';
import '../../domain/entities/health_record.dart';
import '../../domain/entities/student.dart';
import '../../interfaces/repositories/ihealth_record_repository.dart';
import '../../interfaces/repositories/istudent_repository.dart';

class StationFormViewModel extends ChangeNotifier {
  final IHealthRecordRepository _recordRepo;
  final IStudentRepository _studentRepo;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  StationFormViewModel(this._recordRepo, this._studentRepo);

  Future<bool> saveRecord(HealthRecord record, Student student) async {
    _isLoading = true; notifyListeners();
    try {
      // 1. Lưu Record (Sử dụng UPSERT trong API)
      // ✨ ĐÃ SỬA: Gọi đúng tên hàm saveOrUpdateRecord từ Repository
      await _recordRepo.saveOrUpdateRecord(record);

      // 2. Kiểm tra nếu đủ 4 trạm thì cập nhật trạng thái sinh viên
      if (record.completedStations.length == 4 && student.status != 'completed') {
        await _studentRepo.updateStudent(Student(
            id: student.id,
            campaignId: student.campaignId,
            studentCode: student.studentCode,
            name: student.name,
            className: student.className,
            email: student.email,
            status: 'completed'
        ));
      } else if (student.status == 'not_started') {
        await _studentRepo.updateStudent(Student(
            id: student.id,
            campaignId: student.campaignId,
            studentCode: student.studentCode,
            name: student.name,
            className: student.className,
            email: student.email,
            status: 'in_progress'
        ));
      }
      return true;
    } catch (e) {
      debugPrint("Lỗi lưu hồ sơ: $e");
      return false;
    } finally {
      _isLoading = false; notifyListeners();
    }
  }
}