import 'package:flutter/material.dart';
import '../../../domain/entities/student.dart';

void showDeleteStudentDialog(BuildContext context, Student student, VoidCallback onConfirm) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Xác nhận xóa sinh viên'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black87, fontSize: 14, height: 1.5),
          children: [
            const TextSpan(text: 'Bạn có chắc chắn muốn xóa sinh viên '),
            TextSpan(text: student.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: ' (Mã SV: ${student.studentCode})?\n\n'),
            const TextSpan(
              text: 'Hành động này sẽ xóa vĩnh viễn thông tin sinh viên và tất cả dữ liệu khám sức khỏe liên quan. Thao tác này không thể hoàn tác.',
              style: TextStyle(color: Colors.redAccent),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () {
            onConfirm();
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade600,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Xóa sinh viên'),
        ),
      ],
    ),
  );
}