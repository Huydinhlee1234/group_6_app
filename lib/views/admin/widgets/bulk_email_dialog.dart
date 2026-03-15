// import 'package:flutter/material.dart';
// import '../../../domain/entities/student.dart';
//
// // Định nghĩa dữ liệu mẫu
// final List<Map<String, String>> emailTemplates = [
//   {
//     'id': 'reminder',
//     'name': 'Nhắc nhở khám sức khỏe',
//     'subject': 'Thông báo: Nhắc nhở tham gia khám sức khỏe',
//     'content': 'Kính gửi sinh viên [Tên],\n\nNhà trường xin nhắc nhở bạn tham gia chương trình khám sức khỏe định kỳ.\n\nThông tin chi tiết:\n- Mã sinh viên: [Mã SV]\n- Thời gian: [Thời gian khám]\n- Địa điểm: [Địa điểm khám]\n\nVui lòng mang theo mã QR đính kèm để quét khi khám.\n\nTrân trọng,\nPhòng Y tế'
//   },
//   {
//     'id': 'schedule',
//     'name': 'Lịch khám kèm mã QR',
//     'subject': 'Thông báo: Lịch khám sức khỏe và mã QR cá nhân',
//     'content': 'Kính gửi sinh viên [Tên],\n\nNhà trường thông báo lịch khám sức khỏe định kỳ cho sinh viên.\n\nMọi thắc mắc xin liên hệ phòng Y tế.\n\nTrân trọng,\nPhòng Y tế'
//   },
//   {
//     'id': 'completion',
//     'name': 'Thông báo hoàn thành',
//     'subject': 'Thông báo: Bạn đã hoàn thành khám sức khỏe',
//     'content': 'Kính gửi sinh viên,\n\nChúc mừng bạn đã hoàn thành toàn bộ quy trình khám sức khỏe!\n\nKết quả khám sức khỏe của bạn đã được cập nhật vào hệ thống.\n\nTrân trọng,\nPhòng Y tế'
//   },
// ];
//
// class BulkEmailDialog extends StatefulWidget {
//   final List<Student> students;
//
//   const BulkEmailDialog({super.key, required this.students});
//
//   @override
//   State<BulkEmailDialog> createState() => _BulkEmailDialogState();
// }
//
// class _BulkEmailDialogState extends State<BulkEmailDialog> {
//   String _filter = 'all';
//   String _selectedClass = '';
//   String _selectedTemplateId = 'reminder';
//   String _subject = '';
//   String _content = '';
//   bool _includeQR = false;
//   bool _isPreviewMode = false;
//
//   late TextEditingController _subjectController;
//   late TextEditingController _contentController;
//
//   @override
//   void initState() {
//     super.initState();
//     _applyTemplate('reminder');
//   }
//
//   void _applyTemplate(String templateId) {
//     final template = emailTemplates.firstWhere((t) => t['id'] == templateId);
//     setState(() {
//       _selectedTemplateId = templateId;
//       _subject = template['subject']!;
//       _content = template['content']!;
//       _subjectController = TextEditingController(text: _subject);
//       _contentController = TextEditingController(text: _content);
//     });
//   }
//
//   List<Student> get _recipients {
//     switch (_filter) {
//       case 'completed': return widget.students.where((s) => s.status == 'completed').toList();
//       case 'in_progress': return widget.students.where((s) => s.status == 'in_progress').toList();
//       case 'not_started': return widget.students.where((s) => s.status == 'not_started' || s.status == 'pending').toList();
//       case 'by_class': return widget.students.where((s) => s.className == _selectedClass).toList();
//       default: return widget.students;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final classes = widget.students.map((s) => s.className).toSet().toList()..sort();
//     final recipients = _recipients;
//
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       backgroundColor: Colors.white,
//       child: Container(
//         width: 700,
//         constraints: const BoxConstraints(maxHeight: 800),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Header
//             Padding(
//               padding: const EdgeInsets.all(24.0),
//               child: Row(
//                 children: [
//                   Icon(Icons.mail_rounded, color: Colors.blue.shade600),
//                   const SizedBox(width: 12),
//                   const Text('Gửi email hàng loạt', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   const Spacer(),
//                   IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop(), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
//                 ],
//               ),
//             ),
//             const Divider(height: 1),
//
//             // Body
//             Flexible(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(24.0),
//                 child: _isPreviewMode ? _buildPreviewStep(recipients) : _buildComposeStep(classes, recipients),
//               ),
//             ),
//
//             const Divider(height: 1),
//             // Footer (Buttons)
//             Padding(
//               padding: const EdgeInsets.all(24.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: _isPreviewMode
//                     ? [
//                   OutlinedButton(onPressed: () => setState(() => _isPreviewMode = false), child: const Text('Quay lại')),
//                   const SizedBox(width: 12),
//                   ElevatedButton.icon(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đã gửi email thành công cho ${recipients.length} sinh viên!', style: const TextStyle(color: Colors.white)), backgroundColor: Colors.green));
//                     },
//                     icon: const Icon(Icons.send_rounded, size: 16),
//                     label: Text('Gửi email (${recipients.length})'),
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade600, foregroundColor: Colors.white),
//                   ),
//                 ]
//                     : [
//                   OutlinedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Hủy')),
//                   const SizedBox(width: 12),
//                   ElevatedButton(
//                     onPressed: (_subject.trim().isEmpty || _content.trim().isEmpty || recipients.isEmpty || (_filter == 'by_class' && _selectedClass.isEmpty))
//                         ? null
//                         : () => setState(() => _isPreviewMode = true),
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade600, foregroundColor: Colors.white),
//                     child: const Text('Tiếp tục'),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildComposeStep(List<String> classes, List<Student> recipients) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildLabel('Chọn đối tượng nhận email'),
//         DropdownButtonFormField<String>(
//           value: _filter,
//           decoration: _inputDecoration(),
//           items: const [
//             DropdownMenuItem(value: 'all', child: Text('Tất cả sinh viên')),
//             DropdownMenuItem(value: 'completed', child: Text('Đã hoàn thành khám')),
//             DropdownMenuItem(value: 'in_progress', child: Text('Đang khám')),
//             DropdownMenuItem(value: 'not_started', child: Text('Chưa bắt đầu')),
//             DropdownMenuItem(value: 'by_class', child: Text('Theo lớp')),
//           ],
//           onChanged: (val) => setState(() => _filter = val!),
//         ),
//
//         if (_filter == 'by_class') ...[
//           const SizedBox(height: 16),
//           _buildLabel('Chọn lớp'),
//           DropdownButtonFormField<String>(
//             value: _selectedClass.isEmpty ? null : _selectedClass,
//             decoration: _inputDecoration(hint: 'Chọn lớp...'),
//             items: classes.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
//             onChanged: (val) => setState(() => _selectedClass = val!),
//           ),
//         ],
//
//         const SizedBox(height: 16),
//         Container(
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.blue.shade100)),
//           child: Row(
//             children: [
//               Icon(Icons.people_alt_rounded, color: Colors.blue.shade700, size: 20),
//               const SizedBox(width: 8),
//               Text('Số người nhận: ${recipients.length} sinh viên', style: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.bold)),
//             ],
//           ),
//         ),
//
//         const SizedBox(height: 24),
//         _buildLabel('Chọn mẫu email'),
//         DropdownButtonFormField<String>(
//           value: _selectedTemplateId,
//           decoration: _inputDecoration(),
//           items: emailTemplates.map((t) => DropdownMenuItem(value: t['id'], child: Text(t['name']!))).toList(),
//           onChanged: (val) => _applyTemplate(val!),
//         ),
//
//         if (_selectedTemplateId == 'reminder' || _selectedTemplateId == 'schedule') ...[
//           const SizedBox(height: 16),
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)),
//             child: CheckboxListTile(
//               title: const Text('Đính kèm mã QR cá nhân cho từng sinh viên', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
//               subtitle: const Text('Mỗi sinh viên sẽ nhận được mã QR riêng để sử dụng khi khám', style: TextStyle(fontSize: 12)),
//               value: _includeQR,
//               onChanged: (val) => setState(() => _includeQR = val!),
//               controlAffinity: ListTileControlAffinity.leading,
//               contentPadding: EdgeInsets.zero,
//               activeColor: Colors.blue.shade600,
//             ),
//           ),
//         ],
//
//         const SizedBox(height: 24),
//         _buildLabel('Tiêu đề *'),
//         TextField(controller: _subjectController, decoration: _inputDecoration(hint: 'Nhập tiêu đề email...'), onChanged: (val) => _subject = val),
//
//         const SizedBox(height: 16),
//         _buildLabel('Nội dung *'),
//         TextField(
//           controller: _contentController,
//           maxLines: 10,
//           decoration: _inputDecoration(hint: 'Nhập nội dung email...'),
//           style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
//           onChanged: (val) => _content = val,
//         ),
//         const SizedBox(height: 4),
//         Text('Mẹo: Sử dụng [Tên], [Mã SV] để tự động thay thế thông tin', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
//       ],
//     );
//   }
//
//   Widget _buildPreviewStep(List<Student> recipients) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.blue.shade200)),
//           child: Row(
//             children: [
//               Icon(Icons.info_outline_rounded, color: Colors.blue.shade600),
//               const SizedBox(width: 8),
//               Text('Xem lại thông tin trước khi gửi', style: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.w500)),
//             ],
//           ),
//         ),
//         const SizedBox(height: 24),
//         _buildLabel('Người nhận (${recipients.length} sinh viên)'),
//         Container(
//           width: double.infinity,
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)),
//           child: Wrap(
//             spacing: 8,
//             runSpacing: 8,
//             children: recipients.take(15).map((s) => Chip(label: Text(s.name, style: const TextStyle(fontSize: 12)), backgroundColor: Colors.white)).toList()
//               ..addAll(recipients.length > 15 ? [Chip(label: Text('+${recipients.length - 15} người khác', style: const TextStyle(fontSize: 12)), backgroundColor: Colors.blue.shade50)] : []),
//           ),
//         ),
//         const SizedBox(height: 16),
//         _buildLabel('Tiêu đề'),
//         Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)), child: Text(_subject, style: const TextStyle(fontWeight: FontWeight.bold))),
//         const SizedBox(height: 16),
//         _buildLabel('Nội dung'),
//         Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)), child: Text(_content, style: const TextStyle(fontFamily: 'monospace', fontSize: 13))),
//         const SizedBox(height: 24),
//         Container(
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.red.shade200)),
//           child: Row(
//             children: [
//               Icon(Icons.warning_amber_rounded, color: Colors.red.shade600),
//               const SizedBox(width: 8),
//               Expanded(child: Text('Hành động này sẽ gửi email đến ${recipients.length} sinh viên. Vui lòng kiểm tra kỹ trước khi xác nhận.', style: TextStyle(color: Colors.red.shade800, fontSize: 13))),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildLabel(String text) => Padding(padding: const EdgeInsets.only(bottom: 8.0), child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)));
//
//   InputDecoration _inputDecoration({String? hint}) => InputDecoration(
//     hintText: hint,
//     filled: true,
//     fillColor: Colors.white,
//     contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//     border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
//     enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
//     focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.blue.shade400)),
//   );
// }

