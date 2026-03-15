import '../../../domain/entities/campaign.dart';
import '../../../interfaces/api/icampaign_api.dart';
import '../../../interfaces/repositories/icampaign_repository.dart';

class CampaignRepository implements ICampaignRepository {
  final ICampaignApi _api;

  CampaignRepository(this._api);

  @override
  Future<List<Campaign>> getAllCampaigns() => _api.getAllCampaigns();

  @override
  Future<Campaign> createCampaign(Campaign campaign) => _api.createCampaign(campaign);

  @override
  Future<Campaign> updateCampaign(Campaign campaign) => _api.updateCampaign(campaign);

  @override
  Future<void> deleteCampaign(String id) => _api.deleteCampaign(id);
}