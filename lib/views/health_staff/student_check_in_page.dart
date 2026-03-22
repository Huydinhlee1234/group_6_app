// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../di.dart';
// import '../../viewmodels/health_staff/station_form_viewmodel.dart';
// import '../../viewmodels/health_staff/student_check_in_viewmodel.dart';
// import '../shared/qr_code_generator.dart'; // Import chính xác đường dẫn
// import 'widgets/station_form_widget.dart';
//
// class StudentCheckInPage extends StatefulWidget {
//   final String campaignId;
//   final String stationId;
//   const StudentCheckInPage({super.key, required this.campaignId, required this.stationId});
//
//   @override
//   State<StudentCheckInPage> createState() => _StudentCheckInPageState();
// }
//
// class _StudentCheckInPageState extends State<StudentCheckInPage> {
//   final TextEditingController _searchCtrl = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() => context.read<StudentCheckInViewModel>().loadData(widget.campaignId));
//   }
//
//   @override
//   void dispose() {
//     _searchCtrl.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final vm = context.watch<StudentCheckInViewModel>();
//
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         title: const Text('Check-in Sinh Viên', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black87,
//         elevation: 1,
//       ),
//       body: vm.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             // THANH TÌM KIẾM
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
//               ),
//               child: TextField(
//                 controller: _searchCtrl,
//                 onChanged: vm.searchStudent,
//                 decoration: InputDecoration(
//                   hintText: 'Nhập mã SV hoặc tên...',
//                   prefixIcon: Icon(Icons.search, color: Colors.blue.shade600),
//                   suffixIcon: _searchCtrl.text.isNotEmpty
//                       ? IconButton(
//                     icon: const Icon(Icons.clear, color: Colors.grey),
//                     onPressed: () {
//                       _searchCtrl.clear();
//                       vm.searchStudent('');
//                     },
//                   )
//                       : null,
//                   border: InputBorder.none,
//                   contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//
//             // DANH SÁCH SINH VIÊN
//             Expanded(
//               child: vm.searchQuery.isEmpty
//                   ? _buildEmptyState('Nhập tên hoặc mã sinh viên để tìm kiếm', Icons.person_search_rounded)
//                   : vm.searchResults.isEmpty
//                   ? _buildEmptyState('Không tìm thấy sinh viên nào', Icons.search_off_rounded)
//                   : ListView.builder(
//                 itemCount: vm.searchResults.length,
//                 itemBuilder: (context, index) {
//                   final student = vm.searchResults[index];
//                   final record = vm.getRecord(student.id);
//                   final isDone = record?.completedStations.contains(widget.stationId) ?? false;
//                   final completedCount = record?.completedStations.length ?? 0;
//
//                   return Container(
//                     margin: const EdgeInsets.only(bottom: 16),
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(color: isDone ? Colors.green.shade200 : Colors.grey.shade200, width: 2),
//                       boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
//                     ),
//                     child: Row(
//                       children: [
//                         // ✨ GỌI COMPONENT QR CODE VỚI THAM SỐ CHUẨN
//                         QRCodeGenerator(
//                           student: student,
//                           campaignId: widget.campaignId,
//                           size: 60,
//                           showDetails: false, // Ẩn thông tin text để layout gọn gàng
//                         ),
//
//                         const SizedBox(width: 16),
//
//                         // THÔNG TIN SINH VIÊN
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                               const SizedBox(height: 4),
//                               Text('${student.studentCode} • Lớp: ${student.className}', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
//                               const SizedBox(height: 8),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                                 decoration: BoxDecoration(
//                                   color: isDone ? Colors.green.shade50 : Colors.blue.shade50,
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: Text(
//                                   'Tiến độ: $completedCount/4 trạm',
//                                   style: TextStyle(
//                                       color: isDone ? Colors.green.shade700 : Colors.blue.shade700,
//                                       fontSize: 12, fontWeight: FontWeight.bold
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//
//                         // NÚT KHÁM
//                         Column(
//                           children: [
//                             if (isDone)
//                               Icon(Icons.check_circle, color: Colors.green.shade600, size: 28)
//                             else
//                               const SizedBox(height: 28),
//                             const SizedBox(height: 8),
//                             ElevatedButton(
//                               onPressed: () async {
//                                 await Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) => ChangeNotifierProvider(
//                                       create: (_) => sl<StationFormViewModel>(),
//                                       child: StationFormWidget(
//                                           student: student,
//                                           stationId: widget.stationId,
//                                           initialRecord: record
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                                 if (context.mounted) vm.loadData(widget.campaignId);
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: isDone ? Colors.white : Colors.blue.shade600,
//                                 foregroundColor: isDone ? Colors.blue.shade600 : Colors.white,
//                                 side: isDone ? BorderSide(color: Colors.blue.shade600) : null,
//                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                                 elevation: isDone ? 0 : 2,
//                               ),
//                               child: Text(isDone ? 'Khám lại' : 'Khám'),
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildEmptyState(String message, IconData icon) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, size: 80, color: Colors.grey.shade300),
//           const SizedBox(height: 16),
//           Text(message, style: TextStyle(color: Colors.grey.shade500, fontSize: 16, fontWeight: FontWeight.w500)),
//         ],
//       ),
//     );
//   }
// }

// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../di.dart';
// import '../../domain/entities/student.dart';
// import '../../domain/entities/health_record.dart';
// import '../../viewmodels/health_staff/station_form_viewmodel.dart';
// import '../../viewmodels/health_staff/student_check_in_viewmodel.dart';
// import '../shared/qr_code_generator.dart'; // ✨ IMPORT CHUẨN XÁC
// import 'widgets/station_form_widget.dart';
//
// // --- CONFIGURATION ---
// const int totalStations = 4;
// final List<Map<String, dynamic>> stationConfig = [
//   {'id': 'physical', 'name': 'Đo thể lực', 'icon': Icons.monitor_heart_rounded},
//   {'id': 'vision', 'name': 'Khám thị lực', 'icon': Icons.remove_red_eye_rounded},
//   {'id': 'blood_pressure', 'name': 'Đo huyết áp', 'icon': Icons.favorite_rounded},
//   {'id': 'general', 'name': 'Khám tổng quát', 'icon': Icons.medical_services_rounded},
// ];
//
// class StudentCheckInPage extends StatefulWidget {
//   final String campaignId;
//   final String stationId;
//   const StudentCheckInPage({super.key, required this.campaignId, required this.stationId});
//
//   @override
//   State<StudentCheckInPage> createState() => _StudentCheckInPageState();
// }
//
// class _StudentCheckInPageState extends State<StudentCheckInPage> {
//   final TextEditingController _searchCtrl = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() => context.read<StudentCheckInViewModel>().loadData(widget.campaignId));
//   }
//
//   @override
//   void dispose() {
//     _searchCtrl.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final vm = context.watch<StudentCheckInViewModel>();
//     final currentStation = stationConfig.firstWhere((s) => s['id'] == widget.stationId, orElse: () => stationConfig.first);
//
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         title: const Text('Check-in Sinh Viên', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black87,
//         elevation: 0,
//         scrolledUnderElevation: 0,
//       ),
//       body: vm.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : CustomScrollView(
//         slivers: [
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   // 1. Station Header Card
//                   _StationHeaderCard(
//                     stationName: currentStation['name'],
//                     icon: currentStation['icon'],
//                     checkedInCount: vm.allStudents.where((s) {
//                       final r = vm.getRecord(s.id);
//                       return r != null && r.completedStations.contains(widget.stationId);
//                     }).length,
//                     totalStudents: vm.allStudents.length,
//                   ),
//                   const SizedBox(height: 16),
//
//                   // 2. Animated QR Scanner
//                   _AnimatedQRScanner(onScan: () {
//                     vm.simulateQRScan(); // Chạy hàm random sinh viên
//                     _searchCtrl.text = vm.searchQuery;
//                   }),
//                   const SizedBox(height: 24),
//
//                   // 3. Divider "Hoặc"
//                   Row(
//                     children: [
//                       Expanded(child: Container(height: 1, decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.transparent, Colors.grey.shade300])))),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 12),
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                           decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
//                           child: Text('hoặc tìm theo tên / mã SV', style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
//                         ),
//                       ),
//                       Expanded(child: Container(height: 1, decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.grey.shade300, Colors.transparent])))),
//                     ],
//                   ),
//                   const SizedBox(height: 24),
//
//                   // 4. Search Box
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
//                     decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 4))]),
//                     child: Row(
//                       children: [
//                         const SizedBox(width: 12),
//                         Icon(Icons.search, color: Colors.grey.shade400),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: TextField(
//                             controller: _searchCtrl,
//                             onChanged: vm.searchStudent,
//                             decoration: InputDecoration(
//                               hintText: 'Mã SV hoặc tên sinh viên...',
//                               hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
//                               border: InputBorder.none,
//                               isDense: true,
//                             ),
//                           ),
//                         ),
//                         if (_searchCtrl.text.isNotEmpty)
//                           IconButton(
//                             icon: Icon(Icons.close, color: Colors.grey.shade400, size: 20),
//                             onPressed: () {
//                               _searchCtrl.clear();
//                               vm.searchStudent('');
//                             },
//                           ),
//                         ElevatedButton(
//                           onPressed: () {},
//                           style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade600, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), elevation: 0),
//                           child: const Text('Tìm', style: TextStyle(fontWeight: FontWeight.bold)),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//
//                   // Results Text
//                   if (vm.searchResults.isNotEmpty)
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: Row(
//                         children: [
//                           Container(width: 6, height: 6, decoration: BoxDecoration(color: Colors.blue.shade400, shape: BoxShape.circle)),
//                           const SizedBox(width: 8),
//                           Text('Tìm thấy ${vm.searchResults.length} sinh viên', style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
//                         ],
//                       ),
//                     )
//                 ],
//               ),
//             ),
//           ),
//
//           // 5. Student List
//           SliverPadding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             sliver: vm.searchQuery.isEmpty
//             // Trạng thái 1: Chưa tìm kiếm / Chưa quét QR
//                 ? SliverToBoxAdapter(
//               child: Center(
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 40),
//                   child: Column(
//                     children: [
//                       Container(width: 80, height: 80, decoration: BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle), child: Icon(Icons.qr_code_scanner_rounded, size: 40, color: Colors.blue.shade400)),
//                       const SizedBox(height: 20),
//                       Text('Hãy quét QR hoặc nhập tìm kiếm', style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.bold, fontSize: 16)),
//                       const SizedBox(height: 8),
//                       Text('Danh sách sinh viên sẽ hiện ra tại đây', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
//                     ],
//                   ),
//                 ),
//               ),
//             )
//                 : vm.searchResults.isEmpty
//             // Trạng thái 2: Đã tìm nhưng không ra ai
//                 ? SliverToBoxAdapter(
//               child: Center(
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 40),
//                   child: Column(
//                     children: [
//                       Container(width: 64, height: 64, decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle), child: Icon(Icons.search_off_rounded, size: 32, color: Colors.grey.shade400)),
//                       const SizedBox(height: 16),
//                       Text('Không tìm thấy sinh viên', style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
//                     ],
//                   ),
//                 ),
//               ),
//             )
//             // Trạng thái 3: Tìm thấy sinh viên
//                 : SliverList(
//               delegate: SliverChildBuilderDelegate(
//                     (context, index) {
//                   final student = vm.searchResults[index];
//                   final record = vm.getRecord(student.id);
//                   return _StudentCard(
//                     student: student,
//                     record: record,
//                     stationId: widget.stationId,
//                     campaignId: widget.campaignId,
//                     index: index,
//                   );
//                 },
//                 childCount: vm.searchResults.length,
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
//
// // =========================================================================
// // WIDGET CON: Header Trạm
// // =========================================================================
// class _StationHeaderCard extends StatelessWidget {
//   final String stationName;
//   final IconData icon;
//   final int checkedInCount;
//   final int totalStudents;
//
//   const _StationHeaderCard({required this.stationName, required this.icon, required this.checkedInCount, required this.totalStudents});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 4))]),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.blue.shade400, Colors.blue.shade600]), borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
//             child: Row(
//               children: [
//                 Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(16)), child: Icon(icon, color: Colors.white, size: 28)),
//                 const SizedBox(width: 16),
//                 Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Trạm y tế'.toUpperCase(), style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)), const SizedBox(height: 2), Text(stationName, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))])),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//             child: Row(
//               children: [
//                 Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle), child: Icon(Icons.check_circle, color: Colors.green.shade500, size: 14)),
//                 const SizedBox(width: 8),
//                 Text('$checkedInCount đã khám hôm nay', style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
//                 const Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: SizedBox(height: 12, child: VerticalDivider(width: 1, color: Colors.grey))),
//                 Icon(Icons.people, color: Colors.blue.shade500, size: 16),
//                 const SizedBox(width: 8),
//                 Text('$totalStudents sinh viên', style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
//
// // =========================================================================
// // WIDGET CON: Quét QR Mô phỏng với Animation
// // =========================================================================
// class _AnimatedQRScanner extends StatefulWidget {
//   final VoidCallback onScan;
//   const _AnimatedQRScanner({required this.onScan});
//
//   @override
//   State<_AnimatedQRScanner> createState() => _AnimatedQRScannerState();
// }
//
// class _AnimatedQRScannerState extends State<_AnimatedQRScanner> with SingleTickerProviderStateMixin {
//   late AnimationController _ctrl;
//   bool _isScanning = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 2));
//   }
//
//   @override
//   void dispose() {
//     _ctrl.dispose();
//     super.dispose();
//   }
//
//   void _startScan() {
//     if (_isScanning) return;
//     setState(() => _isScanning = true);
//     _ctrl.repeat(reverse: true);
//     Future.delayed(const Duration(milliseconds: 1800), () {
//       if (mounted) {
//         setState(() => _isScanning = false);
//         _ctrl.stop();
//         _ctrl.reset();
//         widget.onScan();
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         GestureDetector(
//           onTap: _startScan,
//           child: Container(
//             width: 200, height: 200,
//             decoration: BoxDecoration(gradient: LinearGradient(colors: _isScanning ? [Colors.blue.shade500, Colors.blue.shade700] : [Colors.blue.shade400, Colors.blue.shade600], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(32), boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.4), blurRadius: _isScanning ? 30 : 15, spreadRadius: _isScanning ? 5 : 0)]),
//             child: Stack(
//               children: [
//                 const Positioned(top: 16, left: 16, child: _CornerBracket(turns: 0)),
//                 const Positioned(top: 16, right: 16, child: _CornerBracket(turns: 1)),
//                 const Positioned(bottom: 16, right: 16, child: _CornerBracket(turns: 2)),
//                 const Positioned(bottom: 16, left: 16, child: _CornerBracket(turns: 3)),
//
//                 Center(
//                   child: AnimatedBuilder(
//                     animation: _ctrl,
//                     builder: (context, child) => Transform.scale(scale: _isScanning ? 1.0 + (_ctrl.value * 0.1) : 1.0, child: child),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(_isScanning ? Icons.document_scanner_rounded : Icons.qr_code_2_rounded, size: 64, color: Colors.white.withOpacity(0.9)),
//                         const SizedBox(height: 8),
//                         Text(_isScanning ? 'Đang quét...' : 'Nhấn để quét', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12, fontWeight: FontWeight.w600)),
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 if (_isScanning)
//                   AnimatedBuilder(
//                     animation: _ctrl,
//                     builder: (context, child) {
//                       return Positioned(
//                         top: 20 + (_ctrl.value * 160),
//                         left: 20, right: 20,
//                         child: Container(height: 2, decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.8), blurRadius: 10, spreadRadius: 2)], gradient: LinearGradient(colors: [Colors.transparent, Colors.white, Colors.transparent]))),
//                       );
//                     },
//                   )
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),
//         Text(_isScanning ? '🔍 Đang nhận diện mã QR...' : 'Quét mã QR trên thẻ sinh viên', style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500)),
//       ],
//     );
//   }
// }
//
// class _CornerBracket extends StatelessWidget {
//   final int turns;
//   const _CornerBracket({required this.turns});
//   @override
//   Widget build(BuildContext context) {
//     return RotatedBox(quarterTurns: turns, child: Container(width: 24, height: 24, decoration: BoxDecoration(border: const Border(top: BorderSide(color: Colors.white54, width: 3), left: BorderSide(color: Colors.white54, width: 3)), borderRadius: BorderRadius.circular(4))));
//   }
// }
//
// // =========================================================================
// // WIDGET CON: Thẻ Sinh Viên hiện đại
// // =========================================================================
// class _StudentCard extends StatelessWidget {
//   final Student student;
//   final HealthRecord? record;
//   final String stationId;
//   final String campaignId;
//   final int index;
//
//   const _StudentCard({required this.student, required this.record, required this.stationId, required this.campaignId, required this.index});
//
//   @override
//   Widget build(BuildContext context) {
//     final completed = record?.completedStations ?? [];
//     final isDone = completed.contains(stationId);
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))]),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // ✨ ĐÃ SỬA: SỬ DỤNG MÃ QR THAY CHO AVATAR CHỮ CÁI
//                 Container(
//                   padding: const EdgeInsets.all(4),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: Colors.grey.shade200),
//                   ),
//                   child: QRCodeGenerator(
//                     student: student,
//                     campaignId: campaignId,
//                     size: 56, // Size vừa vặn đẹp trong thẻ card
//                     showDetails: false, // Tắt hiển thị tên dưới mã QR
//                   ),
//                 ),
//
//                 const SizedBox(width: 16),
//
//                 // Info
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(child: Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87), maxLines: 1, overflow: TextOverflow.ellipsis)),
//                           if (isDone)
//                             Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.green.shade200)), child: Row(children: [Icon(Icons.check_circle, color: Colors.green.shade500, size: 12), const SizedBox(width: 4), Text('Đã khám', style: TextStyle(color: Colors.green.shade700, fontSize: 10, fontWeight: FontWeight.bold))])),
//                         ],
//                       ),
//                       const SizedBox(height: 4),
//                       Text('${student.studentCode} • ${student.className}', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
//
//                       const SizedBox(height: 16),
//                       // Progress Bar Nhỏ (Circle + Pills)
//                       Row(
//                         children: [
//                           SizedBox(
//                             width: 36, height: 36,
//                             child: Stack(
//                               children: [
//                                 Center(child: CircularProgressIndicator(value: completed.length / totalStations, strokeWidth: 3, backgroundColor: Colors.grey.shade100, color: completed.length == totalStations ? Colors.green : Colors.blue)),
//                                 Center(child: Text('${completed.length}/$totalStations', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text('Tiến độ khám', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
//                                 const SizedBox(height: 4),
//                                 Row(
//                                   children: stationConfig.map((st) {
//                                     final stDone = completed.contains(st['id']);
//                                     final isCurrent = st['id'] == stationId;
//                                     return Expanded(
//                                       child: Container(
//                                         height: 20, margin: const EdgeInsets.only(right: 4),
//                                         decoration: BoxDecoration(color: stDone ? Colors.green.shade50 : isCurrent ? Colors.blue.shade50 : Colors.grey.shade100, border: Border.all(color: stDone ? Colors.green.shade200 : isCurrent ? Colors.blue.shade300 : Colors.grey.shade200), borderRadius: BorderRadius.circular(10)),
//                                         child: Center(child: stDone ? Icon(Icons.check, size: 10, color: Colors.green.shade500) : Icon(st['icon'], size: 10, color: isCurrent ? Colors.blue.shade400 : Colors.grey.shade400)),
//                                       ),
//                                     );
//                                   }).toList(),
//                                 )
//                               ],
//                             ),
//                           )
//                         ],
//                       )
//                     ],
//                   ),
//                 )
//               ],
//             ),
//             const SizedBox(height: 16),
//
//             // Nút Khám
//             SizedBox(
//               width: double.infinity,
//               height: 44,
//               child: ElevatedButton(
//                 onPressed: () async {
//                   final vm = context.read<StudentCheckInViewModel>();
//                   await Navigator.push(context, MaterialPageRoute(builder: (_) => ChangeNotifierProvider(create: (_) => sl<StationFormViewModel>(), child: StationFormWidget(student: student, stationId: stationId, initialRecord: record))));
//                   if (context.mounted) vm.loadData(campaignId);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: isDone ? Colors.grey.shade50 : Colors.blue.shade600,
//                   foregroundColor: isDone ? Colors.grey.shade700 : Colors.white,
//                   elevation: isDone ? 0 : 2,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: isDone ? BorderSide(color: Colors.grey.shade300) : BorderSide.none),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(isDone ? Icons.refresh_rounded : Icons.edit_document, size: 16),
//                     const SizedBox(width: 8),
//                     Text(isDone ? 'Khám lại trạm này' : 'Bắt đầu khám', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; // ✨ THÊM THƯ VIỆN CAMERA
import '../../di.dart';
import '../../domain/entities/student.dart';
import '../../domain/entities/health_record.dart';
import '../../viewmodels/health_staff/station_form_viewmodel.dart';
import '../../viewmodels/health_staff/student_check_in_viewmodel.dart';
import '../shared/qr_code_generator.dart';
import 'widgets/station_form_widget.dart';

