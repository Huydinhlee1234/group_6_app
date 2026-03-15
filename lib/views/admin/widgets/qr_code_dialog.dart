import 'package:flutter/material.dart';
import '../../../domain/entities/student.dart';
import '../../shared/qr_code_generator.dart';


void showQRCodeDialog(BuildContext context, Student student, {String? campaignName, String? campaignId}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        child: Container(
          width: 400, // max-w-md tương đương 400px
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Text('Mã QR - ${student.name}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87), textAlign: TextAlign.center),
              const SizedBox(height: 4),
              Text('Mã QR để check-in tại các trạm khám', style: TextStyle(fontSize: 13, color: Colors.grey.shade600), textAlign: TextAlign.center),

              const SizedBox(height: 24),

              // ✨ SỬ DỤNG COMPONENT CHUẨN ĐÃ TẠO
              QRCodeGenerator(
                student: student,
                campaignId: campaignId ?? 'default',
                size: 200.0,
                showDetails: false, // Tắt chữ bên dưới vì hộp thoại đã có đủ thông tin
              ),

              const SizedBox(height: 24),

              // Student Info Box (Giống bg-slate-50)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Thông tin sinh viên:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 8),
                    Text('• MSSV: ${student.studentCode}', style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                    const SizedBox(height: 4),
                    Text('• Họ tên: ${student.name}', style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                    const SizedBox(height: 4),
                    Text('• Lớp: ${student.className}', style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                    if (campaignName != null) ...[
                      const SizedBox(height: 4),
                      Text('• Chiến dịch: $campaignName', style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                    ]
                  ],
                ),
              ),

              const SizedBox(height: 16),
              Text('Sinh viên cần mang mã QR này khi tham gia khám sức khỏe', style: TextStyle(fontSize: 11, color: Colors.grey.shade500), textAlign: TextAlign.center),

              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  child: const Text('Đóng'),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}