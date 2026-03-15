// import 'package:flutter/material.dart';
// import '../../domain/entities/campaign.dart';
// import '../../domain/entities/health_record.dart';
// import '../../domain/entities/student.dart';
// import '../../interfaces/repositories/icampaign_repository.dart';
// import '../../interfaces/repositories/istudent_repository.dart';
// import '../../interfaces/repositories/ihealth_record_repository.dart';
//
// class ReportsViewModel extends ChangeNotifier {
//   final ICampaignRepository _campaignRepo;
//   final IStudentRepository _studentRepo;
//   final IHealthRecordRepository _recordRepo;
//
//   List<Campaign> _campaigns = [];
//   List<Student> _students = [];
//   List<HealthRecord> _healthRecords = [];
//
//   String _selectedCampaignId = '';
//   String _selectedClass = 'all';
//   bool _isLoading = true;
//
//   ReportsViewModel(this._campaignRepo, this._studentRepo, this._recordRepo) {
//     _loadData();
//   }
//
//   bool get isLoading => _isLoading;
//   String get selectedCampaignId => _selectedCampaignId;
//   String get selectedClass => _selectedClass;
//   List<Campaign> get campaigns => _campaigns;
//
//   Future<void> _loadData() async {
//     _isLoading = true;
//     notifyListeners();
//
//     final results = await Future.wait([
//       _campaignRepo.getAllCampaigns(),
//       _studentRepo.getAllStudents(),
//     ]);
//
//     _campaigns = results[0] as List<Campaign>;
//     _students = results[1] as List<Student>;
//
//     if (_campaigns.isNotEmpty) {
//       _selectedCampaignId = _campaigns.first.id;
//       _healthRecords = await _recordRepo.getRecordsByCampaign(_selectedCampaignId);
//     }
//
//     _isLoading = false;
//     notifyListeners();
//   }
//
//   Future<void> setCampaignId(String id) async {
//     if (_selectedCampaignId == id) return;
//     _selectedCampaignId = id;
//
//     _isLoading = true;
//     notifyListeners();
//
//     _healthRecords = await _recordRepo.getRecordsByCampaign(id);
//
//     _isLoading = false;
//     notifyListeners();
//   }
//
//   void setSelectedClass(String className) {
//     _selectedClass = className;
//     notifyListeners();
//   }
//
//   List<String> get availableClasses {
//     final classes = _students.map((s) => s.className).toSet().toList();
//     classes.sort();
//     return classes;
//   }
//
//   Map<String, dynamic>? get bmiStats {
//     if (_isLoading || _selectedCampaignId.isEmpty) return null;
//
//     final completedStudentIds = _healthRecords
//         .where((r) => r.completedStations.length == 4)
//         .map((r) => r.studentId)
//         .toList();
//
//     final filteredStudents = _students.where((s) {
//       final isCompleted = completedStudentIds.contains(s.id);
//       final matchesClass = _selectedClass == 'all' || s.className == _selectedClass;
//       return isCompleted && matchesClass;
//     }).toList();
//
//     final completedRecords = _healthRecords.where((r) =>
//     r.completedStations.length == 4 &&
//         r.physical != null &&
//         filteredStudents.any((s) => s.id == r.studentId)
//     ).toList();
//
//     final total = completedRecords.length;
//     if (total == 0) return null;
//
//     int underweight = 0, normal = 0, overweight = 0, obese = 0;
//
//     for (var r in completedRecords) {
//       final category = r.physical?['bmiCategory'] as String?;
//       if (category == 'underweight') underweight++;
//       else if (category == 'normal') normal++;
//       else if (category == 'overweight') overweight++;
//       else if (category == 'obese') obese++;
//     }
//
//     return {
//       'total': total,
//       'underweight': underweight,
//       'normal': normal,
//       'overweight': overweight,
//       'obese': obese,
//       'underweightPercent': (underweight / total) * 100,
//       'normalPercent': (normal / total) * 100,
//       'overweightPercent': (overweight / total) * 100,
//       'obesePercent': (obese / total) * 100,
//     };
//   }
// }

import 'package:flutter/material.dart';
import '../../domain/entities/campaign.dart';
import '../../domain/entities/health_record.dart';
import '../../domain/entities/student.dart';
import '../../interfaces/repositories/icampaign_repository.dart';
import '../../interfaces/repositories/istudent_repository.dart';
import '../../interfaces/repositories/ihealth_record_repository.dart';
import '../../utils/report_exporter.dart';

class ReportsViewModel extends ChangeNotifier {
  final ICampaignRepository _campaignRepo;
  final IStudentRepository _studentRepo;
  final IHealthRecordRepository _recordRepo;

  List<Campaign> _campaigns = [];
  List<Student> _students = [];
  List<HealthRecord> _healthRecords = [];

  String _selectedCampaignId = '';
  String _selectedClass = 'all';
  bool _isLoading = true;

  ReportsViewModel(this._campaignRepo, this._studentRepo, this._recordRepo) {
    _loadData();
  }

  bool get isLoading => _isLoading;
  String get selectedCampaignId => _selectedCampaignId;
  String get selectedClass => _selectedClass;
  List<Campaign> get campaigns => _campaigns;

