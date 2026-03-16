import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../domain/entities/student.dart';

class QRCodeGenerator extends StatelessWidget {
  final Student student;
  final String campaignId;
  final double size;
  final bool includeDownload;
  final bool showDetails;

  const QRCodeGenerator({
    super.key,
    required this.student,
    this.campaignId = 'default',
    this.size = 200,
    this.includeDownload = false,
    this.showDetails = true,
  });

  @override
  Widget build(BuildContext context) {
    // ✨ ĐÃ ĐỒNG BỘ: Cấu trúc JSON này giờ đây KHỚP 100% với mã QR gửi trong Email
    // Giúp máy quét (Scanner) của Y tá đọc mượt mà không bao giờ bị lỗi format
    final qrData = jsonEncode({
      'studentCode': student.studentCode,
      'campaignId': student.campaignId, // Lấy trực tiếp từ entity Student cho an toàn
    });

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          // TỰ ĐỘNG THU NHỎ VIỀN NẾU LÀ THUMBNAIL (showDetails = false)
          padding: EdgeInsets.all(showDetails ? 16 : 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: QrImageView(
            data: qrData,
            version: QrVersions.auto,
            size: size,
          ),
        ),

        // CHỈ HIỂN THỊ TEXT NẾU ĐƯỢC PHÉP
        if (showDetails) ...[
          const SizedBox(height: 12),
          Text(student.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          Text('MSSV: ${student.studentCode}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
          if (includeDownload) ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đang tải xuống QR...')));
                // TODO: Viết logic lưu file ảnh QR vào máy ở đây
              },
              icon: const Icon(Icons.download, size: 16),
              label: const Text('Tải xuống QR'),
            )
          ]
        ]
      ],
    );
  }
}