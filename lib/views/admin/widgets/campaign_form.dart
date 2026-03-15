import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/campaign.dart';

class CampaignForm extends StatefulWidget {
  final Campaign? campaign;
  final Function(Campaign) onSave;

  const CampaignForm({super.key, this.campaign, required this.onSave});

  @override
  State<CampaignForm> createState() => _CampaignFormState();
}

class _CampaignFormState extends State<CampaignForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl, _locationCtrl;

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.campaign?.name ?? '');
    _locationCtrl = TextEditingController(text: widget.campaign?.location ?? '');

    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    if (widget.campaign != null) {
      try { _startDate = formatter.parse(widget.campaign!.startDate); } catch (_) {}
      try { _endDate = formatter.parse(widget.campaign!.endDate); } catch (_) {}
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? (_startDate ?? DateTime.now()) : (_endDate ?? _startDate ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isStart) _startDate = picked;
        else _endDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd/MM/yyyy');

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.campaign == null ? 'Thêm Chiến Dịch' : 'Sửa Chiến Dịch', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              _buildInput('Tên chiến dịch', _nameCtrl, Icons.event_note),
              const SizedBox(height: 16),
              _buildInput('Địa điểm', _locationCtrl, Icons.place),
              const SizedBox(height: 16),

              // ✨ ĐÃ XÓA Ô CHỌN TRẠNG THÁI THỦ CÔNG TẠI ĐÂY

              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context, true),
                      child: InputDecorator(
                        decoration: InputDecoration(labelText: 'Bắt đầu', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                        child: Text(_startDate != null ? formatter.format(_startDate!) : 'dd/MM/yyyy', style: TextStyle(color: _startDate != null ? Colors.black : Colors.grey)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context, false),
                      child: InputDecorator(
                        decoration: InputDecoration(labelText: 'Kết thúc', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                        child: Text(_endDate != null ? formatter.format(_endDate!) : 'dd/MM/yyyy', style: TextStyle(color: _endDate != null ? Colors.black : Colors.grey)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text('Hủy'))),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_startDate == null || _endDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng chọn ngày!'), backgroundColor: Colors.red));
                          return;
                        }

                        // Chặn lỗi người dùng chọn ngày bắt đầu sau ngày kết thúc
                        if (_startDate!.isAfter(_endDate!)) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ngày bắt đầu không được lớn hơn ngày kết thúc!'), backgroundColor: Colors.red));
                          return;
                        }

                        if (_formKey.currentState!.validate()) {

                          // ✨ TỰ ĐỘNG SO SÁNH VỚI THỜI GIAN HIỆN TẠI ĐỂ RA TRẠNG THÁI
                          String autoStatus = 'active';
                          final now = DateTime.now();

                          // Đưa tất cả về mốc 0h00 để so sánh chuẩn xác
                          final today = DateTime(now.year, now.month, now.day);
                          final startDay = DateTime(_startDate!.year, _startDate!.month, _startDate!.day);
                          final endDay = DateTime(_endDate!.year, _endDate!.month, _endDate!.day);

                          if (today.isAfter(endDay)) {
                            autoStatus = 'completed'; // Đã kết thúc
                          } else if (today.isBefore(startDay)) {
                            autoStatus = 'upcoming'; // Sắp tới
                          } else {
                            autoStatus = 'active'; // Đang diễn ra
                          }

                          widget.onSave(Campaign(
                            id: widget.campaign?.id ?? const Uuid().v4(),
                            name: _nameCtrl.text.trim(),
                            location: _locationCtrl.text.trim(),
                            startDate: formatter.format(_startDate!),
                            endDate: formatter.format(_endDate!),
                            status: autoStatus, // ✨ Lưu trạng thái tự động tính toán
                          ));
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: const Text('Lưu', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, size: 20, color: Colors.grey), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
      validator: (v) => v!.isEmpty ? 'Bắt buộc' : null,
    );
  }
}