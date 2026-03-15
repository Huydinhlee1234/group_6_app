import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../domain/entities/student.dart';
import '../../../../domain/entities/health_record.dart';
import '../../../../viewmodels/health_staff/station_form_viewmodel.dart';
import 'shared_station_layout.dart';

class VisionFormWidget extends StatefulWidget {
  final Student student;
  final HealthRecord record;

  const VisionFormWidget({super.key, required this.student, required this.record});

  @override
  State<VisionFormWidget> createState() => _VisionFormWidgetState();
}

class _VisionFormWidgetState extends State<VisionFormWidget> {
  final _leftEyeCtrl = TextEditingController();
  final _rightEyeCtrl = TextEditingController();
  final _visionNotesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.record.vision != null) {
      _leftEyeCtrl.text = widget.record.vision!['leftEye'] ?? '';
      _rightEyeCtrl.text = widget.record.vision!['rightEye'] ?? '';
      _visionNotesCtrl.text = widget.record.vision!['notes'] ?? '';
    }
  }

  Future<void> _save() async {
    final vm = context.read<StationFormViewModel>();
    final vis = {'leftEye': _leftEyeCtrl.text, 'rightEye': _rightEyeCtrl.text, 'notes': _visionNotesCtrl.text};

    List<String> stations = List.from(widget.record.completedStations);
    if (!stations.contains('vision')) stations.add('vision');

    final newRecord = HealthRecord(
      studentId: widget.student.id, campaignId: widget.student.campaignId,
      physical: widget.record.physical, vision: vis, bloodPressure: widget.record.bloodPressure, general: widget.record.general,
      completedStations: stations,
    );

    final success = await vm.saveRecord(newRecord, widget.student);
    if (success && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StationFormViewModel>();
    return SharedStationLayout(
      student: widget.student, stationId: 'vision', title: 'Khám thị lực', icon: Icons.remove_red_eye_outlined,
      isLoading: vm.isLoading, onSave: _save,
      formContent: Column(
        children: [
          StationUIHelpers.buildTextField('Thị lực mắt trái *', 'VD: 10/10', _leftEyeCtrl),
          const SizedBox(height: 16),
          StationUIHelpers.buildTextField('Thị lực mắt phải *', 'VD: 10/10', _rightEyeCtrl),
          const SizedBox(height: 16),
          StationUIHelpers.buildTextField('Ghi chú (không bắt buộc)', 'Nhập ghi chú nếu có...', _visionNotesCtrl, maxLines: 3),
        ],
      ),
    );
  }
}