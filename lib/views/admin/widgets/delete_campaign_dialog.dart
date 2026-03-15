import 'package:flutter/material.dart';
import '../../../domain/entities/campaign.dart';


void showDeleteCampaignDialog(BuildContext context, Campaign campaign, VoidCallback onConfirm) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.all(24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.red.shade50, shape: BoxShape.circle),
            child: Icon(Icons.warning_amber_rounded, color: Colors.red.shade600, size: 36),
          ),
          const SizedBox(height: 20),
          const Text('Xóa Chiến Dịch', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(color: Colors.black87, fontSize: 14, height: 1.5),
              children: [
                const TextSpan(text: 'Bạn có chắc chắn muốn xóa chiến dịch\n'),
                TextSpan(text: '"${campaign.name}"', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                const TextSpan(text: '?\n\n'),
                const TextSpan(
                  text: 'Toàn bộ dữ liệu, danh sách sinh viên tham gia và kết quả khám thuộc chiến dịch này sẽ bị xóa vĩnh viễn. Không thể hoàn tác!',
                  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text('Hủy', style: TextStyle(color: Colors.black87)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    onConfirm();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade600, foregroundColor: Colors.white, elevation: 0, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text('Xóa dữ liệu', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}