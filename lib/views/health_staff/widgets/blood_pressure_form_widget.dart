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

  String _categoryResult = '';
  Color _categoryColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    if (widget.record.bloodPressure != null) {
      _systolicCtrl.text = widget.record.bloodPressure!['systolic']?.toString() ?? '';
      _diastolicCtrl.text = widget.record.bloodPressure!['diastolic']?.toString() ?? '';
      _evaluateBloodPressure();
    }

    // Lắng nghe sự thay đổi để tự động tính toán
    _systolicCtrl.addListener(_evaluateBloodPressure);
    _diastolicCtrl.addListener(_evaluateBloodPressure);
  }

  @override
  void dispose() {
    _systolicCtrl.dispose();
    _diastolicCtrl.dispose();
    super.dispose();
  }

  // ✨ Logic tự động phân loại huyết áp dựa trên ảnh cung cấp
  void _evaluateBloodPressure() {
    final sys = int.tryParse(_systolicCtrl.text);
    final dia = int.tryParse(_diastolicCtrl.text);

    if (sys == null || dia == null) {
      setState(() {
        _categoryResult = '';
      });
      return;
    }

    String category = '';
    Color color = Colors.grey;

    // Phân loại từ mức độ nặng nhất xuống nhẹ nhất
    if (sys >= 180 || dia >= 110) {
      category = 'Cao huyết áp độ 3 (Nguy hiểm)';
      color = Colors.red.shade700;
    } else if (sys >= 160 || dia >= 100) {
      category = 'Cao huyết áp độ 2';
      color = Colors.orange.shade800;
    } else if (sys >= 140 || dia >= 90) {
      category = 'Cao huyết áp độ 1';
      color = Colors.orange.shade600;
    } else if ((sys >= 130 && sys <= 139) || (dia >= 85 && dia <= 89)) {
      category = 'Tiền cao huyết áp';
      color = Colors.pink.shade500;
    } else if (sys < 120 && dia < 80) {
      category = 'Bình thường';
      color = Colors.green.shade600;
    } else {
      category = 'Bình thường cao (Cần theo dõi)';
      color = Colors.blue.shade600;
    }

    setState(() {
      _categoryResult = category;
      _categoryColor = color;
    });
  }

  Future<void> _save() async {
    final vm = context.read<StationFormViewModel>();
    final bp = {
      'systolic': int.tryParse(_systolicCtrl.text),
      'diastolic': int.tryParse(_diastolicCtrl.text),
      'category': _categoryResult // ✨ Lưu thêm phân loại vào JSON
    };

    List<String> stations = List.from(widget.record.completedStations);
    if (!stations.contains('blood_pressure')) stations.add('blood_pressure');

    final newRecord = HealthRecord(
      studentId: widget.student.id,
      campaignId: widget.student.campaignId,
      physical: widget.record.physical,
      vision: widget.record.vision,
      bloodPressure: bp,
      general: widget.record.general,
      completedStations: stations,
    );

    final success = await vm.saveRecord(newRecord, widget.student);
    if (success && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StationFormViewModel>();
    return SharedStationLayout(
      student: widget.student,
      stationId: 'blood_pressure',
      title: 'Đo huyết áp',
      icon: Icons.favorite_border_rounded,
      isLoading: vm.isLoading,
      onSave: _save,
      formContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: StationUIHelpers.buildTextField('Tâm thu (mmHg)', 'VD: 120', _systolicCtrl, isNumber: true)),
              const SizedBox(width: 16),
              Expanded(child: StationUIHelpers.buildTextField('Tâm trương (mmHg)', 'VD: 80', _diastolicCtrl, isNumber: true)),
            ],
          ),

          // ✨ Hiển thị kết quả tự động đánh giá (Tone màu Trắng/Hồng chủ đạo)
          if (_categoryResult.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _categoryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _categoryColor.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Text('Đánh giá tự động', style: TextStyle(fontSize: 12, color: _categoryColor.withOpacity(0.8), fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(_categoryResult, style: TextStyle(fontSize: 18, color: _categoryColor, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],

          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),

          // ✨ Bảng chú giải tham khảo theo đúng hình ảnh
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
                    const Text('Bảng phân loại tham khảo:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 12),
                _buildReferenceRow('Bình thường:', 'Tâm thu < 120 mmHg và tâm trương < 80 mmHg.', Colors.green),
                _buildReferenceRow('Tiền cao huyết áp:', 'Tâm thu 130 – 139 mmHg và/hoặc tâm trương 85 – 89 mmHg.', Colors.pink.shade400),
                _buildReferenceRow('Cao huyết áp độ 1:', 'Tâm thu 140 – 159 mmHg và/hoặc tâm trương 90 – 99 mmHg.', Colors.orange.shade600),
                _buildReferenceRow('Cao huyết áp độ 2:', 'Tâm thu ≥ 160 mmHg và/hoặc tâm trương ≥ 100 mmHg.', Colors.orange.shade800),
                _buildReferenceRow('Cao huyết áp độ 3:', 'Tâm thu ≥ 180 mmHg và/hoặc tâm trương ≥ 110 mmHg (Nguy hiểm).', Colors.red.shade700),
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