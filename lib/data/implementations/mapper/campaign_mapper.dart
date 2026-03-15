// import '../../../domain/entities/campaign.dart';
// import '../../../interfaces/mapper/imapper.dart';
// import '../../dtos/campaign/campaign_dto.dart';
// import '../../dtos/campaign/update_insert_campaign_request_dto.dart';
//
// class CampaignFromDtoMapper implements IMapper<CampaignDto, Campaign> {
//   @override
//   Campaign map(CampaignDto input) {
//     return Campaign(
//       id: input.id,
//       name: input.name,
//       startDate: input.startDate,
//       endDate: input.endDate,
//       location: input.location,
//       status: input.status,
//     );
//   }
// }
//
// class CampaignToDtoMapper implements IMapper<Campaign, UpdateInsertCampaignRequestDto> {
//   @override
//   UpdateInsertCampaignRequestDto map(Campaign input) {
//     return UpdateInsertCampaignRequestDto(
//       id: input.id,
//       name: input.name,
//       startDate: input.startDate,
//       endDate: input.endDate,
//       location: input.location,
//       status: input.status,
//     );
//   }
// }

import '../../../domain/entities/campaign.dart';
import '../../../interfaces/mapper/imapper.dart';
import '../../dtos/campaign/campaign_dto.dart';
import '../../dtos/campaign/update_insert_campaign_request_dto.dart';


class CampaignFromDtoMapper implements IMapper<CampaignDto, Campaign> {
  @override
  Campaign map(CampaignDto input) {
    return Campaign(
      id: input.id,
      name: input.name,
      startDate: input.startDate,
      endDate: input.endDate,
      location: input.location,
      status: input.status,
    );
  }
}

class CampaignToDtoMapper implements IMapper<Campaign, UpdateInsertCampaignRequestDto> {
  @override
  UpdateInsertCampaignRequestDto map(Campaign input) {
    return UpdateInsertCampaignRequestDto(
      id: input.id,
      name: input.name,
      startDate: input.startDate,
      endDate: input.endDate,
      location: input.location,
      // ✨ Lấy Trạng thái thực tế vừa tính được để cất xuống DB
      status: input.computedStatus,
    );
  }
}