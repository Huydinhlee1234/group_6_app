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

  Future<void> refreshReport(BuildContext context) async {
    await _loadData();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã cập nhật dữ liệu báo cáo mới nhất!'), backgroundColor: Colors.green),
      );
    }
  }

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

  Map<String, int> get classCompletionStats {
    if (_isLoading || _selectedCampaignId.isEmpty) return {};

    Map<String, int> stats = {};

    final completedStudentIds = _healthRecords
        .where((r) => r.completedStations.length == 4)
        .map((r) => r.studentId)
        .toSet();

    for (var student in _students) {
      if (student.campaignId == _selectedCampaignId && completedStudentIds.contains(student.id)) {
        if (_selectedClass == 'all' || student.className == _selectedClass) {
          stats[student.className] = (stats[student.className] ?? 0) + 1;
        }
      }
    }

    return stats;
  }

  // ✨ ĐÂY LÀ HÀM MỚI BỔ SUNG ĐỂ TÍNH TOÁN DỮ LIỆU CHO 5 THẺ STATS CỦA BẠN
  Map<String, dynamic> get overviewStats {
    if (_isLoading || _selectedCampaignId.isEmpty) {
      return {'total': 0, 'high_bp': 0, 'low_bp': 0, 'poor_vision': 0, 'poor_health': 0};
    }

    int totalCompleted = 0;
    int highBpCount = 0;
    int lowBpCount = 0;
    int poorVisionCount = 0;
    int poorHealthCount = 0;

    // 1. Lọc danh sách ID sinh viên thuộc Chiến dịch và Lớp đang chọn
    final validStudentIds = _students.where((s) {
      final matchesCamp = s.campaignId == _selectedCampaignId;
      final matchesClass = _selectedClass == 'all' || s.className == _selectedClass;
      return matchesCamp && matchesClass;
    }).map((s) => s.id).toSet();

    // 2. Chỉ lấy những hồ sơ khám của sinh viên hợp lệ
    final validRecords = _healthRecords.where((r) => validStudentIds.contains(r.studentId));

    for (var record in validRecords) {
      // 1. Đếm Hoàn thành
      if (record.completedStations.length == 4) totalCompleted++;

      // 2. Phân tích Huyết áp
      if (record.bloodPressure != null) {
        final sysRaw = record.bloodPressure!['systolic'];
        final diaRaw = record.bloodPressure!['diastolic'];
        if (sysRaw != null && diaRaw != null) {
          int sys = sysRaw is int ? sysRaw : int.tryParse(sysRaw.toString()) ?? 0;
          int dia = diaRaw is int ? diaRaw : int.tryParse(diaRaw.toString()) ?? 0;

          if (sys >= 140 || dia >= 90) {
            highBpCount++;
          } else if (sys <= 90 || dia <= 60 && sys > 0) {
            lowBpCount++;
          }
        }
      }

      // 3. Phân tích Thị lực
      if (record.vision != null) {
        try {
          String leftStr = record.vision!['leftEye']?.toString() ?? '';
          String rightStr = record.vision!['rightEye']?.toString() ?? '';

          double? parseVision(String val) {
            if (val.isEmpty) return null;
            String clean = val.split('/').first.replaceAll(',', '.').trim();
            return double.tryParse(clean);
          }

          double? left = parseVision(leftStr);
          double? right = parseVision(rightStr);

          if (left != null && right != null) {
            double minVision = left < right ? left : right;
            if (minVision < 4.0) poorVisionCount++; // Chuẩn WHO: < 4/10 là giảm thị lực vừa/nặng
          }
        } catch (_) {}
      }

      // 4. Phân tích Thể trạng (Kém/TB = Thiếu cân hoặc Béo phì)
      if (record.physical != null) {
        final bmiRaw = record.physical!['bmi'];
        if (bmiRaw != null) {
          double bmi = bmiRaw is double ? bmiRaw : double.tryParse(bmiRaw.toString()) ?? 0;
          // Chuẩn Châu Á: Dưới 18.5 là Gầy, 25 trở lên là Béo phì
          if (bmi > 0 && (bmi < 18.5 || bmi >= 25.0)) {
            poorHealthCount++;
          }
        }
      }
    }

    return {
      'total': totalCompleted,
      'high_bp': highBpCount,
      'low_bp': lowBpCount,
      'poor_vision': poorVisionCount,
      'poor_health': poorHealthCount,
    };
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

    int underweight = 0, normal = 0, overweight = 0, obese1 = 0, obese2 = 0;

    for (var r in completedRecords) {
      final category = r.physical?['bmiCategory'] as String?;
      if (category == 'underweight') underweight++;
      else if (category == 'normal') normal++;
      else if (category == 'overweight') overweight++;
      else if (category == 'obese_1' || category == 'obese') obese1++;
      else if (category == 'obese_2') obese2++;
    }

    // ✨ TÍNH TỔNG BÉO PHÌ ĐỂ FIX LỖI CHO FILE XUẤT BÁO CÁO CŨ
    int totalObese = obese1 + obese2;

    return {
      'total': total,
      'underweight': underweight,
      'normal': normal,
      'overweight': overweight,
      'obese_1': obese1,
      'obese_2': obese2,

      // ✨ THÊM LẠI 2 BIẾN NÀY ĐỂ PDF VÀ EXCEL KHÔNG BỊ CRASH NỮA
      'obese': totalObese,
      'obesePercent': (totalObese / total) * 100,
      'underweightPercent': (underweight / total) * 100,
      'normalPercent': (normal / total) * 100,
      'overweightPercent': (overweight / total) * 100,
      'obese1Percent': (obese1 / total) * 100,
      'obese2Percent': (obese2 / total) * 100,
    };
  }
}