  Future<void> _loadData() async {
    _isLoading = true;
    notifyListeners();

    final results = await Future.wait([
      _campaignRepo.getAllCampaigns(),
      _studentRepo.getAllStudents(),
    ]);

    _campaigns = results[0] as List<Campaign>;
    _students = results[1] as List<Student>;

    if (_campaigns.isNotEmpty) {
      _selectedCampaignId = _campaigns.first.id;
      _healthRecords = await _recordRepo.getRecordsByCampaign(_selectedCampaignId);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> setCampaignId(String id) async {
    if (_selectedCampaignId == id) return;
    _selectedCampaignId = id;
    _selectedClass = 'all'; // Reset lại bộ lọc lớp khi đổi chiến dịch

    _isLoading = true;
    notifyListeners();

    _healthRecords = await _recordRepo.getRecordsByCampaign(id);

    _isLoading = false;
    notifyListeners();
  }

  void setSelectedClass(String className) {
    _selectedClass = className;
    notifyListeners();
  }

  // ✨ 1. Tính năng: Tạo (Làm mới) Báo cáo
  Future<void> refreshReport(BuildContext context) async {
    await _loadData(); // Tải lại data mới nhất từ DB
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã cập nhật dữ liệu báo cáo mới nhất!'), backgroundColor: Colors.green),
      );
    }
  }

  // ✨ CẬP NHẬT: Xuất PDF nhận tham số Title và Notes
  Future<void> exportToPdf(BuildContext context, String title, String notes) async {
    final stats = bmiStats;
    if (stats == null) return;

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đang tạo file PDF...')));
    try {
      await ReportExporter.exportPdf(stats, classCompletionStats, title, notes);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi xuất PDF: $e'), backgroundColor: Colors.red));
      }
    }
  }

  // ✨ CẬP NHẬT: Xuất Excel nhận tham số Title và Notes
  Future<void> exportToExcel(BuildContext context, String title, String notes) async {
    final stats = bmiStats;
    if (stats == null) return;

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đang tạo file Excel...')));
    try {
      await ReportExporter.exportExcel(stats, classCompletionStats, title, notes);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi xuất Excel: $e'), backgroundColor: Colors.red));
      }
    }
  }

  // ✨ ĐÃ TỐI ƯU: Chỉ lấy danh sách lớp của những sinh viên trong Chiến dịch đang chọn
  List<String> get availableClasses {
    if (_selectedCampaignId.isEmpty) return [];

    final classes = _students
        .where((s) => s.campaignId == _selectedCampaignId)
        .map((s) => s.className)
        .toSet()
        .toList();
    classes.sort();
    return classes;
  }

  // ✨ BỔ SUNG MỚI: Dữ liệu động cho biểu đồ Hoàn thành theo lớp
  Map<String, int> get classCompletionStats {
    if (_isLoading || _selectedCampaignId.isEmpty) return {};

    Map<String, int> stats = {};

    // 1. Lấy ID của các sinh viên đã khám đủ 4 trạm trong chiến dịch này
    final completedStudentIds = _healthRecords
        .where((r) => r.completedStations.length == 4)
        .map((r) => r.studentId)
        .toSet(); // Dùng Set để tra cứu cho nhanh

    // 2. Lặp qua danh sách sinh viên để đếm số lượng hoàn thành theo từng lớp
    for (var student in _students) {
      // Đảm bảo sinh viên thuộc chiến dịch hiện tại
      if (student.campaignId == _selectedCampaignId && completedStudentIds.contains(student.id)) {

        // Nếu người dùng đang dùng bộ lọc lớp, ta chỉ trả về dữ liệu của lớp đó
        if (_selectedClass == 'all' || student.className == _selectedClass) {
          stats[student.className] = (stats[student.className] ?? 0) + 1;
        }
      }
    }

    return stats;
  }

  Map<String, dynamic>? get bmiStats {
    if (_isLoading || _selectedCampaignId.isEmpty) return null;

    final completedStudentIds = _healthRecords
        .where((r) => r.completedStations.length == 4)
        .map((r) => r.studentId)
        .toList();

    final filteredStudents = _students.where((s) {
      final isCompleted = completedStudentIds.contains(s.id);
      final matchesClass = _selectedClass == 'all' || s.className == _selectedClass;
      return isCompleted && matchesClass;
    }).toList();

    final completedRecords = _healthRecords.where((r) =>
    r.completedStations.length == 4 &&
        r.physical != null &&
        filteredStudents.any((s) => s.id == r.studentId)
    ).toList();

    final total = completedRecords.length;
    if (total == 0) return null;

    int underweight = 0, normal = 0, overweight = 0, obese = 0;

    for (var r in completedRecords) {
      final category = r.physical?['bmiCategory'] as String?;
      if (category == 'underweight') underweight++;
      else if (category == 'normal') normal++;
      else if (category == 'overweight') overweight++;
      else if (category == 'obese') obese++;
    }

    return {
      'total': total,
      'underweight': underweight,
      'normal': normal,
      'overweight': overweight,
      'obese': obese,
      'underweightPercent': (underweight / total) * 100,
      'normalPercent': (normal / total) * 100,
      'overweightPercent': (overweight / total) * 100,
      'obesePercent': (obese / total) * 100,
    };
  }
}