import 'package:flutter/material.dart';
import '../../../domain/entities/student.dart';

final List<Map<String, String>> emailTemplates = [
  {
    'id': 'reminder',
    'name': 'Nhắc nhở khám sức khỏe',
    'subject': 'Thông báo: Nhắc nhở tham gia khám sức khỏe',
    'content': 'Kính gửi sinh viên [Tên],\n\nNhà trường xin nhắc nhở bạn tham gia chương trình khám sức khỏe định kỳ.\n\nThông tin chi tiết:\n- Mã sinh viên: [Mã SV]\n- Thời gian: [Thời gian khám]\n- Địa điểm: [Địa điểm khám]\n\nVui lòng mang theo mã QR đính kèm để quét khi khám.\n\nTrân trọng,\nPhòng Y tế'
  },
  {
    'id': 'schedule',
    'name': 'Lịch khám kèm mã QR',
    'subject': 'Thông báo: Lịch khám sức khỏe và mã QR cá nhân',
    'content': 'Kính gửi sinh viên [Tên],\n\nNhà trường thông báo lịch khám sức khỏe định kỳ cho sinh viên.\n\nMọi thắc mắc xin liên hệ phòng Y tế.\n\nTrân trọng,\nPhòng Y tế'
  },
  {
    'id': 'completion',
    'name': 'Thông báo hoàn thành',
    'subject': 'Thông báo: Bạn đã hoàn thành khám sức khỏe',
    'content': 'Kính gửi sinh viên,\n\nChúc mừng bạn đã hoàn thành toàn bộ quy trình khám sức khỏe!\n\nKết quả khám sức khỏe của bạn đã được cập nhật vào hệ thống.\n\nTrân trọng,\nPhòng Y tế'
  },
];

