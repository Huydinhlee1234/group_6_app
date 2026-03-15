import 'package:flutter/material.dart';
import '../../domain/entities/campaign.dart';
import '../../domain/entities/station.dart';
import '../../interfaces/repositories/icampaign_repository.dart';

class StationSelectionViewModel extends ChangeNotifier {
  final ICampaignRepository _campaignRepo;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Campaign> _activeCampaigns = [];
  List<Campaign> get activeCampaigns => _activeCampaigns;

  final List<Station> stations = [
    Station(id: 'physical', name: 'Đo thể lực'),
    Station(id: 'vision', name: 'Khám thị lực'),
    Station(id: 'blood_pressure', name: 'Đo huyết áp'),
    Station(id: 'general', name: 'Khám tổng quát'),
  ];

  StationSelectionViewModel(this._campaignRepo) {
    loadActiveCampaigns();
  }

  Future<void> loadActiveCampaigns() async {
    _isLoading = true; notifyListeners();
    try {
      final all = await _campaignRepo.getAllCampaigns();

      // ✨ ĐÃ SỬA: Chấp nhận cả trạng thái 'active' và 'ongoing'
      _activeCampaigns = all.where((c) =>
      c.computedStatus == 'active' ||
          c.computedStatus == 'ongoing' ||
          c.status == 'ongoing'
      ).toList();

    } finally {
      _isLoading = false; notifyListeners();
    }
  }
}