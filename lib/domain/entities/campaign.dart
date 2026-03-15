// class Campaign {
//   final String id;
//   final String name;
//   final String startDate;
//   final String endDate;
//   final String location;
//   final String status; // 'ongoing' hoặc 'completed'
//
//   Campaign({
//     required this.id,
//     required this.name,
//     required this.startDate,
//     required this.endDate,
//     required this.location,
//     required this.status,
//   });
// }

import 'package:intl/intl.dart';

class Campaign {
  final String id;
  final String name;
  final String startDate;
  final String endDate;
  final String location;
  final String status;

  Campaign({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.status,
  });

  String get computedStatus {
    try {
      DateTime start;
      DateTime end;

      // ✨ BÍ QUYẾT: Tự động chuẩn hóa dấu '-' thành '/' (VD: '03-03-2026' -> '03/03/2026')
      String normalizedStart = startDate.replaceAll('-', '/');
      String normalizedEnd = endDate.replaceAll('-', '/');

      if (normalizedStart.contains('/')) {
        start = DateFormat('dd/MM/yyyy').parse(normalizedStart);
        end = DateFormat('dd/MM/yyyy').parse(normalizedEnd);
      } else {
        start = DateTime.parse(startDate);
        end = DateTime.parse(endDate);
      }

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final startDay = DateTime(start.year, start.month, start.day);
      final endDay = DateTime(end.year, end.month, end.day);

      if (today.isAfter(endDay)) {
        return 'completed';
      } else if (today.isBefore(startDay)) {
        return 'upcoming';
      } else {
        return 'active';
      }
    } catch (e) {
      // Nếu có bất kỳ lỗi ngày tháng nào, tự động đổi 'ongoing' thành 'active' cho khớp hệ thống
      if (status.toLowerCase() == 'ongoing') return 'active';
      return status;
    }
  }
}