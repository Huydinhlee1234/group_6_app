// import 'package:flutter/material.dart';
// import '../../domain/entities/student.dart';
// import '../../domain/entities/health_record.dart';
// import '../../interfaces/repositories/istudent_repository.dart';
// import '../../interfaces/repositories/ihealth_record_repository.dart';
//
// class StudentCheckInViewModel extends ChangeNotifier {
//   final IStudentRepository _studentRepo;
//   final IHealthRecordRepository _recordRepo;
//
//   StudentCheckInViewModel(this._studentRepo, this._recordRepo);
//
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;
//
//   List<Student> _students = [];
//   // ✨ BỔ SUNG GETTER NÀY ĐỂ GIAO DIỆN LẤY ĐƯỢC TOÀN BỘ DANH SÁCH
//   List<Student> get allStudents => _students;
//
//   List<HealthRecord> _records = [];
//   List<Student> _searchResults = [];
//   List<Student> get searchResults => _searchResults;
//
//   String _searchQuery = '';
//   String get searchQuery => _searchQuery;
//
//   // Gọi hàm này khi khởi tạo trang CheckIn
//   Future<void> loadData(String campaignId) async {
//     _isLoading = true; notifyListeners();
//     try {
//       final allStudents = await _studentRepo.getAllStudents();
//       _students = allStudents.where((s) => s.campaignId == campaignId).toList();
//       _records = await _recordRepo.getRecordsByCampaign(campaignId);
//
//       // ✨ KHỞI TẠO: Vừa vào trang là hiển thị toàn bộ danh sách luôn
//       _searchResults = _students;
//     } finally {
//       _isLoading = false; notifyListeners();
//     }
//   }
//
//   void searchStudent(String query) {
//     _searchQuery = query;
//     if (query.trim().isEmpty) {
//       // ✨ SỬA LỖI MÀN HÌNH TRẮNG: Trả lại toàn bộ danh sách nếu xóa trắng ô tìm kiếm
//       _searchResults = _students;
//     } else {
//       _searchResults = _students.where((s) =>
//       s.studentCode.toLowerCase().contains(query.toLowerCase()) ||
//           s.name.toLowerCase().contains(query.toLowerCase())
//       ).toList();
//     }
//     notifyListeners();
//   }
//
//   void simulateQRScan() {
//     if (_students.isNotEmpty) searchStudent(_students.first.studentCode);
//   }
//
//   HealthRecord? getRecord(String studentId) {
//     try {
//       return _records.firstWhere((r) => r.studentId == studentId);
//     } catch (_) {
//       return null;
//     }
//   }
// }

import 'dart:math'; // ✨ Bổ sung thư viện Math để random
import 'package:flutter/material.dart';
import '../../domain/entities/student.dart';
import '../../domain/entities/health_record.dart';
import '../../interfaces/repositories/istudent_repository.dart';
import '../../interfaces/repositories/ihealth_record_repository.dart';

class StudentCheckInViewModel extends ChangeNotifier {
  final IStudentRepository _studentRepo;
  final IHealthRecordRepository _recordRepo;

  StudentCheckInViewModel(this._studentRepo, this._recordRepo);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Student> _students = [];
  List<Student> get allStudents => _students;

  List<HealthRecord> _records = [];
  List<Student> _searchResults = [];
  List<Student> get searchResults => _searchResults;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  Future<void> loadData(String campaignId) async {
    _isLoading = true; notifyListeners();
    try {
      final allStudents = await _studentRepo.getAllStudents();
      _students = allStudents.where((s) => s.campaignId == campaignId).toList();
      _records = await _recordRepo.getRecordsByCampaign(campaignId);

      // ✨ FIX LỖI 2: Đảm bảo danh sách hiển thị trống khi mới vào trang
      _searchResults = [];
      _searchQuery = '';
    } finally {
      _isLoading = false; notifyListeners();
    }
  }

  void searchStudent(String query) {
    _searchQuery = query;
    if (query.trim().isEmpty) {
      // ✨ FIX LỖI 2: Ẩn danh sách khi người dùng xóa trắng ô tìm kiếm
      _searchResults = [];
    } else {
      _searchResults = _students.where((s) =>
      s.studentCode.toLowerCase().contains(query.toLowerCase()) ||
          s.name.toLowerCase().contains(query.toLowerCase())
      ).toList();
    }
    notifyListeners();
  }

  void simulateQRScan() {
    if (_students.isNotEmpty) {
      // ✨ FIX LỖI 1: Quét ngẫu nhiên 1 sinh viên thay vì lấy người đầu tiên
      final randomIndex = Random().nextInt(_students.length);
      searchStudent(_students[randomIndex].studentCode);
    }
  }

  HealthRecord? getRecord(String studentId) {
    try {
      return _records.firstWhere((r) => r.studentId == studentId);
    } catch (_) {
      return null;
    }
  }
}