// --- CONFIGURATION ---
const int totalStations = 4;
final List<Map<String, dynamic>> stationConfig = [
  {'id': 'physical', 'name': 'Đo thể lực', 'icon': Icons.monitor_heart_rounded},
  {'id': 'vision', 'name': 'Khám thị lực', 'icon': Icons.remove_red_eye_rounded},
  {'id': 'blood_pressure', 'name': 'Đo huyết áp', 'icon': Icons.favorite_rounded},
  {'id': 'general', 'name': 'Khám tổng quát', 'icon': Icons.medical_services_rounded},
];

class StudentCheckInPage extends StatefulWidget {
  final String campaignId;
  final String stationId;
  const StudentCheckInPage({super.key, required this.campaignId, required this.stationId});

  @override
  State<StudentCheckInPage> createState() => _StudentCheckInPageState();
}

class _StudentCheckInPageState extends State<StudentCheckInPage> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<StudentCheckInViewModel>().loadData(widget.campaignId));
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StudentCheckInViewModel>();
    final currentStation = stationConfig.firstWhere((s) => s['id'] == widget.stationId, orElse: () => stationConfig.first);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Check-in Sinh Viên', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _StationHeaderCard(
                    stationName: currentStation['name'],
                    icon: currentStation['icon'],
                    checkedInCount: vm.allStudents.where((s) {
                      final r = vm.getRecord(s.id);
                      return r != null && r.completedStations.contains(widget.stationId);
                    }).length,
                    totalStudents: vm.allStudents.length,
                  ),
                  const SizedBox(height: 16),

                  // ✨ GỌI WIDGET MỞ CAMERA THẬT
                  _RealQRScannerButton(
                      onScanResult: (String studentCode) {
                        _searchCtrl.text = studentCode; // Điền mã vào ô text
                        vm.searchStudent(studentCode);  // Gọi lệnh tìm kiếm
                      }
                  ),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(child: Container(height: 1, decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.transparent, Colors.grey.shade300])))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                          child: Text('hoặc nhập thủ công', style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      Expanded(child: Container(height: 1, decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.grey.shade300, Colors.transparent])))),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 4))]),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        Icon(Icons.search, color: Colors.grey.shade400),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchCtrl,
                            onChanged: vm.searchStudent,
                            decoration: InputDecoration(
                              hintText: 'Mã SV hoặc tên sinh viên...',
                              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                        if (_searchCtrl.text.isNotEmpty)
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.grey.shade400, size: 20),
                            onPressed: () {
                              _searchCtrl.clear();
                              vm.searchStudent('');
                            },
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  if (vm.searchResults.isNotEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Container(width: 6, height: 6, decoration: BoxDecoration(color: Colors.blue.shade400, shape: BoxShape.circle)),
                          const SizedBox(width: 8),
                          Text('Tìm thấy ${vm.searchResults.length} sinh viên', style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    )
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: vm.searchQuery.isEmpty
                ? SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Column(
                    children: [
                      Container(width: 80, height: 80, decoration: BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle), child: Icon(Icons.qr_code_scanner_rounded, size: 40, color: Colors.blue.shade400)),
                      const SizedBox(height: 20),
                      Text('Hãy quét QR hoặc nhập tìm kiếm', style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      Text('Danh sách sinh viên sẽ hiện ra tại đây', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                    ],
                  ),
                ),
              ),
            )
                : vm.searchResults.isEmpty
                ? SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Column(
                    children: [
                      Container(width: 64, height: 64, decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle), child: Icon(Icons.search_off_rounded, size: 32, color: Colors.grey.shade400)),
                      const SizedBox(height: 16),
                      Text('Không tìm thấy sinh viên', style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            )
                : SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final student = vm.searchResults[index];
                  final record = vm.getRecord(student.id);
                  return _StudentCard(
                    student: student,
                    record: record,
                    stationId: widget.stationId,
                    campaignId: widget.campaignId,
                    index: index,
                  );
                },
                childCount: vm.searchResults.length,
              ),
            ),
          )
        ],
      ),
    );
  }
}

