import 'package:flutter/material.dart';

class ReportExportDialog extends StatefulWidget {
  final String exportType; // 'pdf' hoặc 'excel'
  final String defaultCampaignName;
  final Function(String title, String notes) onConfirm;

  const ReportExportDialog({
    super.key,
    required this.exportType,
    required this.defaultCampaignName,
    required this.onConfirm,
  });

  @override
  State<ReportExportDialog> createState() => _ReportExportDialogState();
}

class _ReportExportDialogState extends State<ReportExportDialog> {
  late TextEditingController _titleCtrl;
  final _notesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Đặt tên mặc định cho báo cáo
    _titleCtrl = TextEditingController(text: 'Báo cáo: ${widget.defaultCampaignName}');
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPdf = widget.exportType == 'pdf';
    final color = isPdf ? Colors.red.shade600 : Colors.green.shade700;
    final icon = isPdf ? Icons.picture_as_pdf_rounded : Icons.table_view_rounded;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: Container(
        width: 450,
        padding: const EdgeInsets.all(24.0),
        // Sử dụng SingleChildScrollView để tránh tràn màn hình khi bàn phím xuất hiện
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    child: Icon(icon, color: color, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Xuất báo cáo ${isPdf ? 'PDF' : 'Excel'}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Cấu hình thông tin trước khi chia sẻ', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Form Fields
              const Text('Tên báo cáo *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 8),
              TextField(
                controller: _titleCtrl,
                decoration: InputDecoration(
                  hintText: 'Nhập tên báo cáo...',
                  filled: true, fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 16),

              const Text('Ghi chú thêm (Tùy chọn)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 8),
              TextField(
                controller: _notesCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Nhập người lập, đơn vị, hoặc các ghi chú khác...',
                  filled: true, fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 32),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: Text('Hủy', style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2, // Đưa nhiều không gian hơn cho nút Xác nhận
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final title = _titleCtrl.text.trim();
                        if (title.isEmpty) return;

                        Navigator.pop(context); // Đóng form
                        widget.onConfirm(title, _notesCtrl.text.trim()); // Gọi hàm xuất
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.share_rounded, size: 18),
                      label: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Xác nhận & Chia sẻ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
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
}