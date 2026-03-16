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

  // ✨ Áp dụng chuẩn phân loại BMI cho người Châu Á (IDI & WPRO)
  String _getBMICategory(double bmi) {
    if (bmi < 18.5) return 'underweight';
    if (bmi < 23.0) return 'normal';
    if (bmi < 25.0) return 'overweight';
    if (bmi < 30.0) return 'obese_1';
    return 'obese_2';
  }

  String _getBMILabel(String category) {
    switch (category) {
      case 'underweight': return 'Gầy (Thiếu cân)';
      case 'normal': return 'Bình thường';
      case 'overweight': return 'Thừa cân (Tiền béo phì)';
      case 'obese_1': return 'Béo phì độ 1';
      case 'obese_2': return 'Béo phì độ 2';
      default: return 'Chưa xác định';
    }
  }

  // ✨ Gắn màu sắc cảnh báo theo từng mức độ
  Color _getBMIColor(String category) {
    switch (category) {
      case 'underweight': return Colors.blue.shade600;
      case 'normal': return Colors.green.shade600;
      case 'overweight': return Colors.orange.shade600;
      case 'obese_1': return Colors.red.shade600;
      case 'obese_2': return Colors.red.shade900;
      default: return Colors.grey;
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
      'categoryLabel': bmi != null ? _getBMILabel(_getBMICategory(bmi)) : null, // Lưu thêm nhãn tiếng Việt
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
          Row(
            children: [
              Expanded(child: StationUIHelpers.buildTextField('Chiều cao (cm)', 'VD: 170', _heightCtrl, isNumber: true)),
              const SizedBox(width: 16),
              Expanded(child: StationUIHelpers.buildTextField('Cân nặng (kg)', 'VD: 65', _weightCtrl, isNumber: true)),
            ],
          ),

          if (bmi != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getBMIColor(_getBMICategory(bmi)).withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _getBMIColor(_getBMICategory(bmi)).withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Chỉ số BMI:', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
                      Text(bmi.toStringAsFixed(1), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: _getBMIColor(_getBMICategory(bmi))))
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Đánh giá:', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
                      Text(
                          _getBMILabel(_getBMICategory(bmi)),
                          style: TextStyle(fontWeight: FontWeight.bold, color: _getBMIColor(_getBMICategory(bmi)))
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],

          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),

          // ✨ Bảng chú giải tham khảo chuẩn Châu Á
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: Colors.blue.shade600, size: 20),
                    const SizedBox(width: 8),
                    const Expanded(child: Text('Phân loại BMI cho người Châu Á (IDI & WPRO):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                  ],
                ),
                const SizedBox(height: 12),
                _buildReferenceRow('Dưới 18.5:', 'Gầy (Thiếu cân).', Colors.blue.shade600),
                _buildReferenceRow('18.5 - 22.9:', 'Bình thường.', Colors.green.shade600),
                _buildReferenceRow('23.0 - 24.9:', 'Thừa cân (Tiền béo phì).', Colors.orange.shade600),
                _buildReferenceRow('25.0 - 29.9:', 'Béo phì độ 1.', Colors.red.shade600),
                _buildReferenceRow('Trên 30.0:', 'Béo phì độ 2.', Colors.red.shade900),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReferenceRow(String title, String desc, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6.0, right: 8.0),
            child: Icon(Icons.circle, size: 6, color: color),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.4),
                children: [
                  TextSpan(text: '$title ', style: TextStyle(fontWeight: FontWeight.bold, color: color)),
                  TextSpan(text: desc),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}