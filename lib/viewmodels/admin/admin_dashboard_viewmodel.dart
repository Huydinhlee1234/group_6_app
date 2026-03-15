import 'package:flutter/material.dart';
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
  Set<String> _currentCampaignStudentIds = {};

  bool _isLoading = false;
  String _error = '';
  String _searchTerm = '';

  // ✨ TRẠNG THÁI HIỂN THỊ TRÊN UI (DROPDOWN)
  String _tempClassFilter = 'all';
  String _tempCampaignFilter = 'all';

  // ✨ TRẠNG THÁI ÁP DỤNG THỰC TẾ (SAU KHI BẤM NÚT LỌC)
  String _appliedClassFilter = 'all';
  String _appliedCampaignFilter = 'all';

  StudentManagementViewModel(this._studentRepo, this._recordRepo, this._campaignRepo) {
    loadData();
  }

  // --- GETTERS ---
  bool get isLoading => _isLoading;
  String get error => _error;
  List<Campaign> get campaigns => _campaigns;

  // Lấy giá trị cho Dropdown Lớp
  String get tempClassFilter {
    if (_tempClassFilter != 'all' && !availableClasses.contains(_tempClassFilter)) return 'all';
    return _tempClassFilter;
  }

  // Lấy giá trị cho Dropdown Chiến dịch
  String get tempCampaignFilter {
    if (_tempCampaignFilter != 'all' && !_campaigns.any((c) => c.id == _tempCampaignFilter)) return 'all';
    return _tempCampaignFilter;
  }

  List<String> get availableClasses {
    return _students.map((s) => s.className.trim()).toSet().toList()..sort();
  }

  // Lọc danh sách sinh viên theo giá trị ĐÃ ÁP DỤNG
  List<Student> get filteredStudents {
    return _students.where((s) {
      final matchSearch = s.name.toLowerCase().contains(_searchTerm.toLowerCase()) ||
          s.studentCode.toLowerCase().contains(_searchTerm.toLowerCase());

      final matchClass = _appliedClassFilter == 'all' || s.className.trim() == _appliedClassFilter;
      final matchCampaign = _appliedCampaignFilter == 'all' || _currentCampaignStudentIds.contains(s.id);

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

  // --- SETTERS ---
  void setSearchTerm(String term) {
    _searchTerm = term;
    notifyListeners(); // Ô tìm kiếm text vẫn nhảy realtime cho mượt
  }

  void setTempClassFilter(String className) {
    _tempClassFilter = className;
    notifyListeners(); // Chỉ update giao diện Dropdown, chưa lọc danh sách
  }

  void setTempCampaignFilter(String campId) {
    _tempCampaignFilter = campId;
    notifyListeners(); // Chỉ update giao diện Dropdown, chưa lọc danh sách
  }

  // ✨ HÀM XỬ LÝ KHI BẤM NÚT "LỌC"
  Future<void> applyFilters() async {
    _appliedClassFilter = _tempClassFilter;
    _appliedCampaignFilter = _tempCampaignFilter;

    _isLoading = true;
    notifyListeners();

    // Nếu có chọn chiến dịch cụ thể thì load hồ sơ từ DB
    if (_appliedCampaignFilter != 'all') {
      try {
        final records = await _recordRepo.getRecordsByCampaign(_appliedCampaignFilter);
        _currentCampaignStudentIds = records.map((r) => r.studentId).toSet();
      } catch (e) {
        debugPrint('Lỗi tải records: $e');
      }
    } else {
      _currentCampaignStudentIds.clear();
    }

    _isLoading = false;
    notifyListeners(); // Update lại toàn bộ danh sách sinh viên
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
      // Nếu đang lọc chiến dịch, tự động đẩy sinh viên mới vào ds hiển thị
      if (_appliedCampaignFilter != 'all') {
        _currentCampaignStudentIds.add(student.id);
      }
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
      _currentCampaignStudentIds.remove(id);
      await loadData();
      return true;
    } catch (e) {
      _error = e.toString(); return false;
    }
  }
}