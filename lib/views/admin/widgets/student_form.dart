// import 'package:flutter/material.dart';
// import '../../../domain/entities/campaign.dart';
// import '../../../domain/entities/student.dart';
//
// class StudentForm extends StatefulWidget {
//   final Student? student;
//   final List<Campaign> campaigns;
//   final String? initialCampaignId;
//   final Function(Map<String, dynamic> data) onSave;
//
//   const StudentForm({
//     super.key,
//     this.student,
//     required this.campaigns,
//     this.initialCampaignId,
//     required this.onSave
//   });
//
//   @override
//   State<StudentForm> createState() => _StudentFormState();
// }
//
// class _StudentFormState extends State<StudentForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _codeController = TextEditingController();
//   final _nameController = TextEditingController();
//   final _classController = TextEditingController();
//   final _emailController = TextEditingController(); // ✨ ĐÃ THÊM: Quản lý ô nhập Email
//
//   String? _selectedCampaignId;
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.student != null) {
//       _codeController.text = widget.student!.studentCode;
//       _nameController.text = widget.student!.name;
//       _classController.text = widget.student!.className;
//       _emailController.text = widget.student!.email; // ✨ ĐÃ THÊM: Gán sẵn dữ liệu nếu đang sửa
//     }
//
//     if (widget.initialCampaignId != null && widget.initialCampaignId != 'all') {
//       _selectedCampaignId = widget.initialCampaignId;
//     } else if (widget.campaigns.isNotEmpty) {
//       _selectedCampaignId = widget.campaigns.first.id;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       backgroundColor: Colors.white,
//       child: Container(
//         width: 400,
//         constraints: const BoxConstraints(maxHeight: 750), // Tăng nhẹ chiều cao để chứa thêm ô nhập liệu
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(colors: [Colors.purple, Colors.pink]),
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: const Icon(Icons.person_rounded, color: Colors.white, size: 24),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Text(
//                         widget.student != null ? 'Chỉnh sửa sinh viên' : 'Thêm sinh viên mới',
//                         style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 24),
//
//                 _buildLabel('Mã sinh viên'),
//                 TextFormField(
//                   controller: _codeController,
//                   decoration: _inputDecoration('VD: SV001', Icons.tag_rounded),
//                   validator: (val) => val == null || val.trim().isEmpty ? 'Bắt buộc' : null,
//                 ),
//                 const SizedBox(height: 16),
//
//                 _buildLabel('Họ và tên'),
//                 TextFormField(
//                   controller: _nameController,
//                   decoration: _inputDecoration('VD: Nguyễn Văn A', Icons.person_outline_rounded),
//                   validator: (val) => val == null || val.trim().isEmpty ? 'Bắt buộc' : null,
//                 ),
//                 const SizedBox(height: 16),
//
//                 _buildLabel('Lớp'),
//                 TextFormField(
//                   controller: _classController,
//                   decoration: _inputDecoration('VD: CNTT-K62', Icons.school_outlined),
//                   validator: (val) => val == null || val.trim().isEmpty ? 'Bắt buộc' : null,
//                 ),
//                 const SizedBox(height: 16),
//
//                 // ✨ ĐÃ THÊM: Giao diện nhập Email
//                 _buildLabel('Email liên hệ'),
//                 TextFormField(
//                   controller: _emailController,
//                   keyboardType: TextInputType.emailAddress,
//                   decoration: _inputDecoration('VD: sv001@truong.edu.vn', Icons.email_outlined),
//                   validator: (val) {
//                     if (val == null || val.trim().isEmpty) return 'Bắt buộc';
//                     if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) return 'Email không hợp lệ';
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//
//                 _buildLabel('Thuộc chiến dịch'),
//                 DropdownButtonFormField<String>(
//                   isExpanded: true,
//                   value: widget.campaigns.any((c) => c.id == _selectedCampaignId) ? _selectedCampaignId : null,
//                   decoration: _inputDecoration('Chọn chiến dịch', Icons.event_note_rounded),
//                   items: widget.campaigns.map((c) => DropdownMenuItem(
//                     value: c.id,
//                     child: Text(c.name, maxLines: 1, overflow: TextOverflow.ellipsis),
//                   )).toList(),
//                   onChanged: (val) => setState(() => _selectedCampaignId = val),
//                   validator: (val) => val == null ? 'Vui lòng chọn chiến dịch' : null,
//                 ),
//                 const SizedBox(height: 32),
//
//                 Row(
//                   children: [
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: () => Navigator.pop(context),
//                         style: OutlinedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                           side: BorderSide(color: Colors.grey.shade300, width: 2),
//                         ),
//                         child: const Text('Hủy', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Container(
//                         decoration: BoxDecoration(
//                           gradient: const LinearGradient(colors: [Colors.purple, Colors.pink]),
//                           borderRadius: BorderRadius.circular(12),
//                           boxShadow: [BoxShadow(color: Colors.pink.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
//                         ),
//                         child: ElevatedButton(
//                           onPressed: _submit,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.transparent,
//                             shadowColor: Colors.transparent,
//                             padding: const EdgeInsets.symmetric(vertical: 14),
//                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                           ),
//                           child: Text(
//                             widget.student != null ? 'Cập nhật' : 'Thêm mới',
//                             style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _submit() {
//     if (_formKey.currentState!.validate()) {
//       widget.onSave({
//         'id': widget.student?.id,
//         'studentCode': _codeController.text.trim(),
//         'name': _nameController.text.trim(),
//         'className': _classController.text.trim(),
//         'email': _emailController.text.trim(), // ✨ ĐÃ THÊM: Đóng gói và gửi Email ra ngoài
//         'campaignId': _selectedCampaignId,
//       });
//       Navigator.pop(context);
//     }
//   }
//
//   Widget _buildLabel(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: RichText(text: TextSpan(children: [
//         TextSpan(text: text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
//         const TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
//       ])),
//     );
//   }
//
//   InputDecoration _inputDecoration(String hint, IconData icon) {
//     return InputDecoration(
//       hintText: hint,
//       prefixIcon: Icon(icon, color: Colors.grey.shade400),
//       filled: true,
//       fillColor: Colors.white,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300, width: 2)),
//       enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300, width: 2)),
//       focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.purple, width: 2)),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../../../domain/entities/campaign.dart';
import '../../../domain/entities/student.dart';

class StudentForm extends StatefulWidget {
  final Student? student;
  final List<Campaign> campaigns;
  final List<Student> existingStudents; // ✨ THÊM MỚI: Nhận danh sách SV để check trùng
  final String? initialCampaignId;
  final Function(Map<String, dynamic> data) onSave;

  const StudentForm({
    super.key,
    this.student,
    required this.campaigns,
    required this.existingStudents, // ✨ THÊM MỚI: Bắt buộc truyền vào
    this.initialCampaignId,
    required this.onSave
  });

  @override
  State<StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _classController = TextEditingController();
  final _emailController = TextEditingController();

  String? _selectedCampaignId;

  @override
  void initState() {
    super.initState();
    if (widget.student != null) {
      _codeController.text = widget.student!.studentCode;
      _nameController.text = widget.student!.name;
      _classController.text = widget.student!.className;
      _emailController.text = widget.student!.email;
    }

    if (widget.initialCampaignId != null && widget.initialCampaignId != 'all') {
      _selectedCampaignId = widget.initialCampaignId;
    } else if (widget.campaigns.isNotEmpty) {
      _selectedCampaignId = widget.campaigns.first.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Container(
        width: 400,
        constraints: const BoxConstraints(maxHeight: 750),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Colors.purple, Colors.pink]),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.person_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        widget.student != null ? 'Chỉnh sửa sinh viên' : 'Thêm sinh viên mới',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                _buildLabel('Mã sinh viên'),
                TextFormField(
                  controller: _codeController,
                  decoration: _inputDecoration('VD: SV001', Icons.tag_rounded),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Bắt buộc';

                    // ✨ LOGIC KIỂM TRA TRÙNG MÃ SV CỰC CHUẨN
                    if (_selectedCampaignId != null) {
                      final isDuplicate = widget.existingStudents.any((s) =>
                      s.campaignId == _selectedCampaignId && // Trùng chiến dịch
                          s.studentCode.toLowerCase() == val.trim().toLowerCase() && // Trùng mã (Không phân biệt hoa/thường)
                          s.id != widget.student?.id // Bỏ qua chính nó nếu đang ở chế độ "Chỉnh sửa"
                      );
                      if (isDuplicate) return 'Mã SV này đã tồn tại trong chiến dịch!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildLabel('Họ và tên'),
                TextFormField(
                  controller: _nameController,
                  decoration: _inputDecoration('VD: Nguyễn Văn A', Icons.person_outline_rounded),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Bắt buộc' : null,
                ),
                const SizedBox(height: 16),

                _buildLabel('Lớp'),
                TextFormField(
                  controller: _classController,
                  decoration: _inputDecoration('VD: CNTT-K62', Icons.school_outlined),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Bắt buộc' : null,
                ),
                const SizedBox(height: 16),

                _buildLabel('Email liên hệ'),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration('VD: sv001@truong.edu.vn', Icons.email_outlined),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Bắt buộc';
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) return 'Email không hợp lệ';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildLabel('Thuộc chiến dịch'),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: widget.campaigns.any((c) => c.id == _selectedCampaignId) ? _selectedCampaignId : null,
                  decoration: _inputDecoration('Chọn chiến dịch', Icons.event_note_rounded),
                  items: widget.campaigns.map((c) => DropdownMenuItem(
                    value: c.id,
                    child: Text(c.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                  )).toList(),
                  onChanged: (val) {
                    setState(() => _selectedCampaignId = val);
                    // Ép form kiểm tra lại lỗi trùng mã SV khi đổi chiến dịch
                    _formKey.currentState?.validate();
                  },
                  validator: (val) => val == null ? 'Vui lòng chọn chiến dịch' : null,
                ),
                const SizedBox(height: 32),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          side: BorderSide(color: Colors.grey.shade300, width: 2),
                        ),
                        child: const Text('Hủy', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Colors.purple, Colors.pink]),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: Colors.pink.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
                        ),
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            widget.student != null ? 'Cập nhật' : 'Thêm mới',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSave({
        'id': widget.student?.id,
        'studentCode': _codeController.text.trim(),
        'name': _nameController.text.trim(),
        'className': _classController.text.trim(),
        'email': _emailController.text.trim(),
        'campaignId': _selectedCampaignId,
      });
      Navigator.pop(context);
    }
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(text: TextSpan(children: [
        TextSpan(text: text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
        const TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
      ])),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.grey.shade400),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      errorMaxLines: 2, // Cho phép dòng lỗi hiển thị thành 2 dòng nếu quá dài
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300, width: 2)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300, width: 2)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.purple, width: 2)),
    );
  }
}