// =========================================================================
// WIDGET CON: Header Trạm
// =========================================================================
class _StationHeaderCard extends StatelessWidget {
  final String stationName;
  final IconData icon;
  final int checkedInCount;
  final int totalStudents;

  const _StationHeaderCard({required this.stationName, required this.icon, required this.checkedInCount, required this.totalStudents});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 4))]),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.blue.shade400, Colors.blue.shade600]), borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
            child: Row(
              children: [
                Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(16)), child: Icon(icon, color: Colors.white, size: 28)),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Trạm y tế'.toUpperCase(), style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)), const SizedBox(height: 2), Text(stationName, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))])),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle), child: Icon(Icons.check_circle, color: Colors.green.shade500, size: 14)),
                const SizedBox(width: 8),
                Text('$checkedInCount đã khám hôm nay', style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: SizedBox(height: 12, child: VerticalDivider(width: 1, color: Colors.grey))),
                Icon(Icons.people, color: Colors.blue.shade500, size: 16),
                const SizedBox(width: 8),
                Text('$totalStudents sinh viên', style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// =========================================================================
// WIDGET CON: Nút Nhấn Mở Camera Quét QR
// =========================================================================
class _RealQRScannerButton extends StatelessWidget {
  final Function(String) onScanResult;
  const _RealQRScannerButton({required this.onScanResult});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            // Mở màn hình Camera
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const QRScannerScreen()),
            );

            // Nhận kết quả trả về từ Camera
            if (result != null && result.toString().isNotEmpty) {
              onScanResult(result.toString());
            }
          },
          child: Container(
            width: 200, height: 200,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.blue.shade400, Colors.blue.shade600], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 15, spreadRadius: 0)]
            ),
            child: Stack(
              children: [
                const Positioned(top: 16, left: 16, child: _CornerBracket(turns: 0)),
                const Positioned(top: 16, right: 16, child: _CornerBracket(turns: 1)),
                const Positioned(bottom: 16, right: 16, child: _CornerBracket(turns: 2)),
                const Positioned(bottom: 16, left: 16, child: _CornerBracket(turns: 3)),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.camera_alt_rounded, size: 64, color: Colors.white.withOpacity(0.9)),
                      const SizedBox(height: 8),
                      Text('Nhấn để mở Camera', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text('Quét mã QR trên thẻ/email của sinh viên', style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _CornerBracket extends StatelessWidget {
  final int turns;
  const _CornerBracket({required this.turns});
  @override
  Widget build(BuildContext context) {
    return RotatedBox(quarterTurns: turns, child: Container(width: 24, height: 24, decoration: BoxDecoration(border: const Border(top: BorderSide(color: Colors.white54, width: 3), left: BorderSide(color: Colors.white54, width: 3)), borderRadius: BorderRadius.circular(4))));
  }
}

// =========================================================================
// MÀN HÌNH MỚI: Giao diện Camera Quét Mã Vạch (ĐÃ FIX LỖI PHIÊN BẢN MỚI)
// =========================================================================
class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});
  
  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final MobileScannerController cameraController = MobileScannerController();
  bool _isProcessing = false;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Di chuyển Camera vào mã QR', style: TextStyle(fontSize: 16)),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Nút bật/tắt đèn Flash
          IconButton(
            icon: ValueListenableBuilder<MobileScannerState>(
              valueListenable: cameraController,
              builder: (context, state, child) {
                // Sử dụng state.torchState thay vì gọi trực tiếp từ controller
                switch (state.torchState) {
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                  case TorchState.off:
                  case TorchState.unavailable:
                  default: // Bắt buộc phải có default để tránh trả về null Widget
                    return const Icon(Icons.flash_off, color: Colors.grey);
                }
              },
            ),
            onPressed: () => cameraController.toggleTorch(),
          ),
          // Nút xoay Camera trước/sau
          IconButton(
            icon: ValueListenableBuilder<MobileScannerState>(
              valueListenable: cameraController,
              builder: (context, state, child) {
                // Sử dụng state.cameraDirection thay vì cameraFacingState
                switch (state.cameraDirection) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front, color: Colors.white);
                  case CameraFacing.back:
                  case CameraFacing.external:
                  case CameraFacing.unknown:
                  default: // Bắt buộc phải có default để tránh trả về null Widget
                    return const Icon(Icons.camera_rear, color: Colors.white);
                }
              },
            ),
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              if (_isProcessing) return;
              final List<Barcode> barcodes = capture.barcodes;

              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  _isProcessing = true; // Khóa lại tránh camera quét liên tục 10 lần/giây
                  final rawValue = barcode.rawValue!;
                  String studentCode = rawValue;

                  // BÓC TÁCH JSON: Vì lúc tạo QR ta dùng {"studentCode":"SV001", "campaignId":"..."}
                  try {
                    final data = jsonDecode(rawValue);
                    if (data['studentCode'] != null) {
                      studentCode = data['studentCode'];
                    }
                  } catch (_) {
                    // Nếu QR không phải chuẩn JSON của ta, cứ lấy giá trị gốc
                  }

                  // Đóng màn hình camera và trả mã SV về
                  Navigator.pop(context, studentCode);
                  break;
                }
              }
            },
          ),
          // Khung viền ngắm quét QR
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.greenAccent, width: 3),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// WIDGET CON: Thẻ Sinh Viên
// =========================================================================
class _StudentCard extends StatelessWidget {
  final Student student;
  final HealthRecord? record;
  final String stationId;
  final String campaignId;
  final int index;

