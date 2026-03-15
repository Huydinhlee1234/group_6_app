import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart'; // ✨ ĐÃ THÊM: Import thư viện Uuid
import '../../domain/entities/campaign.dart';
import '../../domain/entities/student.dart';
import '../../interfaces/repositories/istudent_repository.dart';
import '../../interfaces/repositories/ihealth_record_repository.dart';
import '../../interfaces/repositories/icampaign_repository.dart';

class StudentManagementViewModel extends ChangeNotifier {
  final IStudentRepository _studentRepo;
  final IHealthRecordRepository _recordRepo;
  final ICampaignRepository _campaignRepo;

  List<Student> _students = [];
  List<Campaign> _campaigns = [];
  Map<String, int> _completedStationsMap = {};

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

  String get tempClassFilter {
    if (_tempClassFilter != 'all' && !availableClasses.contains(_tempClassFilter)) return 'all';
    return _tempClassFilter;
  }

  String get tempCampaignFilter {
    if (_tempCampaignFilter != 'all' && !_campaigns.any((c) => c.id == _tempCampaignFilter)) return 'all';
    return _tempCampaignFilter;
  }

  List<String> get availableClasses {
    return _students.map((s) => s.className.trim()).toSet().toList()..sort();
  }

  // ✨ ĐÃ SỬA: Lọc danh sách sinh viên TRỰC TIẾP bằng s.campaignId
  List<Student> get filteredStudents {
    return _students.where((s) {
      final matchSearch = s.name.toLowerCase().contains(_searchTerm.toLowerCase()) ||
          s.studentCode.toLowerCase().contains(_searchTerm.toLowerCase());

      final matchClass = _appliedClassFilter == 'all' || s.className.trim() == _appliedClassFilter;

      // Kiểm tra trực tiếp ID chiến dịch của sinh viên
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

  int getCompletedStationsCount(String studentId) => _completedStationsMap[studentId] ?? 0;

  // --- SETTERS CHO UI ---
  void setSearchTerm(String term) {
    _searchTerm = term;
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

  // ✨ ĐÃ SỬA: Hàm lọc trở nên siêu nhẹ, không cần query DB nữa
  Future<void> applyFilters() async {
    _appliedClassFilter = _tempClassFilter;
    _appliedCampaignFilter = _tempCampaignFilter;

    // Chỉ cần báo UI cập nhật lại danh sách là xong
    notifyListeners();
  }

  // --- TƯƠNG TÁC DATABASE ---
  Future<void> loadData() async {
    _isLoading = true; notifyListeners();
    try {
      final results = await Future.wait([
        _studentRepo.getAllStudents(),
        _campaignRepo.getAllCampaigns(),
      ]);
      _students = results[0] as List<Student>;
      _campaigns = results[1] as List<Campaign>;

      for (var s in _students) {
        if (s.status == 'completed') _completedStationsMap[s.id] = 4;
        else if (s.status == 'in_progress') _completedStationsMap[s.id] = 2;
        else _completedStationsMap[s.id] = 0;
      }
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
    try { await _studentRepo.updateStudent(student); await loadData(); return true; }
    catch (e) { _error = e.toString(); return false; }
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

  // --- THÊM HÀM MỚI NÀY VÀO CUỐI CLASS ---

  /// Hàm nhận dữ liệu từ hộp thoại Import Excel và đẩy vào Database
  Future<bool> importStudents(List<Map<String, dynamic>> importedData) async {
    // 1. Kiểm tra xem người dùng đã chọn chiến dịch để import vào chưa
    // Mặc định nếu đang chọn 'all' thì không cho import vì không biết nhét vào đâu
    if (_appliedCampaignFilter == 'all' || _appliedCampaignFilter.isEmpty) {
      _error = 'Vui lòng chọn cụ thể một Chiến dịch ở bộ lọc trước khi Import!';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      List<Student> studentsToImport = [];

      // 2. Chuyển đổi Map thành Entity Student
      for (var data in importedData) {
        final newStudent = Student(
          id: const Uuid().v4(), // ✨ ĐÃ SỬA: Xóa chữ const ở đây
          campaignId: _appliedCampaignFilter, // Nhét vào chiến dịch đang được lọc
          studentCode: data['studentCode'],
          name: data['name'],
          className: data['className'],
          status: 'not_started', // Mặc định sinh viên mới là chưa khám
        );
        studentsToImport.add(newStudent);
      }

      // 3. Gọi Repository để lưu hàng loạt (Batch Insert)
      await _studentRepo.importStudents(studentsToImport);

      // 4. Tải lại dữ liệu mới nhất từ DB lên màn hình
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