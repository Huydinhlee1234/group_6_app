import 'package:flutter/material.dart';
import '../../domain/entities/campaign.dart';
import '../../domain/entities/health_record.dart';
import '../../domain/entities/station.dart';
import '../../domain/entities/student.dart';
import '../../interfaces/repositories/istudent_repository.dart';
import '../../interfaces/repositories/ihealth_record_repository.dart';
import '../../interfaces/repositories/icampaign_repository.dart';

class AdminOverviewViewModel extends ChangeNotifier {
  final IStudentRepository _studentRepo;
  final IHealthRecordRepository _recordRepo;
  final ICampaignRepository _campaignRepo;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<Student> _students = [];
  List<HealthRecord> _healthRecords = [];
  List<Campaign> _campaigns = [];

  List<Student> get recentStudents => _students;

  final List<Station> _stations = [
    Station(id: 'physical', name: 'Đo thể lực'),
    Station(id: 'vision', name: 'Khám thị lực'),
    Station(id: 'blood_pressure', name: 'Đo huyết áp'),
    Station(id: 'general', name: 'Khám tổng quát'),
  ];

  AdminOverviewViewModel(this._studentRepo, this._recordRepo, this._campaignRepo) {
    loadData();
  }

  // ✨ CHỈ LẤY CHIẾN DỊCH ĐANG DIỄN RA
  Campaign? get currentCampaign {
    if (_campaigns.isEmpty) return null;
    try {
      return _campaigns.firstWhere(
            (c) => c.status.toLowerCase() == 'active' || c.status.toLowerCase() == 'ongoing',
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> loadData() async {
    _isLoading = true; notifyListeners();
    try {
      final results = await Future.wait([
        _studentRepo.getAllStudents(),
        _campaignRepo.getAllCampaigns(),
      ]);

      final allStudents = results[0] as List<Student>;
      _campaigns = results[1] as List<Campaign>;

      // Lấy chiến dịch đang diễn ra
      final currentCamp = currentCampaign;

      if (currentCamp != null) {
        // ✨ NẾU CÓ CHIẾN DỊCH ACTIVE: Chỉ lấy số liệu (Hồ sơ + Sinh viên) thuộc chiến dịch này
        _healthRecords = await _recordRepo.getRecordsByCampaign(currentCamp.id);
        _students = allStudents.where((s) => s.campaignId == currentCamp.id).toList();
      } else {
        // ✨ NẾU KHÔNG CÓ CHIẾN DỊCH ACTIVE: Trả các số liệu thống kê về 0
        _healthRecords = [];
        _students = [];
      }
    } catch (e) {
      debugPrint("Lỗi tải tổng quan: $e");
    } finally {
      _isLoading = false; notifyListeners();
    }
  }

  int get totalStudents => _students.length;
  int get completedStudents => _students.where((s) => s.status == 'completed').length;
  int get completionRate => totalStudents > 0 ? ((completedStudents / totalStudents) * 100).round() : 0;

  List<Map<String, dynamic>> get stationStats {
    return _stations.map((station) {
      final completed = _healthRecords.where((r) => r.completedStations.contains(station.id)).length;
      final percentage = totalStudents > 0 ? (completed / totalStudents) * 100 : 0.0;
      return {
        'station': station,
        'completed': completed,
        'percentage': percentage,
      };
    }).toList();
  }
}