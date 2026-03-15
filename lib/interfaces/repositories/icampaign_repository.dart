// lib/interfaces/repositories/icampaign_repository.dart
import '../../domain/entities/campaign.dart';


abstract class ICampaignRepository {
  Future<List<Campaign>> getAllCampaigns();
  Future<Campaign> createCampaign(Campaign campaign);
  Future<Campaign> updateCampaign(Campaign campaign);
  Future<void> deleteCampaign(String id);
}