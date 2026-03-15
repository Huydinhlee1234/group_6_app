import 'package:flutter/material.dart';
import '../../../domain/entities/campaign.dart';


void showCampaignDetailDialog(BuildContext context, Campaign campaign) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(campaign.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.place, color: Colors.grey), title: const Text('Địa điểm'), subtitle: Text(campaign.location)),
          ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.date_range, color: Colors.grey), title: const Text('Thời gian'), subtitle: Text('${campaign.startDate} đến ${campaign.endDate}')),
          ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.info_outline, color: Colors.grey), title: const Text('Trạng thái'), subtitle: Text(campaign.status == 'active' ? 'ĐANG DIỄN RA' : (campaign.status == 'upcoming' ? 'SẮP TỚI' : 'KẾT THÚC'), style: TextStyle(fontWeight: FontWeight.bold, color: campaign.status == 'active' ? Colors.green : Colors.orange))),
        ],
      ),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Đóng'))],
    ),
  );
}