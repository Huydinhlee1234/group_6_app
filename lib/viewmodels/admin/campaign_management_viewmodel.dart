import 'package:flutter/material.dart';
import '../../domain/entities/campaign.dart';
import '../../interfaces/repositories/icampaign_repository.dart';

class CampaignManagementViewModel extends ChangeNotifier {
  final ICampaignRepository _campaignRepo;

  List<Campaign> _campaigns = [];
  bool _isLoading = false;
  String _error = '';

  CampaignManagementViewModel(this._campaignRepo) {
    loadCampaigns();
  }

  List<Campaign> get campaigns => _campaigns;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> loadCampaigns() async {
    _isLoading = true; notifyListeners();
    try {
      _campaigns = await _campaignRepo.getAllCampaigns(); // Đọc từ DB
    } catch (e) {
      _error = 'Lỗi tải danh sách: $e';
    } finally {
      _isLoading = false; notifyListeners();
    }
  }

  Future<bool> createCampaign(Campaign campaign) async {
    _isLoading = true; notifyListeners();
    try {
      await _campaignRepo.createCampaign(campaign); // Lưu xuống DB
      await loadCampaigns(); // Load lại list mới từ DB
      return true;
    } catch (e) {
      _error = 'Lỗi thêm: $e'; return false;
    }
  }

  Future<bool> updateCampaign(Campaign campaign) async {
    _isLoading = true; notifyListeners();
    try {
      await _campaignRepo.updateCampaign(campaign); // Cập nhật DB
      await loadCampaigns(); // Load lại list mới
      return true;
    } catch (e) {
      _error = 'Lỗi sửa: $e'; return false;
    }
  }

  Future<bool> deleteCampaign(String id) async {
    _isLoading = true; notifyListeners();
    try {
      await _campaignRepo.deleteCampaign(id); // Xóa khỏi DB
      await loadCampaigns(); // Load lại list mới
      return true;
    } catch (e) {
      _error = 'Lỗi xóa: $e'; return false;
    }
  }
}