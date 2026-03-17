import 'package:flutter/material.dart';
import '../../../domain/entities/campaign.dart';

void showCampaignDetailDialog(BuildContext context, Campaign campaign) {
  // ✨ BỔ SUNG LOGIC XỬ LÝ TRẠNG THÁI RÕ RÀNG HƠN
  String statusText;
  Color statusColor;

  final statusLc = campaign.status.toLowerCase();

  // Bắt cả 'active' và 'ongoing' (vì trong Database bạn đang dùng 'ongoing')
  if (statusLc == 'active' || statusLc == 'ongoing') {
    statusText = 'ĐANG DIỄN RA';
    statusColor = Colors.green.shade600;
  } else if (statusLc == 'upcoming') {
    statusText = 'SẮP TỚI';
    statusColor = Colors.orange.shade600;
  } else {
    statusText = 'KẾT THÚC';
    statusColor = Colors.red.shade600; // Đổi sang màu đỏ/xám cho hợp lý với trạng thái đã kết thúc
  }

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(campaign.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.place, color: Colors.grey),
              title: const Text('Địa điểm'),
              subtitle: Text(campaign.location)
          ),
          ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.date_range, color: Colors.grey),
              title: const Text('Thời gian'),
              subtitle: Text('${campaign.startDate} đến ${campaign.endDate}')
          ),
          ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.info_outline, color: Colors.grey),
              title: const Text('Trạng thái'),
              subtitle: Text(
                  statusText,
                  style: TextStyle(fontWeight: FontWeight.bold, color: statusColor)
              )
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng', style: TextStyle(fontWeight: FontWeight.bold))
        )
      ],
    ),
  );
}