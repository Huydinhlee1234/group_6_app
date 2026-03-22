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

              // ✨ ĐÃ SỬA: Actions (2 Nút cân đối, chống tràn viền)
              // Actions (Đã fix cứng tỷ lệ 1:1 và đồng bộ kích cỡ chữ)
              Row(
                children: [
                  Expanded(
                    flex: 1, // Ép cứng tỷ lệ bằng nhau
                    child: SizedBox(
                      height: 48, // Khóa cố định chiều cao cho 2 nút bằng nhau chằn chặn
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          'Hủy',
                          style: TextStyle(color: Colors.grey.shade700, fontSize: 14, fontWeight: FontWeight.bold),
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1, // Ép cứng tỷ lệ bằng nhau
                    child: SizedBox(
                      height: 48, // Khóa cố định chiều cao
                      child: ElevatedButton(
                        onPressed: () {
                          final title = _titleCtrl.text.trim();
                          if (title.isEmpty) return;

                          Navigator.pop(context); // Đóng form
                          widget.onConfirm(title, _notesCtrl.text.trim()); // Gọi hàm xuất
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 4), // Giảm padding ngang để chứa đủ chữ
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.share_rounded, size: 16),
                            SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'Xác nhận', // Rút gọn chữ một chút để nút không bị quá chật
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
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