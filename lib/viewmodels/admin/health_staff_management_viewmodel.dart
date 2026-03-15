import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import '../../interfaces/repositories/ihealth_staff_repository.dart';

class HealthStaffManagementViewModel extends ChangeNotifier {
  final IHealthStaffRepository _repository;

  List<User> _staffList = [];
  bool _isLoading = false;
  String _error = '';
  String _searchTerm = '';

  HealthStaffManagementViewModel(this._repository) {
    loadStaff();
  }

  bool get isLoading => _isLoading;
  String get error => _error;
  int get totalStaff => _staffList.length;

  List<User> get filteredStaff {
    if (_searchTerm.isEmpty) return _staffList;
    return _staffList.where((s) => s.name.toLowerCase().contains(_searchTerm.toLowerCase()) || s.username.toLowerCase().contains(_searchTerm.toLowerCase())).toList();
  }

  void setSearchTerm(String term) { _searchTerm = term; notifyListeners(); }

  Future<void> loadStaff() async {
    _isLoading = true; notifyListeners();
    try {
      _staffList = await _repository.getAllHealthStaff(); // Đọc từ DB
    } catch (e) { _error = 'Lỗi tải danh sách: $e'; }
    finally { _isLoading = false; notifyListeners(); }
  }

  Future<bool> createHealthStaff(User staff) async {
    _isLoading = true; notifyListeners();
    try {
      await _repository.createHealthStaff(staff); // Lưu DB
      await loadStaff(); // Đồng bộ UI
      return true;
    } catch (e) { _error = 'Lỗi thêm: $e'; return false; }
  }

  Future<bool> updateHealthStaff(User staff) async {
    _isLoading = true; notifyListeners();
    try {
      await _repository.updateHealthStaff(staff); // Lưu DB
      await loadStaff(); // Đồng bộ UI
      return true;
    } catch (e) { _error = 'Lỗi cập nhật: $e'; return false; }
  }

  Future<bool> deleteHealthStaff(String id) async {
    _isLoading = true; notifyListeners();
    try {
      await _repository.deleteHealthStaff(id); // Xóa DB
      await loadStaff(); // Đồng bộ UI
      return true;
    } catch (e) { _error = 'Lỗi xóa: $e'; return false; }
  }

}