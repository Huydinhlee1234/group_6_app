import 'package:flutter/material.dart';
import '../../../domain/entities/student.dart';

void showStudentDetailDialog(
    BuildContext context,
    Student student,
    int completedStations,
    String campaignName,
    ) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
                radius: 40,
                backgroundColor: Colors.purple.shade50,
                child: Text(student.name[0], style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.purple.shade600))
            ),
            const SizedBox(height: 16),
            Text(student.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            Text('${student.studentCode} - Lớp ${student.className}', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
            const Divider(height: 32),

            // ✨ ĐÃ THÊM: Dòng hiển thị Email của sinh viên
            _buildRow(
                Icons.email_outlined,
                'Email',
                student.email,
                Colors.grey.shade800
            ),
            const SizedBox(height: 12),

            _buildRow(
                Icons.event_note_rounded,
                'Chiến dịch',
                campaignName,
                Colors.teal.shade600
            ),
            const SizedBox(height: 12),

            _buildRow(
                Icons.how_to_reg_rounded,
                'Trạng thái',
                student.status == 'completed' ? 'Hoàn thành' : (student.status == 'in_progress' ? 'Đang khám' : 'Chưa khám'),
                student.status == 'completed' ? Colors.green : Colors.orange
            ),
            const SizedBox(height: 12),
            _buildRow(Icons.local_hospital_rounded, 'Tiến độ', '$completedStations/4 trạm hoàn tất', Colors.blue),
            const SizedBox(height: 24),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade100,
                        foregroundColor: Colors.black87,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14)
                    ),
                    child: const Text('Đóng', style: TextStyle(fontWeight: FontWeight.bold))
                )
            )
          ],
        ),
      ),
    ),
  );
}

Widget _buildRow(IconData icon, String label, String value, Color color) {
  return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(width: 16),
        Expanded(
            child: Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 14),
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
        )
      ]
  );
}