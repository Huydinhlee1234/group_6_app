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

  String _categoryResult = '';
  Color _categoryColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    if (widget.record.vision != null) {
      _leftEyeCtrl.text = widget.record.vision!['leftEye'] ?? '';
      _rightEyeCtrl.text = widget.record.vision!['rightEye'] ?? '';
      _visionNotesCtrl.text = widget.record.vision!['notes'] ?? '';
      _evaluateVision();
    }

    // Lắng nghe thay đổi để tự động đánh giá
    _leftEyeCtrl.addListener(_evaluateVision);
    _rightEyeCtrl.addListener(_evaluateVision);
  }

  @override
  void dispose() {
    _leftEyeCtrl.dispose();
    _rightEyeCtrl.dispose();
    _visionNotesCtrl.dispose();
    super.dispose();
  }

  // Hàm bóc tách số liệu (Hỗ trợ nhập "8", "8.5" hoặc "8/10")
  double? _parseVisionValue(String text) {
    if (text.trim().isEmpty) return null;
    try {
      // Lấy phần tử đầu tiên trước dấu "/" và thay dấu phẩy thành chấm
      String cleanText = text.split('/').first.replaceAll(',', '.').trim();
      return double.tryParse(cleanText);
    } catch (_) {
      return null;
    }
  }

  // ✨ Logic đánh giá thị lực tự động theo chuẩn WHO (Quy đổi thang 10)
  void _evaluateVision() {
    final left = _parseVisionValue(_leftEyeCtrl.text);
    final right = _parseVisionValue(_rightEyeCtrl.text);

    if (left == null || right == null) {
      setState(() => _categoryResult = '');
      return;
    }

    // Đánh giá dựa trên mắt có thị lực kém hơn
    final minVision = left < right ? left : right;
    String category = '';
    Color color = Colors.grey;

    if (minVision >= 8) {
      category = 'Thị lực bình thường';
      color = Colors.green.shade600;
    } else if (minVision >= 4) {
      category = 'Giảm thị lực nhẹ (Nghi ngờ tật khúc xạ)';
      color = Colors.orange.shade600;
    } else if (minVision >= 1) {
      category = 'Giảm thị lực vừa (Cần đo kính ngay)';
      color = Colors.orange.shade800;
    } else {
      category = 'Giảm thị lực nặng (Cần khám chuyên khoa)';
      color = Colors.red.shade700;
    }

    setState(() {
      _categoryResult = category;
      _categoryColor = color;
    });
  }

  Future<void> _save() async {
    final vm = context.read<StationFormViewModel>();
    final vis = {
      'leftEye': _leftEyeCtrl.text.trim(),
      'rightEye': _rightEyeCtrl.text.trim(),
      'notes': _visionNotesCtrl.text.trim(),
      'category': _categoryResult // ✨ Lưu thêm kết quả phân loại
    };

    List<String> stations = List.from(widget.record.completedStations);
    if (!stations.contains('vision')) stations.add('vision');

    final newRecord = HealthRecord(
      studentId: widget.student.id,
      campaignId: widget.student.campaignId,
      physical: widget.record.physical,
      vision: vis,
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
    return SharedStationLayout(
      student: widget.student,
      stationId: 'vision',
      title: 'Khám thị lực',
      icon: Icons.remove_red_eye_outlined,
      isLoading: vm.isLoading,
      onSave: _save,
      formContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: StationUIHelpers.buildTextField('Mắt trái (MP)', 'VD: 10/10', _leftEyeCtrl)),
              const SizedBox(width: 16),
              Expanded(child: StationUIHelpers.buildTextField('Mắt phải (MT)', 'VD: 8/10', _rightEyeCtrl)),
            ],
          ),

          // ✨ Hộp cảnh báo tự động đánh giá
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
                  Text('Đánh giá sơ bộ (Dựa trên mắt kém hơn)', style: TextStyle(fontSize: 12, color: _categoryColor.withOpacity(0.8), fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(_categoryResult, style: TextStyle(fontSize: 16, color: _categoryColor, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),
          StationUIHelpers.buildTextField('Ghi chú (Không bắt buộc)', 'VD: Đang đeo kính cận 2 độ...', _visionNotesCtrl, maxLines: 2),

          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),

          // ✨ Bảng chú giải chuẩn Y khoa
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
                    const Text('Phân loại thị lực tham khảo (WHO):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 12),
                _buildReferenceRow('8/10 - 10/10:', 'Thị lực bình thường.', Colors.green),
                _buildReferenceRow('4/10 - 7/10:', 'Giảm thị lực nhẹ (Nên đo khúc xạ).', Colors.orange.shade600),
                _buildReferenceRow('1/10 - 3/10:', 'Giảm thị lực vừa (Cần can thiệp kính).', Colors.orange.shade800),
                _buildReferenceRow('< 1/10:', 'Giảm thị lực nặng (Khám chuyên khoa gấp).', Colors.red.shade700),
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