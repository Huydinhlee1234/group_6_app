import 'package:flutter/material.dart';
import '../../../../domain/entities/student.dart';
import '../../../../domain/entities/health_record.dart';
import 'physical_form_widget.dart';
import 'vision_form_widget.dart';
import 'blood_pressure_form_widget.dart';
import 'general_form_widget.dart';

class StationFormWidget extends StatelessWidget {
  final Student student;
  final String stationId;
  final HealthRecord? initialRecord;

  const StationFormWidget({super.key, required this.student, required this.stationId, this.initialRecord});

  @override
  Widget build(BuildContext context) {
    // Khởi tạo Record rỗng nếu sinh viên chưa khám trạm nào
    final record = initialRecord ?? HealthRecord(
        studentId: student.id,
        campaignId: student.campaignId,
        completedStations: []
    );

    // Mở đúng giao diện dựa theo ID trạm
    switch (stationId) {
      case 'physical':
        return PhysicalFormWidget(student: student, record: record);
      case 'vision':
        return VisionFormWidget(student: student, record: record);
      case 'blood_pressure':
        return BloodPressureFormWidget(student: student, record: record);
      case 'general':
        return GeneralFormWidget(student: student, record: record);
      default:
        return const Scaffold(body: Center(child: Text('Trạm không hợp lệ')));
    }
  }
}