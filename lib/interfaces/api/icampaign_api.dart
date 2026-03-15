// lib/interfaces/api/icampaign_api.dart


import '../../domain/entities/campaign.dart';

abstract class ICampaignApi {
  Future<List<Campaign>> getAllCampaigns();
  Future<Campaign> createCampaign(Campaign campaign);
  Future<Campaign> updateCampaign(Campaign campaign);
  Future<void> deleteCampaign(String id);
}

