import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../domain/entities/student.dart';
import '../../../../domain/entities/health_record.dart';
import '../../../../viewmodels/health_staff/station_form_viewmodel.dart';
import 'shared_station_layout.dart';

class BloodPressureFormWidget extends StatefulWidget {
  final Student student;
  final HealthRecord record;

  const BloodPressureFormWidget({super.key, required this.student, required this.record});

  @override
  State<BloodPressureFormWidget> createState() => _BloodPressureFormWidgetState();
}

class _BloodPressureFormWidgetState extends State<BloodPressureFormWidget> {
  final _systolicCtrl = TextEditingController();
  final _diastolicCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.record.bloodPressure != null) {
      _systolicCtrl.text = widget.record.bloodPressure!['systolic']?.toString() ?? '';
      _diastolicCtrl.text = widget.record.bloodPressure!['diastolic']?.toString() ?? '';
    }
  }

  Future<void> _save() async {
    final vm = context.read<StationFormViewModel>();
    final bp = {'systolic': int.tryParse(_systolicCtrl.text), 'diastolic': int.tryParse(_diastolicCtrl.text)};

    List<String> stations = List.from(widget.record.completedStations);
    if (!stations.contains('blood_pressure')) stations.add('blood_pressure');

    final newRecord = HealthRecord(
      studentId: widget.student.id, campaignId: widget.student.campaignId,
      physical: widget.record.physical, vision: widget.record.vision, bloodPressure: bp, general: widget.record.general,
      completedStations: stations,
    );

    final success = await vm.saveRecord(newRecord, widget.student);
    if (success && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StationFormViewModel>();
    return SharedStationLayout(
      student: widget.student, stationId: 'blood_pressure', title: 'Đo huyết áp', icon: Icons.favorite_border_rounded,
      isLoading: vm.isLoading, onSave: _save,
      formContent: Column(
        children: [
          StationUIHelpers.buildTextField('Huyết áp tâm thu (mmHg) *', 'VD: 120', _systolicCtrl, isNumber: true),
          const SizedBox(height: 16),
          StationUIHelpers.buildTextField('Huyết áp tâm trương (mmHg) *', 'VD: 80', _diastolicCtrl, isNumber: true),
        ],
      ),
    );
  }
}