import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../domain/entities/student.dart';
import '../../../../domain/entities/health_record.dart';
import '../../../../viewmodels/health_staff/station_form_viewmodel.dart';
import 'shared_station_layout.dart';

class PhysicalFormWidget extends StatefulWidget {
  final Student student;
  final HealthRecord record;

  const PhysicalFormWidget({super.key, required this.student, required this.record});

  @override
  State<PhysicalFormWidget> createState() => _PhysicalFormWidgetState();
}

class _PhysicalFormWidgetState extends State<PhysicalFormWidget> {
  final _heightCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.record.physical != null) {
      _heightCtrl.text = widget.record.physical!['height']?.toString() ?? '';
      _weightCtrl.text = widget.record.physical!['weight']?.toString() ?? '';
    }
    _heightCtrl.addListener(() => setState(() {}));
    _weightCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  double? _calculateBMI() {
    final h = double.tryParse(_heightCtrl.text);
    final w = double.tryParse(_weightCtrl.text);
    if (h != null && w != null && h > 0) return w / ((h / 100) * (h / 100));
    return null;
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) return 'underweight';
    if (bmi < 25) return 'normal';
    if (bmi < 30) return 'overweight';
    return 'obese';
  }

  String _getBMILabel(String category) {
    switch (category) {
      case 'underweight': return 'Gầy';
      case 'overweight': return 'Thừa cân';
      case 'obese': return 'Béo phì';
      default: return 'Bình thường';
    }
  }

  Future<void> _save() async {
    final vm = context.read<StationFormViewModel>();
    final bmi = _calculateBMI();

    final phys = {
      'height': double.tryParse(_heightCtrl.text),
      'weight': double.tryParse(_weightCtrl.text),
      'bmi': bmi,
      'bmiCategory': bmi != null ? _getBMICategory(bmi) : null,
    };

    List<String> stations = List.from(widget.record.completedStations);
    if (!stations.contains('physical')) stations.add('physical');

    final newRecord = HealthRecord(
      studentId: widget.student.id,
      campaignId: widget.student.campaignId,
      physical: phys,
      vision: widget.record.vision,
      bloodPressure: widget.record.bloodPressure,
      general: widget.record.general,
      completedStations: stations,
    );

    final success = await vm.saveRecord(newRecord, widget.student);
    if (success && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StationFormViewModel>();
    final bmi = _calculateBMI();

    return SharedStationLayout(
      student: widget.student,
      stationId: 'physical',
      title: 'Đo thể lực',
      icon: Icons.monitor_heart_outlined,
      isLoading: vm.isLoading,
      onSave: _save,
      formContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StationUIHelpers.buildTextField('Chiều cao (cm) *', 'VD: 170', _heightCtrl, isNumber: true),
          const SizedBox(height: 16),
          StationUIHelpers.buildTextField('Cân nặng (kg) *', 'VD: 65', _weightCtrl, isNumber: true),
          const SizedBox(height: 16),
          if (bmi != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [const Text('BMI:', style: TextStyle(fontWeight: FontWeight.w600)), Text(bmi.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold))],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Phân loại:', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text(_getBMILabel(_getBMICategory(bmi)), style: TextStyle(fontWeight: FontWeight.bold, color: _getBMICategory(bmi) == 'normal' ? Colors.green.shade700 : Colors.orange.shade700)),
                    ],
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}