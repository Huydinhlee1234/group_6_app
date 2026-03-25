// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:excel/excel.dart' hide Border, BorderStyle;
// import '../../../domain/entities/student.dart';
//
// class ImportStudentDialog extends StatefulWidget {
//   final List<Student> existingStudents;
//   final Function(List<Map<String, dynamic>> importedData) onImport;
//
//   const ImportStudentDialog({
//     super.key,
//     required this.existingStudents,
//     required this.onImport,
//   });
//
//   @override
//   State<ImportStudentDialog> createState() => _ImportStudentDialogState();
// }
//
// class _ImportStudentDialogState extends State<ImportStudentDialog> {
//   PlatformFile? _selectedFile;
//   bool _isMockMode = false;
//   bool _isImporting = false;
//
//   int _successCount = 0;
//   List<String> _errors = [];
//   List<String> _duplicates = [];
//   bool _hasResult = false;
//   List<Map<String, dynamic>> _validStudents = [];
//
//   // --- 1. CHỌN FILE TỪ THIẾT BỊ ---
//   Future<void> _pickFile() async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['xls', 'xlsx'],
//         withData: true, // Rất quan trọng để đọc file trên Web và một số máy ảo
//       );
//
//       if (result != null && result.files.isNotEmpty) {
//         setState(() {
//           _selectedFile = result.files.first;
//           _isMockMode = false;
//           _hasResult = false; // Xóa kết quả cũ nếu chọn lại file
//         });
//       }
//     } catch (e) {
//       debugPrint("Lỗi chọn file: $e");
//     }
//   }
//
//   // --- 2. TẠO FILE EXCEL MẪU (Dành cho máy ảo) ---
// // --- 2. TẠO FILE EXCEL MẪU (LƯU RA THƯ MỤC DOWNLOADS ĐỂ DỄ TÌM) ---
//   Future<void> _generateSampleExcelForEmulator() async {
//     try {
//       var excel = Excel.createExcel();
//       Sheet sheet = excel['Sheet1'];
//
//       // Tạo Header
//       sheet.appendRow([TextCellValue('Mã SV'), TextCellValue('Họ tên'), TextCellValue('Lớp')]);
//
//       // Tạo Data mẫu
//       sheet.appendRow([TextCellValue('SV005'), TextCellValue('Nguyễn Hoàng Đạo'), TextCellValue('CNTT-K64')]);
//       sheet.appendRow([TextCellValue('SV006'), TextCellValue('Trần Thị Tươi Thắm'), TextCellValue('CNTT-K64')]);
//       sheet.appendRow([TextCellValue('SV007'), TextCellValue('Lê Văn Ngọc An'), TextCellValue('CNTT-K64')]);
//
//       var fileBytes = excel.save();
//
//       // ✨ CẬP NHẬT: Tìm đường dẫn thư mục Downloads công cộng
//       Directory? directory;
//       if (Platform.isAndroid) {
//         // Đường dẫn chuẩn của thư mục Download trên máy ảo Android
//         directory = Directory('/storage/emulated/0/Download');
//
//         // Đề phòng máy ảo cấu hình khác, fallback về thư mục ngoài của app
//         if (!await directory.exists()) {
//           directory = await getExternalStorageDirectory();
//         }
//       } else {
//         // Dành cho iOS, Web, Desktop...
//         directory = await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
//       }
//
//       // Lưu file
//       final file = File('${directory!.path}/DanhSachSV_Mau.xlsx');
//       await file.writeAsBytes(fileBytes!);
//
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Đã lưu file mẫu tại thư mục Download!\n(${file.path})'),
//             backgroundColor: Colors.green.shade700,
//             duration: const Duration(seconds: 4),
//           ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Lỗi tạo file mẫu: $e'), backgroundColor: Colors.red),
//         );
//       }
//     }
//   }
//   // --- 3. ĐỌC VÀ KIỂM TRA FILE TRƯỚC KHI LƯU ---
//   Future<void> _processImport() async {
//     setState(() => _isImporting = true);
//
//     // Giả lập loading một chút cho mượt mà UI
//     await Future.delayed(const Duration(milliseconds: 500));
//
//     _validStudents = [];
//     _errors = [];
//     _duplicates = [];
//
//     List<int>? bytesToProcess;
//
//     if (_isMockMode) {
//       // Dùng luôn data ảo mà không cần parse file
//       _validStudents = [
//         {'studentCode': 'SV_MOCK_1', 'name': 'Data Ảo 1', 'className': 'TEST-01'},
//         {'studentCode': 'SV_MOCK_2', 'name': 'Data Ảo 2', 'className': 'TEST-01'},
//       ];
//     } else if (_selectedFile != null) {
//       if (_selectedFile!.bytes != null) {
//         bytesToProcess = _selectedFile!.bytes;
//       } else if (_selectedFile!.path != null) {
//         final file = File(_selectedFile!.path!);
//         bytesToProcess = await file.readAsBytes();
//       }
//     }
//
//     if (!_isMockMode && bytesToProcess != null) {
//       try {
//         var excel = Excel.decodeBytes(bytesToProcess);
//         var sheet = excel.tables[excel.tables.keys.first];
//
//         final existingCodes = widget.existingStudents.map((s) => s.studentCode.toLowerCase()).toSet();
//         final importedCodes = <String>{};
//
//         if (sheet != null) {
//           // Bỏ qua dòng 1 (Header), bắt đầu từ dòng 2 (index 1)
//           for (var i = 1; i < sheet.maxRows; i++) {
//             var row = sheet.row(i);
//             if (row.isEmpty || row[0] == null) continue;
//
//             String studentCode = row[0]?.value?.toString().trim() ?? '';
//             String name = row.length > 1 ? (row[1]?.value?.toString().trim() ?? '') : '';
//             String className = row.length > 2 ? (row[2]?.value?.toString().trim() ?? '') : '';
//
//             if (studentCode.isEmpty || name.isEmpty || className.isEmpty) {
//               _errors.add('Dòng ${i + 1}: Thiếu thông tin bắt buộc');
//               continue;
//             }
//
//             String codeLC = studentCode.toLowerCase();
//             if (existingCodes.contains(codeLC)) {
//               _duplicates.add('$studentCode (đã tồn tại trong chiến dịch)');
//               continue;
//             }
//             if (importedCodes.contains(codeLC)) {
//               _duplicates.add('$studentCode (bị trùng lặp ngay trong file)');
//               continue;
//             }
//
//             importedCodes.add(codeLC);
//             _validStudents.add({
//               'studentCode': studentCode,
//               'name': name,
//               'className': className,
//             });
//           }
//         }
//       } catch (e) {
//         _errors.add('Lỗi khi đọc file. Vui lòng kiểm tra lại định dạng Excel.');
//       }
//     } else if (!_isMockMode) {
//       _errors.add('Không thể đọc dữ liệu từ file này.');
//     }
//
//     setState(() {
//       _successCount = _validStudents.length;
//       _hasResult = true;
//       _isImporting = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Nút Action chỉ sáng khi đã chọn file HOẶC đang bật mode data ảo
//     final canProcess = (_selectedFile != null || _isMockMode) && !_hasResult;
//
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       backgroundColor: Colors.white,
//       child: Container(
//         width: 500,
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Import danh sách sinh viên', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//
//             // --- KHUNG HƯỚNG DẪN ---
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.blue.shade200)),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Icon(Icons.file_present_rounded, color: Colors.blue.shade600),
//                   const SizedBox(width: 12),
//                   const Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Hướng dẫn:', style: TextStyle(fontWeight: FontWeight.bold)),
//                         SizedBox(height: 4),
//                         Text('1. File phải có 3 cột: Mã SV, Họ tên, Lớp\n2. Chỉ hỗ trợ định dạng .xlsx hoặc .xls', style: TextStyle(fontSize: 13, height: 1.5)),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//
//             // --- KHU VỰC CHỌN FILE ---
//             InkWell(
//               onTap: _hasResult ? null : _pickFile,
//               borderRadius: BorderRadius.circular(12),
//               child: Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.symmetric(vertical: 32),
//                 decoration: BoxDecoration(
//                   color: _isMockMode ? Colors.grey.shade100 : Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color: _selectedFile != null ? Colors.blue.shade400 : Colors.grey.shade300,
//                     width: _selectedFile != null ? 2 : 1,
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     Icon(
//                       _selectedFile != null ? Icons.check_circle : Icons.upload_file_rounded,
//                       size: 48,
//                       color: _selectedFile != null ? Colors.blue.shade600 : Colors.grey.shade400,
//                     ),
//                     const SizedBox(height: 12),
//                     Text(
//                       _selectedFile != null ? _selectedFile!.name : 'Nhấn để chọn file Excel',
//                       style: TextStyle(fontWeight: FontWeight.bold, color: _selectedFile != null ? Colors.blue.shade700 : Colors.black87),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             // --- CÔNG CỤ DÀNH CHO MÁY ẢO ---
//             if (!_hasResult) ...[
//               const SizedBox(height: 16),
//               Row(
//                 children: [
//                   Expanded(child: Divider(color: Colors.grey.shade300)),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                     child: Text('Công cụ hỗ trợ máy ảo', style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
//                   ),
//                   Expanded(child: Divider(color: Colors.grey.shade300)),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton.icon(
//                       onPressed: _generateSampleExcelForEmulator,
//                       icon: const Icon(Icons.download_rounded, size: 16),
//                       label: const Text('Tạo file mẫu', style: TextStyle(fontSize: 12)),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: OutlinedButton.icon(
//                       onPressed: () {
//                         setState(() {
//                           _isMockMode = true;
//                           _selectedFile = null;
//                         });
//                       },
//                       icon: Icon(Icons.smart_toy_rounded, size: 16, color: _isMockMode ? Colors.blue : null),
//                       label: Text('Dùng Data ảo', style: TextStyle(fontSize: 12, color: _isMockMode ? Colors.blue : null)),
//                       style: OutlinedButton.styleFrom(
//                         backgroundColor: _isMockMode ? Colors.blue.shade50 : null,
//                         side: BorderSide(color: _isMockMode ? Colors.blue : Colors.grey.shade300),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//
//             // --- HIỂN THỊ KẾT QUẢ ĐỌC FILE ---
//             if (_hasResult) ...[
//               const SizedBox(height: 16),
//               if (_successCount > 0)
//                 _buildAlertBox(Icons.check_circle, Colors.green, 'Hợp lệ: Sẵn sàng import $_successCount sinh viên.'),
//               if (_errors.isNotEmpty)
//                 _buildAlertBox(Icons.error, Colors.red, 'Lỗi (${_errors.length}):\n${_errors.take(3).join('\n')}${_errors.length > 3 ? '\n...' : ''}'),
//               if (_duplicates.isNotEmpty)
//                 _buildAlertBox(Icons.warning, Colors.orange, 'Bỏ qua trùng lặp (${_duplicates.length}):\n${_duplicates.take(3).join('\n')}${_duplicates.length > 3 ? '\n...' : ''}'),
//             ],
//
//             const SizedBox(height: 24),
//
//             // --- NÚT ĐÓNG / IMPORT ---
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 OutlinedButton(
//                   onPressed: () => Navigator.pop(context),
//                   style: OutlinedButton.styleFrom(
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                     side: BorderSide(color: Colors.grey.shade300),
//                   ),
//                   child: Text(_hasResult ? 'Đóng' : 'Hủy', style: TextStyle(color: Colors.grey.shade800)),
//                 ),
//                 const SizedBox(width: 12),
//
//                 // Nút thay đổi logic: KIỂM TRA FILE -> LƯU DỮ LIỆU
//                 ElevatedButton(
//                   onPressed: _hasResult
//                       ? (_successCount > 0 ? () => widget.onImport(_validStudents) : null)
//                       : (canProcess && !_isImporting ? _processImport : null),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue.shade600,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                   ),
//                   child: _isImporting
//                       ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
//                       : Text(_hasResult ? 'Lưu Dữ Liệu ($_successCount)' : 'Kiểm Tra File', style: const TextStyle(fontWeight: FontWeight.bold)),
//                 )
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Khung Alert hiển thị lỗi/thành công
//   Widget _buildAlertBox(IconData icon, MaterialColor color, String text) {
//     return Container(
//       margin: const EdgeInsets.only(top: 8),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(color: color.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: color.shade200)),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, color: color.shade600, size: 20),
//           const SizedBox(width: 8),
//           Expanded(child: Text(text, style: TextStyle(color: color.shade800, fontSize: 13))),
//         ],
//       ),
//     );
//   }
// }

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:excel/excel.dart' hide Border, BorderStyle, TextSpan;
// import '../../../domain/entities/student.dart';
// import '../../../domain/entities/campaign.dart';
//
// class ImportStudentDialog extends StatefulWidget {
//   final List<Student> existingStudents;
//   final List<Campaign> campaigns;
//   final String? initialCampaignId;
//   final Function(String targetCampaignId, List<Map<String, dynamic>> importedData) onImport;
//
//   const ImportStudentDialog({
//     super.key,
//     required this.existingStudents,
//     required this.campaigns,
//     this.initialCampaignId,
//     required this.onImport,
//   });
//
//   @override
//   State<ImportStudentDialog> createState() => _ImportStudentDialogState();
// }
//
// class _ImportStudentDialogState extends State<ImportStudentDialog> {
//   PlatformFile? _selectedFile;
//   bool _isMockMode = false;
//   bool _isImporting = false;
//
//   int _successCount = 0;
//   List<String> _errors = [];
//   List<String> _duplicates = [];
//   bool _hasResult = false;
//   List<Map<String, dynamic>> _validStudents = [];
//
//   List<Campaign> _validCampaigns = [];
//   String? _selectedCampaignId;
//
//   @override
//   void initState() {
//     super.initState();
//     _validCampaigns = widget.campaigns.where((c) => ['active', 'ongoing', 'upcoming'].contains(c.status.toLowerCase())).toList();
//
//     if (_validCampaigns.isNotEmpty) {
//       if (widget.initialCampaignId != null && _validCampaigns.any((c) => c.id == widget.initialCampaignId)) {
//         _selectedCampaignId = widget.initialCampaignId;
//       } else {
//         _selectedCampaignId = _validCampaigns.first.id;
//       }
//     }
//   }
//
//   Future<void> _pickFile() async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom, allowedExtensions: ['xls', 'xlsx'], withData: true,
//       );
//       if (result != null && result.files.isNotEmpty) {
//         setState(() { _selectedFile = result.files.first; _isMockMode = false; _hasResult = false; });
//       }
//     } catch (e) {
//       debugPrint("Lỗi chọn file: $e");
//     }
//   }
//
//   Future<void> _generateSampleExcelForEmulator() async {
//     try {
//       var excel = Excel.createExcel();
//       Sheet sheet = excel['Sheet1'];
//       // ✨ CẬP NHẬT FILE MẪU CÓ 4 CỘT
//       sheet.appendRow([TextCellValue('Mã SV'), TextCellValue('Họ tên'), TextCellValue('Lớp'), TextCellValue('Email')]);
//       sheet.appendRow([TextCellValue('SV005'), TextCellValue('Nguyễn Hoàng Đạo'), TextCellValue('CNTT-K64'), TextCellValue('tiepnnkhe186589@fpt.edu.vn')]);
//       sheet.appendRow([TextCellValue('SV006'), TextCellValue('Trần Thị Tươi Thắm'), TextCellValue('CNTT-K64'), TextCellValue('huyldhe186829@fpt.edu.vn')]);
//
//       var fileBytes = excel.save();
//       Directory? directory;
//       if (Platform.isAndroid) {
//         directory = Directory('/storage/emulated/0/Download');
//         if (!await directory.exists()) directory = await getExternalStorageDirectory();
//       } else {
//         directory = await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
//       }
//
//       final file = File('${directory!.path}/DanhSachSV_Mau.xlsx');
//       await file.writeAsBytes(fileBytes!);
//
//       if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đã lưu file mẫu tại Download!'), backgroundColor: Colors.green.shade700));
//     } catch (e) {
//       if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi tạo file mẫu: $e'), backgroundColor: Colors.red));
//     }
//   }
//
//   Future<void> _processImport() async {
//     setState(() => _isImporting = true);
//     await Future.delayed(const Duration(milliseconds: 500));
//
//     _validStudents = []; _errors = []; _duplicates = [];
//     List<int>? bytesToProcess;
//
//     if (_isMockMode) {
//       // ✨ CẬP NHẬT DỮ LIỆU MOCK CÓ THÊM EMAIL
//       _validStudents = [
//         {'studentCode': 'SV_MOCK_1', 'name': 'Data Ảo 1', 'className': 'TEST-01', 'email': 'mock1@truong.edu.vn'},
//         {'studentCode': 'SV_MOCK_2', 'name': 'Data Ảo 2', 'className': 'TEST-01', 'email': 'mock2@truong.edu.vn'},
//       ];
//     } else if (_selectedFile != null) {
//       if (_selectedFile!.bytes != null) bytesToProcess = _selectedFile!.bytes;
//       else if (_selectedFile!.path != null) bytesToProcess = await File(_selectedFile!.path!).readAsBytes();
//     }
//
//     if (!_isMockMode && bytesToProcess != null) {
//       try {
//         var excel = Excel.decodeBytes(bytesToProcess);
//         var sheet = excel.tables[excel.tables.keys.first];
//         final existingCodes = widget.existingStudents.map((s) => s.studentCode.toLowerCase()).toSet();
//         final importedCodes = <String>{};
//
//         if (sheet != null) {
//           for (var i = 1; i < sheet.maxRows; i++) {
//             var row = sheet.row(i);
//             if (row.isEmpty || row[0] == null) continue;
//
//             String studentCode = row[0]?.value?.toString().trim() ?? '';
//             String name = row.length > 1 ? (row[1]?.value?.toString().trim() ?? '') : '';
//             String className = row.length > 2 ? (row[2]?.value?.toString().trim() ?? '') : '';
//             // ✨ ĐỌC EMAIL TỪ CỘT THỨ 4 (Index 3)
//             String email = row.length > 3 ? (row[3]?.value?.toString().trim() ?? '') : '';
//
//             if (studentCode.isEmpty || name.isEmpty || className.isEmpty || email.isEmpty) {
//               _errors.add('Dòng ${i + 1}: Thiếu thông tin bắt buộc');
//               continue;
//             }
//
//             String codeLC = studentCode.toLowerCase();
//             if (existingCodes.contains(codeLC)) { _duplicates.add('$studentCode (đã tồn tại)'); continue; }
//             if (importedCodes.contains(codeLC)) { _duplicates.add('$studentCode (trùng lặp trong file)'); continue; }
//
//             importedCodes.add(codeLC);
//             // ✨ TRẢ VỀ THÊM EMAIL
//             _validStudents.add({'studentCode': studentCode, 'name': name, 'className': className, 'email': email});
//           }
//         }
//       } catch (e) { _errors.add('Lỗi định dạng Excel.'); }
//     } else if (!_isMockMode) { _errors.add('Không đọc được file.'); }
//
//     setState(() { _successCount = _validStudents.length; _hasResult = true; _isImporting = false; });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final canProcess = _selectedCampaignId != null && (_selectedFile != null || _isMockMode) && !_hasResult;
//
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       backgroundColor: Colors.white,
//       child: Container(
//         width: double.maxFinite,
//         constraints: const BoxConstraints(maxWidth: 500, maxHeight: 800),
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const FittedBox(fit: BoxFit.scaleDown, child: Text('Import danh sách sinh viên', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
//               const SizedBox(height: 16),
//
//               if (_validCampaigns.isEmpty)
//                 Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
//                     child: Row(children: [
//                       Icon(Icons.error_outline, color: Colors.red.shade600),
//                       const SizedBox(width: 8),
//                       const Expanded(child: Text("Không có chiến dịch nào Đang diễn ra hoặc Sắp tới để Import.", style: TextStyle(color: Colors.red))),
//                     ])
//                 )
//               else ...[
//                 const Text('Chọn chiến dịch để Import *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 8),
//                 DropdownButtonFormField<String>(
//                   isExpanded: true,
//                   value: _selectedCampaignId,
//                   decoration: InputDecoration(
//                     filled: true, fillColor: Colors.white,
//                     contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
//                   ),
//                   items: _validCampaigns.map((c) {
//                     Color statusBgColor; Color statusFgColor; String statusText;
//                     if (c.status == 'active' || c.status == 'ongoing') {
//                       statusBgColor = const Color(0xFFE8F8F5); statusFgColor = Colors.green.shade700; statusText = 'Đang diễn ra';
//                     } else if (c.status == 'upcoming') {
//                       statusBgColor = const Color(0xFFE3F2FD); statusFgColor = Colors.blue.shade700; statusText = 'Sắp tới';
//                     } else {
//                       statusBgColor = Colors.grey.shade100; statusFgColor = Colors.grey.shade700; statusText = 'Đã kết thúc';
//                     }
//                     return DropdownMenuItem(
//                       value: c.id,
//                       child: Row(
//                         children: [
//                           Expanded(child: Text(c.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14))),
//                           const SizedBox(width: 8),
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                             decoration: BoxDecoration(color: statusBgColor, borderRadius: BorderRadius.circular(8)),
//                             child: Text(statusText, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusFgColor)),
//                           )
//                         ],
//                       ),
//                     );
//                   }).toList(),
//                   onChanged: _hasResult ? null : (val) => setState(() => _selectedCampaignId = val),
//                 ),
//                 const SizedBox(height: 16),
//
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.blue.shade200)),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Icon(Icons.file_present_rounded, color: Colors.blue.shade600),
//                       const SizedBox(width: 12),
//                       // ✨ HƯỚNG DẪN 4 CỘT
//                       const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Hướng dẫn:', style: TextStyle(fontWeight: FontWeight.bold)), SizedBox(height: 4), Text('1. File có 4 cột: Mã SV, Họ tên, Lớp, Email\n2. Hỗ trợ .xlsx hoặc .xls', style: TextStyle(fontSize: 13, height: 1.5))]))
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//
//                 InkWell(
//                   onTap: _hasResult ? null : _pickFile,
//                   borderRadius: BorderRadius.circular(12),
//                   child: Container(
//                     width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
//                     decoration: BoxDecoration(color: _isMockMode ? Colors.grey.shade100 : Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _selectedFile != null ? Colors.blue.shade400 : Colors.grey.shade300, width: _selectedFile != null ? 2 : 1)),
//                     child: Column(
//                       children: [
//                         Icon(_selectedFile != null ? Icons.check_circle : Icons.upload_file_rounded, size: 48, color: _selectedFile != null ? Colors.blue.shade600 : Colors.grey.shade400),
//                         const SizedBox(height: 12),
//                         Text(_selectedFile != null ? _selectedFile!.name : 'Nhấn để chọn file Excel', style: TextStyle(fontWeight: FontWeight.bold, color: _selectedFile != null ? Colors.blue.shade700 : Colors.black87), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 if (!_hasResult) ...[
//                   const SizedBox(height: 16),
//                   Row(children: [Expanded(child: Divider(color: Colors.grey.shade300)), Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0), child: Flexible(child: Text('Công cụ máy ảo', style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis))), Expanded(child: Divider(color: Colors.grey.shade300))]),
//                   const SizedBox(height: 12),
//                   Row(
//                     children: [
//                       Expanded(child: OutlinedButton.icon(onPressed: _generateSampleExcelForEmulator, icon: const Icon(Icons.download_rounded, size: 16), label: const FittedBox(fit: BoxFit.scaleDown, child: Text('Tạo file mẫu', style: TextStyle(fontSize: 12))))),
//                       const SizedBox(width: 8),
//                       Expanded(child: OutlinedButton.icon(onPressed: () { setState(() { _isMockMode = true; _selectedFile = null; }); }, icon: Icon(Icons.smart_toy_rounded, size: 16, color: _isMockMode ? Colors.blue : null), label: FittedBox(fit: BoxFit.scaleDown, child: Text('Dùng Data ảo', style: TextStyle(fontSize: 12, color: _isMockMode ? Colors.blue : null))), style: OutlinedButton.styleFrom(backgroundColor: _isMockMode ? Colors.blue.shade50 : null, side: BorderSide(color: _isMockMode ? Colors.blue : Colors.grey.shade300)))),
//                     ],
//                   ),
//                 ],
//
//                 if (_hasResult) ...[
//                   const SizedBox(height: 16),
//                   if (_successCount > 0) _buildAlertBox(Icons.check_circle, Colors.green, 'Hợp lệ: Sẵn sàng import $_successCount sinh viên.'),
//                   if (_errors.isNotEmpty) _buildAlertBox(Icons.error, Colors.red, 'Lỗi (${_errors.length}):\n${_errors.take(3).join('\n')}${_errors.length > 3 ? '\n...' : ''}'),
//                   if (_duplicates.isNotEmpty) _buildAlertBox(Icons.warning, Colors.orange, 'Trùng lặp (${_duplicates.length}):\n${_duplicates.take(3).join('\n')}${_duplicates.length > 3 ? '\n...' : ''}'),
//                 ],
//               ],
//
//               const SizedBox(height: 24),
//               Row(
//                 children: [
//                   Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), side: BorderSide(color: Colors.grey.shade300)), child: FittedBox(fit: BoxFit.scaleDown, child: Text(_hasResult ? 'Đóng' : 'Hủy', style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold))))),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: _validCampaigns.isEmpty ? null : (_hasResult ? (_successCount > 0 ? () => widget.onImport(_selectedCampaignId!, _validStudents) : null) : (canProcess && !_isImporting ? _processImport : null)),
//                       style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12), backgroundColor: Colors.blue.shade600, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
//                       child: _isImporting ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : FittedBox(fit: BoxFit.scaleDown, child: Text(_hasResult ? 'Lưu Dữ Liệu ($_successCount)' : 'Kiểm Tra File', style: const TextStyle(fontWeight: FontWeight.bold))),
//                     ),
//                   )
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAlertBox(IconData icon, MaterialColor color, String text) {
//     return Container(margin: const EdgeInsets.only(top: 8), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: color.shade200)), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: color.shade600, size: 20), const SizedBox(width: 8), Expanded(child: Text(text, style: TextStyle(color: color.shade800, fontSize: 13)))]));
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart' hide Border, BorderStyle, TextSpan;
import '../../../domain/entities/student.dart';
import '../../../domain/entities/campaign.dart';

class ImportStudentDialog extends StatefulWidget {
  final List<Student> existingStudents;
  final List<Campaign> campaigns;
  final String? initialCampaignId;
  final Function(String targetCampaignId, List<Map<String, dynamic>> importedData) onImport;

  const ImportStudentDialog({
    super.key,
    required this.existingStudents,
    required this.campaigns,
    this.initialCampaignId,
    required this.onImport,
  });

  @override
  State<ImportStudentDialog> createState() => _ImportStudentDialogState();
}

class _ImportStudentDialogState extends State<ImportStudentDialog> {
  PlatformFile? _selectedFile;
  bool _isMockMode = false;
  bool _isImporting = false;

  int _successCount = 0;
  List<String> _errors = [];
  List<String> _duplicates = [];
  bool _hasResult = false;
  List<Map<String, dynamic>> _validStudents = [];

  List<Campaign> _validCampaigns = [];
  String? _selectedCampaignId;

  @override
  void initState() {
    super.initState();
    _validCampaigns = widget.campaigns.where((c) => ['active', 'ongoing', 'upcoming'].contains(c.status.toLowerCase())).toList();

    if (_validCampaigns.isNotEmpty) {
      if (widget.initialCampaignId != null && _validCampaigns.any((c) => c.id == widget.initialCampaignId)) {
        _selectedCampaignId = widget.initialCampaignId;
      } else {
        _selectedCampaignId = _validCampaigns.first.id;
      }
    }
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['xls', 'xlsx'], withData: true,
      );
      if (result != null && result.files.isNotEmpty) {
        setState(() { _selectedFile = result.files.first; _isMockMode = false; _hasResult = false; });
      }
    } catch (e) {
      debugPrint("Lỗi chọn file: $e");
    }
  }

  Future<void> _generateSampleExcelForEmulator() async {
    try {
      var excel = Excel.createExcel();
      Sheet sheet = excel['Sheet1'];
      sheet.appendRow([TextCellValue('Mã SV'), TextCellValue('Họ tên'), TextCellValue('Lớp'), TextCellValue('Email')]);
      sheet.appendRow([TextCellValue('HE184321'), TextCellValue('Nguyễn Hoàng Đạo'), TextCellValue('SE1873-JS'), TextCellValue('tiepnnkhe186589@fpt.edu.vn')]);
      sheet.appendRow([TextCellValue('HE182468'), TextCellValue('Trần Thị Tươi Thắm'), TextCellValue('SE1873-JS'), TextCellValue('huyldhe186829@fpt.edu.vn')]);

      var fileBytes = excel.save();
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) directory = await getExternalStorageDirectory();
      } else {
        directory = await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
      }

      final file = File('${directory!.path}/DanhSachSV_Mau.xlsx');
      await file.writeAsBytes(fileBytes!);

      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đã lưu file mẫu tại Download!'), backgroundColor: Colors.green.shade700));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi tạo file mẫu: $e'), backgroundColor: Colors.red));
    }
  }

  Future<void> _processImport() async {
    setState(() => _isImporting = true);
    await Future.delayed(const Duration(milliseconds: 500));

    _validStudents = []; _errors = []; _duplicates = [];
    List<int>? bytesToProcess;

    if (_isMockMode) {
      _validStudents = [
        {'studentCode': 'SV_MOCK_1', 'name': 'Data Ảo 1', 'className': 'TEST-01', 'email': 'mock1@truong.edu.vn'},
        {'studentCode': 'SV_MOCK_2', 'name': 'Data Ảo 2', 'className': 'TEST-01', 'email': 'mock2@truong.edu.vn'},
      ];
    } else if (_selectedFile != null) {
      if (_selectedFile!.bytes != null) bytesToProcess = _selectedFile!.bytes;
      else if (_selectedFile!.path != null) bytesToProcess = await File(_selectedFile!.path!).readAsBytes();
    }

    if (!_isMockMode && bytesToProcess != null) {
      try {
        var excel = Excel.decodeBytes(bytesToProcess);
        var sheet = excel.tables[excel.tables.keys.first];

        // ✨ ĐÃ SỬA: CHỈ LẤY DANH SÁCH MÃ SV CỦA NHỮNG SINH VIÊN TRONG CHIẾN DỊCH ĐANG CHỌN
        final existingCodesInCampaign = widget.existingStudents
            .where((s) => s.campaignId == _selectedCampaignId)
            .map((s) => s.studentCode.toLowerCase())
            .toSet();

        final importedCodes = <String>{};

        if (sheet != null) {
          for (var i = 1; i < sheet.maxRows; i++) {
            var row = sheet.row(i);
            if (row.isEmpty || row[0] == null) continue;

            String studentCode = row[0]?.value?.toString().trim() ?? '';
            String name = row.length > 1 ? (row[1]?.value?.toString().trim() ?? '') : '';
            String className = row.length > 2 ? (row[2]?.value?.toString().trim() ?? '') : '';
            String email = row.length > 3 ? (row[3]?.value?.toString().trim() ?? '') : '';

            if (studentCode.isEmpty || name.isEmpty || className.isEmpty || email.isEmpty) {
              _errors.add('Dòng ${i + 1}: Thiếu thông tin bắt buộc');
              continue;
            }

            String codeLC = studentCode.toLowerCase();

            // ✨ ĐÃ SỬA: SO SÁNH VỚI TẬP HỢP MÃ CỦA CHIẾN DỊCH ĐANG CHỌN
            if (existingCodesInCampaign.contains(codeLC)) {
              _duplicates.add('$studentCode (đã tồn tại trong chiến dịch này)');
              continue;
            }
            if (importedCodes.contains(codeLC)) {
              _duplicates.add('$studentCode (trùng lặp trong file excel)');
              continue;
            }

            importedCodes.add(codeLC);
            _validStudents.add({'studentCode': studentCode, 'name': name, 'className': className, 'email': email});
          }
        }
      } catch (e) { _errors.add('Lỗi định dạng Excel.'); }
    } else if (!_isMockMode) { _errors.add('Không đọc được file.'); }

    setState(() { _successCount = _validStudents.length; _hasResult = true; _isImporting = false; });
  }

  @override
  Widget build(BuildContext context) {
    final canProcess = _selectedCampaignId != null && (_selectedFile != null || _isMockMode) && !_hasResult;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: Container(
        width: double.maxFinite,
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 800),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FittedBox(fit: BoxFit.scaleDown, child: Text('Import danh sách sinh viên', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
              const SizedBox(height: 16),

              if (_validCampaigns.isEmpty)
                Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
                    child: Row(children: [
                      Icon(Icons.error_outline, color: Colors.red.shade600),
                      const SizedBox(width: 8),
                      const Expanded(child: Text("Không có chiến dịch nào Đang diễn ra hoặc Sắp tới để Import.", style: TextStyle(color: Colors.red))),
                    ])
                )
              else ...[
                const Text('Chọn chiến dịch để Import *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: _selectedCampaignId,
                  decoration: InputDecoration(
                    filled: true, fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                  ),
                  items: _validCampaigns.map((c) {
                    Color statusBgColor; Color statusFgColor; String statusText;
                    if (c.status == 'active' || c.status == 'ongoing') {
                      statusBgColor = const Color(0xFFE8F8F5); statusFgColor = Colors.green.shade700; statusText = 'Đang diễn ra';
                    } else if (c.status == 'upcoming') {
                      statusBgColor = const Color(0xFFE3F2FD); statusFgColor = Colors.blue.shade700; statusText = 'Sắp tới';
                    } else {
                      statusBgColor = Colors.grey.shade100; statusFgColor = Colors.grey.shade700; statusText = 'Đã kết thúc';
                    }
                    return DropdownMenuItem(
                      value: c.id,
                      child: Row(
                        children: [
                          Expanded(child: Text(c.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14))),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: statusBgColor, borderRadius: BorderRadius.circular(8)),
                            child: Text(statusText, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusFgColor)),
                          )
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: _hasResult ? null : (val) => setState(() => _selectedCampaignId = val),
                ),
                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.blue.shade200)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.file_present_rounded, color: Colors.blue.shade600),
                      const SizedBox(width: 12),
                      const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Hướng dẫn:', style: TextStyle(fontWeight: FontWeight.bold)), SizedBox(height: 4), Text('1. File có 4 cột: Mã SV, Họ tên, Lớp, Email\n2. Hỗ trợ .xlsx hoặc .xls', style: TextStyle(fontSize: 13, height: 1.5))]))
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                InkWell(
                  onTap: _hasResult ? null : _pickFile,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                    decoration: BoxDecoration(color: _isMockMode ? Colors.grey.shade100 : Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _selectedFile != null ? Colors.blue.shade400 : Colors.grey.shade300, width: _selectedFile != null ? 2 : 1)),
                    child: Column(
                      children: [
                        Icon(_selectedFile != null ? Icons.check_circle : Icons.upload_file_rounded, size: 48, color: _selectedFile != null ? Colors.blue.shade600 : Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text(_selectedFile != null ? _selectedFile!.name : 'Nhấn để chọn file Excel', style: TextStyle(fontWeight: FontWeight.bold, color: _selectedFile != null ? Colors.blue.shade700 : Colors.black87), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ),

                if (!_hasResult) ...[
                  const SizedBox(height: 16),
                  Row(children: [Expanded(child: Divider(color: Colors.grey.shade300)), Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0), child: Flexible(child: Text('Công cụ máy ảo', style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis))), Expanded(child: Divider(color: Colors.grey.shade300))]),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: OutlinedButton.icon(onPressed: _generateSampleExcelForEmulator, icon: const Icon(Icons.download_rounded, size: 16), label: const FittedBox(fit: BoxFit.scaleDown, child: Text('Tạo file mẫu', style: TextStyle(fontSize: 12))))),
                      const SizedBox(width: 8),
                      Expanded(child: OutlinedButton.icon(onPressed: () { setState(() { _isMockMode = true; _selectedFile = null; }); }, icon: Icon(Icons.smart_toy_rounded, size: 16, color: _isMockMode ? Colors.blue : null), label: FittedBox(fit: BoxFit.scaleDown, child: Text('Dùng Data ảo', style: TextStyle(fontSize: 12, color: _isMockMode ? Colors.blue : null))), style: OutlinedButton.styleFrom(backgroundColor: _isMockMode ? Colors.blue.shade50 : null, side: BorderSide(color: _isMockMode ? Colors.blue : Colors.grey.shade300)))),
                    ],
                  ),
                ],

                if (_hasResult) ...[
                  const SizedBox(height: 16),
                  if (_successCount > 0) _buildAlertBox(Icons.check_circle, Colors.green, 'Hợp lệ: Sẵn sàng import $_successCount sinh viên.'),
                  if (_errors.isNotEmpty) _buildAlertBox(Icons.error, Colors.red, 'Lỗi (${_errors.length}):\n${_errors.take(3).join('\n')}${_errors.length > 3 ? '\n...' : ''}'),
                  if (_duplicates.isNotEmpty) _buildAlertBox(Icons.warning, Colors.orange, 'Trùng lặp (${_duplicates.length}):\n${_duplicates.take(3).join('\n')}${_duplicates.length > 3 ? '\n...' : ''}'),
                ],
              ],

              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), side: BorderSide(color: Colors.grey.shade300)), child: FittedBox(fit: BoxFit.scaleDown, child: Text(_hasResult ? 'Đóng' : 'Hủy', style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold))))),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _validCampaigns.isEmpty ? null : (_hasResult ? (_successCount > 0 ? () => widget.onImport(_selectedCampaignId!, _validStudents) : null) : (canProcess && !_isImporting ? _processImport : null)),
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12), backgroundColor: Colors.blue.shade600, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      child: _isImporting ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : FittedBox(fit: BoxFit.scaleDown, child: Text(_hasResult ? 'Lưu Dữ Liệu ($_successCount)' : 'Kiểm Tra File', style: const TextStyle(fontWeight: FontWeight.bold))),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlertBox(IconData icon, MaterialColor color, String text) {
    return Container(margin: const EdgeInsets.only(top: 8), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: color.shade200)), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: color.shade600, size: 20), const SizedBox(width: 8), Expanded(child: Text(text, style: TextStyle(color: color.shade800, fontSize: 13)))]));
  }
}