class BulkEmailDialog extends StatefulWidget {
  final List<Student> students;

  const BulkEmailDialog({super.key, required this.students});

  @override
  State<BulkEmailDialog> createState() => _BulkEmailDialogState();
}

class _BulkEmailDialogState extends State<BulkEmailDialog> {
  String _filter = 'all';
  String _selectedClass = '';
  String _selectedTemplateId = 'reminder';
  String _subject = '';
  String _content = '';
  bool _includeQR = false;
  bool _isPreviewMode = false;

  late TextEditingController _subjectController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _applyTemplate('reminder');
  }

  void _applyTemplate(String templateId) {
    final template = emailTemplates.firstWhere((t) => t['id'] == templateId);
    setState(() {
      _selectedTemplateId = templateId;
      _subject = template['subject']!;
      _content = template['content']!;
      _subjectController = TextEditingController(text: _subject);
      _contentController = TextEditingController(text: _content);
    });
  }

  List<Student> get _recipients {
    switch (_filter) {
      case 'completed': return widget.students.where((s) => s.status == 'completed').toList();
      case 'in_progress': return widget.students.where((s) => s.status == 'in_progress').toList();
      case 'not_started': return widget.students.where((s) => s.status == 'not_started' || s.status == 'pending').toList();
      case 'by_class': return widget.students.where((s) => s.className == _selectedClass).toList();
      default: return widget.students;
    }
  }

  @override
  Widget build(BuildContext context) {
    final classes = widget.students.map((s) => s.className).toSet().toList()..sort();
    final recipients = _recipients;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: Container(
        width: 700,
        constraints: const BoxConstraints(maxHeight: 800),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Icon(Icons.mail_rounded, color: Colors.blue.shade600),
                  const SizedBox(width: 12),
                  // ✨ FIX: Bọc tiêu đề vào Expanded để không bị tràn màn hình điện thoại
                  const Expanded(child: Text('Gửi email hàng loạt', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop(), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
                ],
              ),
            ),
            const Divider(height: 1),

            // Body
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: _isPreviewMode ? _buildPreviewStep(recipients) : _buildComposeStep(classes, recipients),
              ),
            ),

            const Divider(height: 1),
            // Footer
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: _isPreviewMode
                    ? [
                  OutlinedButton(onPressed: () => setState(() => _isPreviewMode = false), child: const Text('Quay lại')),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đã gửi email thành công cho ${recipients.length} sinh viên!', style: const TextStyle(color: Colors.white)), backgroundColor: Colors.green));
                    },
                    icon: const Icon(Icons.send_rounded, size: 16),
                    label: Text('Gửi email (${recipients.length})', maxLines: 1, overflow: TextOverflow.ellipsis),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade600, foregroundColor: Colors.white),
                  ),
                ]
                    : [
                  OutlinedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Hủy')),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: (_subject.trim().isEmpty || _content.trim().isEmpty || recipients.isEmpty || (_filter == 'by_class' && _selectedClass.isEmpty))
                        ? null
                        : () => setState(() => _isPreviewMode = true),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade600, foregroundColor: Colors.white),
                    child: const Text('Tiếp tục'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildComposeStep(List<String> classes, List<Student> recipients) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Chọn đối tượng nhận email'),
        DropdownButtonFormField<String>(
          isExpanded: true, // ✨ FIX: Thêm thuộc tính này cho toàn bộ Dropdown
          value: _filter,
          decoration: _inputDecoration(),
          items: const [
            DropdownMenuItem(value: 'all', child: Text('Tất cả sinh viên', maxLines: 1, overflow: TextOverflow.ellipsis)),
            DropdownMenuItem(value: 'completed', child: Text('Đã hoàn thành khám', maxLines: 1, overflow: TextOverflow.ellipsis)),
            DropdownMenuItem(value: 'in_progress', child: Text('Đang khám', maxLines: 1, overflow: TextOverflow.ellipsis)),
            DropdownMenuItem(value: 'not_started', child: Text('Chưa bắt đầu', maxLines: 1, overflow: TextOverflow.ellipsis)),
            DropdownMenuItem(value: 'by_class', child: Text('Theo lớp', maxLines: 1, overflow: TextOverflow.ellipsis)),
          ],
          onChanged: (val) => setState(() => _filter = val!),
        ),

        if (_filter == 'by_class') ...[
          const SizedBox(height: 16),
          _buildLabel('Chọn lớp'),
          DropdownButtonFormField<String>(
            isExpanded: true, // ✨ FIX: Thêm isExpanded
            value: _selectedClass.isEmpty ? null : _selectedClass,
            decoration: _inputDecoration(hint: 'Chọn lớp...'),
            items: classes.map((c) => DropdownMenuItem(value: c, child: Text(c, maxLines: 1, overflow: TextOverflow.ellipsis))).toList(),
            onChanged: (val) => setState(() => _selectedClass = val!),
          ),
        ],

        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.blue.shade100)),
          child: Row(
            children: [
              Icon(Icons.people_alt_rounded, color: Colors.blue.shade700, size: 20),
              const SizedBox(width: 8),
              // ✨ FIX: Bọc text "Số người nhận" vào Expanded để chống tràn
              Expanded(child: Text('Số người nhận: ${recipients.length} sinh viên', style: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis)),
            ],
          ),
        ),

        const SizedBox(height: 24),
        _buildLabel('Chọn mẫu email'),
        DropdownButtonFormField<String>(
          isExpanded: true, // ✨ FIX: Thêm isExpanded để chống tràn tên mẫu email
          value: _selectedTemplateId,
          decoration: _inputDecoration(),
          items: emailTemplates.map((t) => DropdownMenuItem(value: t['id'], child: Text(t['name']!, maxLines: 1, overflow: TextOverflow.ellipsis))).toList(),
          onChanged: (val) => _applyTemplate(val!),
        ),

        if (_selectedTemplateId == 'reminder' || _selectedTemplateId == 'schedule') ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)),
            child: CheckboxListTile(
              title: const Text('Đính kèm mã QR cá nhân cho từng sinh viên', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              subtitle: const Text('Mỗi sinh viên sẽ nhận được mã QR riêng để sử dụng khi khám', style: TextStyle(fontSize: 12)),
              value: _includeQR,
              onChanged: (val) => setState(() => _includeQR = val!),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              activeColor: Colors.blue.shade600,
            ),
          ),
        ],

        const SizedBox(height: 24),
        _buildLabel('Tiêu đề *'),
        TextField(controller: _subjectController, decoration: _inputDecoration(hint: 'Nhập tiêu đề email...'), onChanged: (val) => _subject = val),

        const SizedBox(height: 16),
        _buildLabel('Nội dung *'),
        TextField(
          controller: _contentController,
          maxLines: 10,
          decoration: _inputDecoration(hint: 'Nhập nội dung email...'),
          style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
          onChanged: (val) => _content = val,
        ),
        const SizedBox(height: 4),
        Text('Mẹo: Sử dụng [Tên], [Mã SV] để tự động thay thế thông tin', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
      ],
    );
  }

  Widget _buildPreviewStep(List<Student> recipients) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.blue.shade200)),
          child: Row(
            children: [
              Icon(Icons.info_outline_rounded, color: Colors.blue.shade600),
              const SizedBox(width: 8),
              Expanded(child: Text('Xem lại thông tin trước khi gửi', style: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.w500))),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildLabel('Người nhận (${recipients.length} sinh viên)'),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: recipients.take(15).map((s) => Chip(label: Text(s.name, style: const TextStyle(fontSize: 12)), backgroundColor: Colors.white)).toList()
              ..addAll(recipients.length > 15 ? [Chip(label: Text('+${recipients.length - 15} người khác', style: const TextStyle(fontSize: 12)), backgroundColor: Colors.blue.shade50)] : []),
          ),
        ),
        const SizedBox(height: 16),
        _buildLabel('Tiêu đề'),
        Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)), child: Text(_subject, style: const TextStyle(fontWeight: FontWeight.bold))),
        const SizedBox(height: 16),
        _buildLabel('Nội dung'),
        Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)), child: Text(_content, style: const TextStyle(fontFamily: 'monospace', fontSize: 13))),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.red.shade200)),
          child: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red.shade600),
              const SizedBox(width: 8),
              Expanded(child: Text('Hành động này sẽ gửi email đến ${recipients.length} sinh viên. Vui lòng kiểm tra kỹ trước khi xác nhận.', style: TextStyle(color: Colors.red.shade800, fontSize: 13))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) => Padding(padding: const EdgeInsets.only(bottom: 8.0), child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)));

  InputDecoration _inputDecoration({String? hint}) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.blue.shade400)),
  );
}