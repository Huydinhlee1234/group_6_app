import 'package:flutter/material.dart';
import '../../../../domain/entities/student.dart';

class SharedStationLayout extends StatelessWidget {
  final Student student;
  final String stationId;
  final String title;
  final IconData icon;
  final Widget formContent;
  final bool isLoading;
  final VoidCallback onSave;

  const SharedStationLayout({
    super.key,
    required this.student,
    required this.stationId,
    required this.title,
    required this.icon,
    required this.formContent,
    required this.isLoading,
    required this.onSave,
  });

  Widget _buildTabItem(String id, String text, bool isActive) {
    return Expanded(
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isActive ? Colors.blue.shade50 : Colors.white,
          border: Border.all(color: isActive ? Colors.blue.shade600 : Colors.grey.shade300, width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? Colors.blue.shade700 : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade50,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Phần Header xanh lam
            Container(
              width: double.infinity,
              color: Colors.blue.shade50,
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                        child: Icon(icon, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('Sinh viên: ${student.name}', style: TextStyle(color: Colors.grey.shade800, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text('Mã SV: ${student.studentCode}', style: TextStyle(color: Colors.grey.shade800, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text('Lớp: ${student.className}', style: TextStyle(color: Colors.grey.shade800, fontSize: 15)),
                ],
              ),
            ),

            // Thanh Tabs
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  _buildTabItem('physical', 'Đo thể\nlực', stationId == 'physical'),
                  const SizedBox(width: 8),
                  _buildTabItem('vision', 'Khám thị\nlực', stationId == 'vision'),
                  const SizedBox(width: 8),
                  _buildTabItem('blood_pressure', 'Đo huyết\náp', stationId == 'blood_pressure'),
                  const SizedBox(width: 8),
                  _buildTabItem('general', 'Khám\ntổng quát', stationId == 'general'),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.black12),

            // Nội dung Form của từng trạm
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  formContent,
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : onSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: isLoading
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Lưu & Sinh viên tiếp theo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Lớp tiện ích chứa Widget dùng chung cho các ô nhập liệu
class StationUIHelpers {
  static Widget buildTextField(String label, String hint, TextEditingController ctrl, {bool isNumber = false, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}