import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/campaign.dart';
import '../../domain/entities/student.dart';
import '../../domain/entities/health_record.dart'; // ✨ THÊM: Để lấy số liệu khám thực tế
import '../../interfaces/repositories/istudent_repository.dart';
import '../../interfaces/repositories/ihealth_record_repository.dart';
import '../../interfaces/repositories/icampaign_repository.dart';

class StudentManagementViewModel extends ChangeNotifier {
  final IStudentRepository _studentRepo;
  final IHealthRecordRepository _recordRepo;
  final ICampaignRepository _campaignRepo;

  List<Student> _allStudents = [];
  List<Campaign> _campaigns = [];
  List<HealthRecord> _healthRecords = []; // ✨ Thay thế Map giả bằng dữ liệu thật

  bool _isLoading = false;
  String _error = '';
  String _searchTerm = '';

  // --- BIẾN LƯU TRẠNG THÁI DROPDOWN ---
  String _tempClassFilter = 'all';
  String _tempCampaignFilter = 'all';

  // --- BIẾN LƯU TRẠNG THÁI SAU KHI BẤM "LỌC" ---
  String _appliedClassFilter = 'all';
  String _appliedCampaignFilter = 'all';

  StudentManagementViewModel(this._studentRepo, this._recordRepo, this._campaignRepo) {
    loadData();
  }

  // --- GETTERS ---
  bool get isLoading => _isLoading;
  String get error => _error;
  List<Campaign> get campaigns => _campaigns;

  List<String> get availableClasses {
    return _allStudents.map((s) => s.className.trim()).toSet().toList()..sort();
  }

  String get tempClassFilter {
    if (_tempClassFilter != 'all' && !availableClasses.contains(_tempClassFilter)) return 'all';
    return _tempClassFilter;
  }

  String get tempCampaignFilter {
    if (_tempCampaignFilter != 'all' && !_campaigns.any((c) => c.id == _tempCampaignFilter)) return 'all';
    return _tempCampaignFilter;
  }

  // ✨ Lọc danh sách sinh viên: TÌM KIẾM ĐƯỢC CẢ EMAIL
  List<Student> get filteredStudents {
    return _allStudents.where((s) {
      final matchSearch = s.name.toLowerCase().contains(_searchTerm.toLowerCase()) ||
          s.studentCode.toLowerCase().contains(_searchTerm.toLowerCase()) ||
          s.email.toLowerCase().contains(_searchTerm.toLowerCase()); // Bổ sung tìm bằng email

      final matchClass = _appliedClassFilter == 'all' || s.className.trim() == _appliedClassFilter;
      final matchCampaign = _appliedCampaignFilter == 'all' || s.campaignId == _appliedCampaignFilter;

      return matchSearch && matchClass && matchCampaign;
    }).toList();
  }

  // --- THỐNG KÊ ---
  int get totalStudents => filteredStudents.length;
  int get completedStudents => filteredStudents.where((s) => s.status == 'completed').length;
  int get inProgressStudents => filteredStudents.where((s) => s.status == 'in_progress').length;
  int get notStartedStudents => filteredStudents.where((s) => s.status == 'not_started' || s.status == 'pending').length;
  int get completionRate => totalStudents > 0 ? ((completedStudents / totalStudents) * 100).round() : 0;

  // ✨ ĐẾM SỐ TRẠM ĐÃ KHÁM THẬT (Từ bảng Health Records thay vì dùng Map ảo)
  int getCompletedStationsCount(String studentId) {
    try {
      final record = _healthRecords.firstWhere((r) => r.studentId == studentId);
      return record.completedStations.length;
    } catch (_) {
      return 0;
    }
  }

  // --- SETTERS CHO UI ---
  void setSearchTerm(String term) {
    _searchTerm = term;
    // Nếu bạn muốn gõ chữ tới đâu list filter tới đó thì gọi applyFiltersInternal ở đây.
    // Hiện tại đang chờ bấm nút "Lọc" mới chạy.
    notifyListeners();
  }

  void setTempClassFilter(String className) {
    _tempClassFilter = className;
    notifyListeners();
  }

  void setTempCampaignFilter(String campId) {
    _tempCampaignFilter = campId;
    notifyListeners();
  }

  // Hàm áp dụng Lọc
  Future<void> applyFilters() async {
    _appliedClassFilter = _tempClassFilter;
    _appliedCampaignFilter = _tempCampaignFilter;
    notifyListeners();
  }

  // --- TƯƠNG TÁC DATABASE ---
  Future<void> loadData() async {
    _isLoading = true; notifyListeners();
    try {
      final results = await Future.wait([
        _studentRepo.getAllStudents(),
        _campaignRepo.getAllCampaigns(),
        _recordRepo.getAllRecords(), // ✨ Tải hồ sơ khám sức khỏe thật
      ]);

      _allStudents = results[0] as List<Student>;
      _campaigns = results[1] as List<Campaign>;
      _healthRecords = results[2] as List<HealthRecord>;

    } catch (e) {
      _error = 'Lỗi tải danh sách: $e';
    } finally {
      _isLoading = false; notifyListeners();
    }
  }

  Future<bool> createStudent(Student student) async {
    _isLoading = true; notifyListeners();
    try {
      await _studentRepo.createStudent(student);
      await loadData();
      return true;
    } catch (e) {
      _error = e.toString(); return false;
    }
  }

  Future<bool> updateStudent(Student student) async {
    _isLoading = true; notifyListeners();
    try {
      await _studentRepo.updateStudent(student);
      await loadData();
      return true;
    } catch (e) {
      _error = e.toString(); return false;
    }
  }

  Future<bool> deleteStudent(String id) async {
    _isLoading = true; notifyListeners();
    try {
      await _studentRepo.deleteStudent(id);
      await loadData();
      return true;
    } catch (e) {
      _error = e.toString(); return false;
    }
  }

  // --- IMPORT HÀNG LOẠT ---
  // ✨ CẬP NHẬT: Nhận targetCampaignId từ UI và lưu Email vào Database
  Future<bool> importStudents(String targetCampaignId, List<Map<String, dynamic>> importedData) async {
    _isLoading = true;
    notifyListeners();

    try {
      List<Student> studentsToImport = [];

      for (var data in importedData) {
        final newStudent = Student(
          id: const Uuid().v4(),
          campaignId: targetCampaignId, // Sử dụng ID chiến dịch do người dùng chọn trong Dialog
          studentCode: data['studentCode'] ?? '',
          name: data['name'] ?? '',
          className: data['className'] ?? '',
          email: data['email'] ?? '', // ✨ Lưu địa chỉ Email
          status: 'not_started',
        );
        studentsToImport.add(newStudent);
      }

      // ✨ GỌI HÀM BATCH INSERT TỐI ƯU CỦA REPOSITORY
      await _studentRepo.importStudents(studentsToImport);

      await loadData();
      return true;

    } catch (e) {
      _error = 'Lỗi khi import dữ liệu vào Database: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}