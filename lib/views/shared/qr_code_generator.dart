import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../domain/entities/student.dart';

class QRCodeGenerator extends StatelessWidget {
  final Student student;
  final String campaignId;
  final double size;
  final bool includeDownload;
  final bool showDetails; // ✨ BỔ SUNG CỜ NÀY

  const QRCodeGenerator({
    super.key,
    required this.student,
    this.campaignId = 'default',
    this.size = 200,
    this.includeDownload = false,
    this.showDetails = true, // Mặc định vẫn hiện chữ để không ảnh hưởng code cũ
  });

  @override
  Widget build(BuildContext context) {
    final qrData = jsonEncode({
      'studentId': student.id,
      'studentCode': student.studentCode,
      'name': student.name,
      'campaignId': campaignId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          // ✨ TỰ ĐỘNG THU NHỎ VIỀN NẾU LÀ THUMBNAIL (showDetails = false)
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

        // ✨ CHỈ HIỂN THỊ TEXT NẾU ĐƯỢC PHÉP
        if (showDetails) ...[
          const SizedBox(height: 12),
          Text(student.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          Text('MSSV: ${student.studentCode}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
          if (includeDownload) ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đang tải xuống QR...')));
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