import 'package:flutter/material.dart';
import '../../domain/entities/health_record.dart';
// ✨ Import thêm các class bị thiếu
import '../../domain/entities/student.dart';
import '../../interfaces/repositories/ihealth_record_repository.dart';
import '../../interfaces/repositories/istudent_repository.dart';

class HealthStaffDashboardViewModel extends ChangeNotifier {
  // ✨ Khai báo đủ 2 Repository cần thiết
  final IHealthRecordRepository _recordRepo;
  final IStudentRepository _studentRepo;

  String? _selectedCampaignId;
  String? _selectedStationId;
  String? _selectedStudentId;

  // ✨ Khai báo các biến dữ liệu đang bị báo đỏ (Undefined name)
  bool _isLoading = false;
  List<HealthRecord> _healthRecords = [];
  List<Student> _students = [];

  // ✨ Cập nhật Constructor để nhận cả 2 Repo
  HealthStaffDashboardViewModel(this._recordRepo, this._studentRepo);

  // Getters
  String? get selectedCampaignId => _selectedCampaignId;
  String? get selectedStationId => _selectedStationId;
  String? get selectedStudentId => _selectedStudentId;
  bool get isLoading => _isLoading;

  // Logic chọn Trạm khám
  void handleStationSelect(String campaignId, String stationId) {
    _selectedCampaignId = campaignId;
    _selectedStationId = stationId;
    notifyListeners();
  }

  // Logic chọn Sinh viên
  void handleStudentSelect(String studentId) {
    _selectedStudentId = studentId;
    notifyListeners();
  }

  // Nút quay lại: Từ Form khám -> Danh sách Sinh viên
  void handleBackToCheckIn() {
    _selectedStudentId = null;
    notifyListeners();
  }

  // Nút quay lại: Từ Danh sách sinh viên -> Chọn Trạm khám
  void handleBackToStationSelection() {
    _selectedCampaignId = null;
    _selectedStationId = null;
    _selectedStudentId = null;
    notifyListeners();
  }

  // Lưu form và tự động quay lại màn check-in để làm sinh viên tiếp theo
  void handleSaveAndNext() {
    // TODO: Gọi repository để lưu HealthRecord tại đây
    _selectedStudentId = null;
    notifyListeners();
  }

  // ✨ BỔ SUNG HÀM LƯU KẾT QUẢ KHÁM (Đã hết đỏ)
  Future<bool> saveRecord(HealthRecord record) async {
    _isLoading = true; notifyListeners();
    try {
      // Dùng hàm saveOrUpdateRecord đã được thống nhất
      await _recordRepo.saveOrUpdateRecord(record);

      // Tải lại dữ liệu để UI cập nhật trạng thái
      if (selectedCampaignId != null) {
        _healthRecords = await _recordRepo.getRecordsByCampaign(selectedCampaignId!);

        // Kiểm tra xem sinh viên đã khám đủ 4 trạm chưa để chuyển status sang 'completed'
        final isAllCompleted = record.completedStations.length == 4;
        if (isAllCompleted) {
          // Lưu ý: Đảm bảo _students đã được load danh sách trước đó nhé!
          final student = _students.firstWhere((s) => s.id == record.studentId);
          await _studentRepo.updateStudent(Student(
              id: student.id,
              campaignId: student.campaignId,
              studentCode: student.studentCode,
              name: student.name,
              className: student.className,
              email: student.email,
              status: 'completed' // Đã khám xong
          ));
          _students = await _studentRepo.getAllStudents(); // Cập nhật lại list
        }
      }
      return true;
    } catch (e) {
      debugPrint("Lỗi lưu bệnh án: $e");
      return false;
    } finally {
      _isLoading = false; notifyListeners();
    }
  }
}