import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../domain/entities/student.dart';
import '../../../../domain/entities/health_record.dart';
import '../../../../viewmodels/health_staff/station_form_viewmodel.dart';
import 'shared_station_layout.dart';

class GeneralFormWidget extends StatefulWidget {
  final Student student;
  final HealthRecord record;

  const GeneralFormWidget({super.key, required this.student, required this.record});

  @override
  State<GeneralFormWidget> createState() => _GeneralFormWidgetState();
}

class _GeneralFormWidgetState extends State<GeneralFormWidget> {
  String _healthStatus = 'good';
  final _generalNotesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.record.general != null) {
      _healthStatus = widget.record.general!['healthStatus'] ?? 'good';
      _generalNotesCtrl.text = widget.record.general!['notes'] ?? '';
    }
  }

  Future<void> _save() async {
    final vm = context.read<StationFormViewModel>();
    final gen = {'healthStatus': _healthStatus, 'notes': _generalNotesCtrl.text};

    List<String> stations = List.from(widget.record.completedStations);
    if (!stations.contains('general')) stations.add('general');

    final newRecord = HealthRecord(
      studentId: widget.student.id, campaignId: widget.student.campaignId,
      physical: widget.record.physical, vision: widget.record.vision, bloodPressure: widget.record.bloodPressure, general: gen,
      completedStations: stations,
    );

    final success = await vm.saveRecord(newRecord, widget.student);
    if (success && mounted) Navigator.pop(context);
  }

  Widget _buildRadioTile(String title, String value) {
    return RadioListTile(
      title: Text(title, style: const TextStyle(fontSize: 14)),
      value: value, groupValue: _healthStatus,
      onChanged: (v) => setState(() => _healthStatus = v.toString()),
      activeColor: Colors.blue.shade700, contentPadding: EdgeInsets.zero,
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StationFormViewModel>();
    return SharedStationLayout(
      student: widget.student, stationId: 'general', title: 'Khám tổng quát', icon: Icons.medical_services_outlined,
      isLoading: vm.isLoading, onSave: _save,
      formContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Đánh giá sức khỏe tổng thể *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          _buildRadioTile('Tốt', 'good'),
          _buildRadioTile('Trung bình', 'average'),
          _buildRadioTile('Kém', 'poor'),
          const SizedBox(height: 16),
          StationUIHelpers.buildTextField('Ghi chú', 'Nhập ghi chú về tình trạng sức khỏe...', _generalNotesCtrl, maxLines: 3),
        ],
      ),
    );
  }
}