  const _StudentCard({required this.student, required this.record, required this.stationId, required this.campaignId, required this.index});

  @override
  Widget build(BuildContext context) {
    final completed = record?.completedStations ?? [];
    final isDone = completed.contains(stationId);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: QRCodeGenerator(
                    student: student,
                    campaignId: campaignId,
                    size: 56,
                    showDetails: false,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87), maxLines: 1, overflow: TextOverflow.ellipsis)),
                          if (isDone)
                            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.green.shade200)), child: Row(children: [Icon(Icons.check_circle, color: Colors.green.shade500, size: 12), const SizedBox(width: 4), Text('Đã khám', style: TextStyle(color: Colors.green.shade700, fontSize: 10, fontWeight: FontWeight.bold))])),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('${student.studentCode} • ${student.className}', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),

                      const SizedBox(height: 16),
                      Row(
                        children: [
                          SizedBox(
                            width: 36, height: 36,
                            child: Stack(
                              children: [
                                Center(child: CircularProgressIndicator(value: completed.length / totalStations, strokeWidth: 3, backgroundColor: Colors.grey.shade100, color: completed.length == totalStations ? Colors.green : Colors.blue)),
                                Center(child: Text('${completed.length}/$totalStations', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tiến độ khám', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                                const SizedBox(height: 4),
                                Row(
                                  children: stationConfig.map((st) {
                                    final stDone = completed.contains(st['id']);
                                    final isCurrent = st['id'] == stationId;
                                    return Expanded(
                                      child: Container(
                                        height: 20, margin: const EdgeInsets.only(right: 4),
                                        decoration: BoxDecoration(color: stDone ? Colors.green.shade50 : isCurrent ? Colors.blue.shade50 : Colors.grey.shade100, border: Border.all(color: stDone ? Colors.green.shade200 : isCurrent ? Colors.blue.shade300 : Colors.grey.shade200), borderRadius: BorderRadius.circular(10)),
                                        child: Center(child: stDone ? Icon(Icons.check, size: 10, color: Colors.green.shade500) : Icon(st['icon'], size: 10, color: isCurrent ? Colors.blue.shade400 : Colors.grey.shade400)),
                                      ),
                                    );
                                  }).toList(),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () async {
                  final vm = context.read<StudentCheckInViewModel>();
                  await Navigator.push(context, MaterialPageRoute(builder: (_) => ChangeNotifierProvider(create: (_) => sl<StationFormViewModel>(), child: StationFormWidget(student: student, stationId: stationId, initialRecord: record))));
                  if (context.mounted) vm.loadData(campaignId);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDone ? Colors.grey.shade50 : Colors.blue.shade600,
                  foregroundColor: isDone ? Colors.grey.shade700 : Colors.white,
                  elevation: isDone ? 0 : 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: isDone ? BorderSide(color: Colors.grey.shade300) : BorderSide.none),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(isDone ? Icons.refresh_rounded : Icons.edit_document, size: 16),
                    const SizedBox(width: 8),
                    Text(isDone ? 'Khám lại trạm này' : 'Bắt đầu khám', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}