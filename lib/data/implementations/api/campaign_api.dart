//
// import '../../../domain/entities/campaign.dart';
// import '../../../interfaces/api/icampaign_api.dart';
// import '../../dtos/campaign/campaign_dto.dart';
// import '../local/app_database.dart';
// import '../mapper/campaign_mapper.dart';
//
//
// class CampaignApi implements ICampaignApi {
//   final _fromDto = CampaignFromDtoMapper();
//   final _toDto = CampaignToDtoMapper();
//
//   @override
//   Future<List<Campaign>> getAllCampaigns() async {
//     final db = await AppDatabase.instance.db;
//     final maps = await db.query('campaigns');
//     return maps.map((map) => _fromDto.map(CampaignDto.fromMap(map))).toList();
//   }
//
//   @override
//   Future<Campaign> createCampaign(Campaign campaign) async {
//     final db = await AppDatabase.instance.db;
//     await db.insert('campaigns', _toDto.map(campaign).toMap());
//     return campaign;
//   }
//
//   @override
//   Future<Campaign> updateCampaign(Campaign campaign) async {
//     final db = await AppDatabase.instance.db;
//     await db.update('campaigns', _toDto.map(campaign).toMap(), where: 'id = ?', whereArgs: [campaign.id]);
//     return campaign;
//   }
//
//   @override
//   Future<void> deleteCampaign(String id) async {
//     final db = await AppDatabase.instance.db;
//     await db.delete('campaigns', where: 'id = ?', whereArgs: [id]);
//   }
// }

import 'package:sqflite/sqflite.dart';
import '../../../domain/entities/campaign.dart';
import '../../../interfaces/api/icampaign_api.dart';
import '../../dtos/campaign/campaign_dto.dart';
import '../local/app_database.dart';
import '../mapper/campaign_mapper.dart';

class CampaignApi implements ICampaignApi {
  final _fromDto = CampaignFromDtoMapper();
  final _toDto = CampaignToDtoMapper();

  @override
  Future<List<Campaign>> getAllCampaigns() async {
    final db = await AppDatabase.instance.db;
    final maps = await db.query('campaigns');
    return maps.map((map) => _fromDto.map(CampaignDto.fromJson(map))).toList();
  }

  @override
  Future<Campaign> createCampaign(Campaign campaign) async {
    final db = await AppDatabase.instance.db;
    final dto = _toDto.map(campaign);
    await db.insert('campaigns', dto.toJson());
    return campaign;
  }

  @override
  Future<Campaign> updateCampaign(Campaign campaign) async {
    final db = await AppDatabase.instance.db;
    final dto = _toDto.map(campaign);
    await db.update('campaigns', dto.toJson(), where: 'id = ?', whereArgs: [campaign.id]);
    return campaign;
  }

  @override
  Future<void> deleteCampaign(String id) async {
    final db = await AppDatabase.instance.db;
    await db.delete('campaigns', where: 'id = ?', whereArgs: [id]);
  }
}