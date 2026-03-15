// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:fl_chart/fl_chart.dart';
// import '../../viewmodels/admin/reports_viewmodel.dart';
// import '../../di.dart';
//
// class ReportsPage extends StatelessWidget {
//   const ReportsPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => sl<ReportsViewModel>(),
//       child: Consumer<ReportsViewModel>(
//         builder: (context, viewModel, child) {
//           if (viewModel.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           final stats = viewModel.bmiStats;
//
//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Báo cáo & Thống kê',
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
//                 ),
//                 const SizedBox(height: 16),
//
//                 // 1. Thanh Công cụ (Lọc & Xuất báo cáo)
//                 _buildActionToolbar(viewModel),
//                 const SizedBox(height: 16),
//
//                 if (stats == null || stats['total'] == 0)
//                   _buildEmptyState()
//                 else ...[
//                   // 2. Các thẻ thống kê nhanh (Stat Cards)
//                   _buildStatCardsRow(stats),
//                   const SizedBox(height: 16),
//
//                   // 3. Hàng biểu đồ (Phân bố BMI & Biểu đồ tròn)
//                   _buildChartsRow(stats),
//                   const SizedBox(height: 16),
//
//                   // 4. Biểu đồ hoàn thành theo lớp (Mockup theo React)
//                   _buildClassCompletionChart(),
//                   const SizedBox(height: 16),
//
//                   // 5. Bảng dữ liệu chi tiết
//                   _buildDataTable(stats),
//                 ]
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   // --- WIDGETS CON ---
//
//   Widget _buildCard({required Widget child, EdgeInsetsGeometry? padding}) {
//     return Container(
//       width: double.infinity,
//       padding: padding ?? const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade200),
//         boxShadow: [
//           BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2)),
//         ],
//       ),
//       child: child,
//     );
//   }
//
//   Widget _buildActionToolbar(ReportsViewModel vm) {
//     return _buildCard(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           // 1. Hàng chứa 2 bộ lọc: Chiến dịch và Lớp (Nằm ngang chia đều không gian)
//           Row(
//             children: [
//               // Box Chọn Chiến Dịch
//               Expanded(
//                 flex: 5,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Chiến dịch',
//                       style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
//                     ),
//                     const SizedBox(height: 8),
//                     Container(
//                       height: 48,
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade50, // Màu nền xám nhạt như ảnh
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(color: Colors.grey.shade200),
//                       ),
//                       child: DropdownButtonHideUnderline(
//                         child: DropdownButton<String>(
//                           isExpanded: true,
//                           value: vm.selectedCampaignId,
//                           icon: Icon(Icons.keyboard_arrow_down_rounded, size: 24, color: Colors.grey.shade500),
//                           items: vm.campaigns.map((c) => DropdownMenuItem(
//                             value: c.id,
//                             child: Text(
//                               c.name,
//                               overflow: TextOverflow.ellipsis,
//                               style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87),
//                             ),
//                           )).toList(),
//                           onChanged: (val) => vm.setCampaignId(val!),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(width: 12), // Khoảng cách giữa 2 bộ lọc
//
//               // Box Chọn Lớp (Mới thêm vào)
//               Expanded(
//                 flex: 4,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Lớp',
//                       style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
//                     ),
//                     const SizedBox(height: 8),
//                     Container(
//                       height: 48,
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade50, // Đồng bộ màu nền
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(color: Colors.grey.shade200),
//                       ),
//                       child: DropdownButtonHideUnderline(
//                         child: DropdownButton<String>(
//                           isExpanded: true,
//                           value: vm.selectedClass, // Biến state từ ViewModel
//                           icon: Icon(Icons.keyboard_arrow_down_rounded, size: 24, color: Colors.grey.shade500),
//                           items: [
//                             const DropdownMenuItem(
//                               value: 'all',
//                               child: Text('Tất cả lớp', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87)),
//                             ),
//                             ...vm.availableClasses.map((c) => DropdownMenuItem(
//                               value: c,
//                               child: Text(c, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87)),
//                             )).toList(),
//                           ],
//                           onChanged: (val) => vm.setSelectedClass(val!),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 16), // Khoảng cách giữa phần Lọc và Nút
//
//           // 2. Ba nút chức năng nằm trên 1 hàng ngang
//           Row(
//             children: [
//               // Nút Tạo Báo Cáo
//               Expanded(
//                 flex: 4,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue.shade600,
//                     foregroundColor: Colors.white,
//                     elevation: 0,
//                     padding: const EdgeInsets.symmetric(vertical: 12),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                   ),
//                   onPressed: () {},
//                   child: const Text('Tạo báo cáo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
//                 ),
//               ),
//               const SizedBox(width: 8),
//
//               // Nút Xuất PDF
//               Expanded(
//                 flex: 3,
//                 child: OutlinedButton.icon(
//                   style: OutlinedButton.styleFrom(
//                     foregroundColor: Colors.black87,
//                     backgroundColor: Colors.white,
//                     side: BorderSide(color: Colors.grey.shade300),
//                     padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                   ),
//                   onPressed: () {},
//                   icon: const Icon(Icons.picture_as_pdf_rounded, size: 16, color: Colors.redAccent),
//                   label: const Text('Xuất PDF', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
//                 ),
//               ),
//               const SizedBox(width: 8),
//
//               // Nút Xuất Excel
//               Expanded(
//                 flex: 3,
//                 child: OutlinedButton.icon(
//                   style: OutlinedButton.styleFrom(
//                     foregroundColor: Colors.green.shade700,
//                     backgroundColor: Colors.green.shade50,
//                     side: BorderSide(color: Colors.green.shade200),
//                     padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                   ),
//                   onPressed: () {},
//                   icon: const Icon(Icons.table_view_rounded, size: 16),
//                   label: const Text('Excel', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatCardsRow(Map<String, dynamic> stats) {
//     return GridView.count(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       crossAxisCount: 2, // 2 cột cho thiết bị di động
//       childAspectRatio: 1.6, // Tỉ lệ khung hình thẻ
//       mainAxisSpacing: 12,
//       crossAxisSpacing: 12,
//       children: [
//         _buildSingleStatCard('👥', 'Hoàn thành (cả 4 trạm)', '${stats['total']}', Colors.blue.shade600, 'Tất cả sinh viên'),
//         _buildSingleStatCard('⚖️', 'BMI Bình thường', '${stats['normal']}', Colors.teal.shade500, 'Sức khỏe tốt'),
//         // Dữ liệu giả định theo bản React để lấp đầy Dashboard
//         _buildSingleStatCard('🫀', 'Huyết áp cao', '0', Colors.red.shade500, 'Cần theo dõi'),
//         _buildSingleStatCard('👁️', 'Thị lực kém', '0', Colors.orange.shade500, 'Cần khám lại'),
//       ],
//     );
//   }
//
//   Widget _buildSingleStatCard(String emoji, String label, String value, Color color, String sub) {
//     return _buildCard(
//       padding: const EdgeInsets.all(12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Row(
//             children: [
//               Text(emoji, style: const TextStyle(fontSize: 18)),
//               const SizedBox(width: 8),
//               Expanded(child: Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis)),
//             ],
//           ),
//           const Spacer(),
//           Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
//           Text(sub, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildChartsRow(Map<String, dynamic> stats) {
//     // Để chống tràn trên Mobile, chúng ta xếp dọc (Column) thay vì ngang (Row)
//     return Column(
//       children: [
//         _buildCard(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text('Phân bố BMI', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
//               Text('n=${stats['total']} sinh viên hoàn thành', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
//               const SizedBox(height: 24),
//               SizedBox(
//                 height: 200,
//                 child: BarChart(
//                   BarChartData(
//                     alignment: BarChartAlignment.spaceAround,
//                     maxY: stats['total'].toDouble() * 1.2, // Tăng thêm 20% khoảng trống phía trên
//                     barTouchData: BarTouchData(enabled: false),
//                     titlesData: FlTitlesData(
//                       show: true,
//                       bottomTitles: AxisTitles(
//                         sideTitles: SideTitles(
//                           showTitles: true,
//                           getTitlesWidget: (double value, TitleMeta meta) {
//                             const titles = ['Thiếu cân', 'Bình thường', 'Thừa cân', 'Béo phì'];
//                             return Padding(
//                               padding: const EdgeInsets.only(top: 8.0),
//                               child: Text(titles[value.toInt()], style: TextStyle(color: Colors.grey.shade600, fontSize: 10, fontWeight: FontWeight.w600)),
//                             );
//                           },
//                         ),
//                       ),
//                       leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                       topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                       rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                     ),
//                     gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade100, strokeWidth: 1)),
//                     borderData: FlBorderData(show: false),
//                     barGroups: [
//                       _makeBarData(0, stats['underweight'].toDouble(), Colors.blue.shade400),
//                       _makeBarData(1, stats['normal'].toDouble(), Colors.teal.shade500),
//                       _makeBarData(2, stats['overweight'].toDouble(), Colors.orange.shade400),
//                       _makeBarData(3, stats['obese'].toDouble(), Colors.red.shade400),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 16),
//         _buildCard(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text('Biểu đồ tròn BMI', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
//               Text('Tổng quan phân bố', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
//               const SizedBox(height: 24),
//               SizedBox(
//                 height: 160,
//                 child: PieChart(
//                   PieChartData(
//                     sectionsSpace: 2,
//                     centerSpaceRadius: 40,
//                     sections: [
//                       if (stats['underweight'] > 0) PieChartSectionData(value: stats['underweight'].toDouble(), color: Colors.blue.shade400, title: '${stats['underweightPercent'].round()}%', radius: 40, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
//                       if (stats['normal'] > 0) PieChartSectionData(value: stats['normal'].toDouble(), color: Colors.teal.shade500, title: '${stats['normalPercent'].round()}%', radius: 45, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
//                       if (stats['overweight'] > 0) PieChartSectionData(value: stats['overweight'].toDouble(), color: Colors.orange.shade400, title: '${stats['overweightPercent'].round()}%', radius: 40, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
//                       if (stats['obese'] > 0) PieChartSectionData(value: stats['obese'].toDouble(), color: Colors.red.shade400, title: '${stats['obesePercent'].round()}%', radius: 40, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   BarChartGroupData _makeBarData(int x, double y, Color color) {
//     return BarChartGroupData(
//       x: x,
//       barRods: [
//         BarChartRodData(
//           toY: y,
//           color: color,
//           width: 22,
//           borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildClassCompletionChart() {
//     return _buildCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('Hoàn thành theo lớp', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
//           Text('Sinh viên hoàn thành cả 4 trạm', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
//           const SizedBox(height: 24),
//           SizedBox(
//             height: 180,
//             child: BarChart(
//               BarChartData(
//                 alignment: BarChartAlignment.spaceAround,
//                 maxY: 80,
//                 barTouchData: BarTouchData(enabled: false),
//                 titlesData: FlTitlesData(
//                   show: true,
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       getTitlesWidget: (double value, TitleMeta meta) {
//                         const titles = ['CNTT-K21A', 'CNTT-K21B', 'KT-K21A', 'KT-K21B'];
//                         return Padding(
//                           padding: const EdgeInsets.only(top: 8.0),
//                           child: Text(titles[value.toInt()], style: TextStyle(color: Colors.grey.shade600, fontSize: 10, fontWeight: FontWeight.w600)),
//                         );
//                       },
//                     ),
//                   ),
//                   leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                   topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                   rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                 ),
//                 gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade100, strokeWidth: 1)),
//                 borderData: FlBorderData(show: false),
//                 barGroups: [
//                   _makeBarData(0, 68, Colors.blue.shade500),
//                   _makeBarData(1, 72, Colors.purple.shade400),
//                   _makeBarData(2, 45, Colors.teal.shade500),
//                   _makeBarData(3, 25, Colors.orange.shade400),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDataTable(Map<String, dynamic> stats) {
//     final rows = [
//       {'l': 'Thiếu cân', 'v': stats['underweight'], 'p': stats['underweightPercent'], 'c': Colors.blue.shade400},
//       {'l': 'Bình thường', 'v': stats['normal'], 'p': stats['normalPercent'], 'c': Colors.teal.shade500},
//       {'l': 'Thừa cân', 'v': stats['overweight'], 'p': stats['overweightPercent'], 'c': Colors.orange.shade400},
//       {'l': 'Béo phì', 'v': stats['obese'], 'p': stats['obesePercent'], 'c': Colors.red.shade400},
//     ];
//
//     return _buildCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('Bảng tổng hợp BMI', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
//           const SizedBox(height: 12),
//
//           // Table Header
//           Container(
//             padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//             decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
//             child: Row(
//               children: [
//                 Expanded(flex: 3, child: Text('Phân loại', style: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.bold))),
//                 Expanded(flex: 2, child: Text('Số lượng', style: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.bold))),
//                 Expanded(flex: 2, child: Text('Tỷ lệ', style: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.bold))),
//                 Expanded(flex: 1, child: Text('Mức độ', style: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.right)),
//               ],
//             ),
//           ),
//
//           // Table Body
//           ...rows.map((r) => Container(
//             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
//             decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade100))),
//             child: Row(
//               children: [
//                 Expanded(
//                     flex: 3,
//                     child: Row(
//                       children: [
//                         Container(width: 10, height: 10, decoration: BoxDecoration(color: r['c'] as Color, borderRadius: BorderRadius.circular(2))),
//                         const SizedBox(width: 8),
//                         Text('${r['l']}', style: const TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w500)),
//                       ],
//                     )
//                 ),
//                 Expanded(flex: 2, child: Text('${r['v']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87))),
//                 Expanded(flex: 2, child: Text('${(r['p'] as double).round()}%', style: TextStyle(fontSize: 13, color: Colors.grey.shade600))),
//                 Expanded(flex: 1, child: Align(alignment: Alignment.centerRight, child: Icon(Icons.circle, size: 12, color: r['c'] as Color))),
//               ],
//             ),
//           )),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return _buildCard(
//       padding: const EdgeInsets.all(40),
//       child: Center(
//         child: Column(
//           children: [
//             Icon(Icons.analytics_outlined, size: 48, color: Colors.grey.shade400),
//             const SizedBox(height: 16),
//             const Text('Chưa có dữ liệu thống kê', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
//             Text('Vui lòng chọn chiến dịch khác hoặc đợi sinh viên hoàn tất khám.', style: TextStyle(color: Colors.grey.shade500, fontSize: 13), textAlign: TextAlign.center),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:fl_chart/fl_chart.dart';
// import '../../viewmodels/admin/reports_viewmodel.dart';
// import '../../di.dart';
// import 'widgets/report_export_dialog.dart';
//
// class ReportsPage extends StatelessWidget {
//   const ReportsPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => sl<ReportsViewModel>(),
//       child: Consumer<ReportsViewModel>(
//         builder: (context, viewModel, child) {
//           if (viewModel.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           final stats = viewModel.bmiStats;
//
//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Báo cáo & Thống kê',
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
//                 ),
//                 const SizedBox(height: 16),
//
//                 // 1. Thanh Công cụ (Lọc & Xuất báo cáo)
//                 _buildActionToolbar(context, viewModel),
//                 const SizedBox(height: 16),
//
//                 if (stats == null || stats['total'] == 0)
//                   _buildEmptyState()
//                 else ...[
//                   // 2. Các thẻ thống kê nhanh (Stat Cards)
//                   _buildStatCardsRow(stats),
//                   const SizedBox(height: 16),
//
//                   // 3. Hàng biểu đồ (Phân bố BMI & Biểu đồ tròn)
//                   _buildChartsRow(stats),
//                   const SizedBox(height: 16),
//
//                   // 4. Biểu đồ hoàn thành theo lớp (Dữ liệu THỰC từ Database)
//                   _buildClassCompletionChart(viewModel.classCompletionStats),
//                   const SizedBox(height: 16),
//
//                   // 5. Bảng dữ liệu chi tiết
//                   _buildDataTable(stats),
//                 ]
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   // --- WIDGETS CON ---
//
//   // ✨ HÀM HIỂN THỊ HỘP THOẠI XUẤT BÁO CÁO BẠN VỪA YÊU CẦU THÊM VÀO
//   void _showExportDialog(BuildContext context, ReportsViewModel vm, String type) {
//     if (vm.bmiStats == null) return; // Nếu không có dữ liệu thì không cho xuất
//
//     // Lấy tên chiến dịch hiện tại để làm tên báo cáo mặc định
//     final campaignName = vm.campaigns.firstWhere((c) => c.id == vm.selectedCampaignId).name;
//
//     showDialog(
//       context: context,
//       builder: (BuildContext dialogContext) {
//         return ReportExportDialog(
//           exportType: type,
//           defaultCampaignName: campaignName,
//           onConfirm: (title, notes) {
//             if (type == 'pdf') {
//               vm.exportToPdf(context, title, notes);
//             } else {
//               vm.exportToExcel(context, title, notes);
//             }
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildCard({required Widget child, EdgeInsetsGeometry? padding}) {
//     return Container(
//       width: double.infinity,
//       padding: padding ?? const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade200),
//         boxShadow: [
//           BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2)),
//         ],
//       ),
//       child: child,
//     );
//   }
//
//   Widget _buildActionToolbar(BuildContext context, ReportsViewModel vm) {
//     return _buildCard(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 flex: 5,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Chiến dịch', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
//                     const SizedBox(height: 8),
//                     Container(
//                       height: 48,
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade200)),
//                       child: DropdownButtonHideUnderline(
//                         child: DropdownButton<String>(
//                           isExpanded: true,
//                           value: vm.selectedCampaignId,
//                           icon: Icon(Icons.keyboard_arrow_down_rounded, size: 24, color: Colors.grey.shade500),
//                           items: vm.campaigns.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87)))).toList(),
//                           onChanged: (val) => vm.setCampaignId(val!),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 flex: 4,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Lớp', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
//                     const SizedBox(height: 8),
//                     Container(
//                       height: 48,
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade200)),
//                       child: DropdownButtonHideUnderline(
//                         child: DropdownButton<String>(
//                           isExpanded: true,
//                           value: vm.selectedClass,
//                           icon: Icon(Icons.keyboard_arrow_down_rounded, size: 24, color: Colors.grey.shade500),
//                           items: [
//                             const DropdownMenuItem(value: 'all', child: Text('Tất cả lớp', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87))),
//                             ...vm.availableClasses.map((c) => DropdownMenuItem(value: c, child: Text(c, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87)))).toList(),
//                           ],
//                           onChanged: (val) => vm.setSelectedClass(val!),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(
//                 flex: 4,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade600, foregroundColor: Colors.white, elevation: 0, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
//                   onPressed: () => vm.refreshReport(context),
//                   child: const Text('Tạo báo cáo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 flex: 3,
//                 child: OutlinedButton.icon(
//                   style: OutlinedButton.styleFrom(foregroundColor: Colors.black87, backgroundColor: Colors.white, side: BorderSide(color: Colors.grey.shade300), padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
//                   // ✨ ĐÃ SỬA: Gọi form xem trước cho PDF
//                   onPressed: () => _showExportDialog(context, vm, 'pdf'),
//                   icon: const Icon(Icons.picture_as_pdf_rounded, size: 16, color: Colors.redAccent),
//                   label: const Text('Xuất PDF', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 flex: 3,
//                 child: OutlinedButton.icon(
//                   style: OutlinedButton.styleFrom(foregroundColor: Colors.green.shade700, backgroundColor: Colors.green.shade50, side: BorderSide(color: Colors.green.shade200), padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
//                   // ✨ ĐÃ SỬA: Gọi form xem trước cho Excel
//                   onPressed: () => _showExportDialog(context, vm, 'excel'),
//                   icon: const Icon(Icons.table_view_rounded, size: 16),
//                   label: const Text('Excel', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatCardsRow(Map<String, dynamic> stats) {
//     return GridView.count(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       crossAxisCount: 2,
//       childAspectRatio: 1.6,
//       mainAxisSpacing: 12,
//       crossAxisSpacing: 12,
//       children: [
//         _buildSingleStatCard('👥', 'Hoàn thành (cả 4 trạm)', '${stats['total']}', Colors.blue.shade600, 'Tất cả sinh viên'),
//         _buildSingleStatCard('⚖️', 'BMI Bình thường', '${stats['normal']}', Colors.teal.shade500, 'Sức khỏe tốt'),
//         _buildSingleStatCard('🫀', 'Huyết áp cao', '0', Colors.red.shade500, 'Cần theo dõi'),
//         _buildSingleStatCard('👁️', 'Thị lực kém', '0', Colors.orange.shade500, 'Cần khám lại'),
//       ],
//     );
//   }
//
//   Widget _buildSingleStatCard(String emoji, String label, String value, Color color, String sub) {
//     return _buildCard(
//       padding: const EdgeInsets.all(12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Row(
//             children: [
//               Text(emoji, style: const TextStyle(fontSize: 18)),
//               const SizedBox(width: 8),
//               Expanded(child: Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis)),
//             ],
//           ),
//           const Spacer(),
//           Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
//           Text(sub, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildChartsRow(Map<String, dynamic> stats) {
//     return Column(
//       children: [
//         _buildCard(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text('Phân bố BMI', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
//               Text('n=${stats['total']} sinh viên hoàn thành', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
//               const SizedBox(height: 24),
//               SizedBox(
//                 height: 200,
//                 child: BarChart(
//                   BarChartData(
//                     alignment: BarChartAlignment.spaceAround,
//                     maxY: stats['total'].toDouble() * 1.2,
//                     barTouchData: BarTouchData(enabled: false),
//                     titlesData: FlTitlesData(
//                       show: true,
//                       bottomTitles: AxisTitles(
//                         sideTitles: SideTitles(
//                           showTitles: true,
//                           getTitlesWidget: (double value, TitleMeta meta) {
//                             const titles = ['Thiếu cân', 'Bình thường', 'Thừa cân', 'Béo phì'];
//                             return Padding(
//                               padding: const EdgeInsets.only(top: 8.0),
//                               child: Text(titles[value.toInt()], style: TextStyle(color: Colors.grey.shade600, fontSize: 10, fontWeight: FontWeight.w600)),
//                             );
//                           },
//                         ),
//                       ),
//                       leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                       topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                       rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                     ),
//                     gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade100, strokeWidth: 1)),
//                     borderData: FlBorderData(show: false),
//                     barGroups: [
//                       _makeBarData(0, stats['underweight'].toDouble(), Colors.blue.shade400),
//                       _makeBarData(1, stats['normal'].toDouble(), Colors.teal.shade500),
//                       _makeBarData(2, stats['overweight'].toDouble(), Colors.orange.shade400),
//                       _makeBarData(3, stats['obese'].toDouble(), Colors.red.shade400),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 16),
//         _buildCard(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text('Biểu đồ tròn BMI', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
//               Text('Tổng quan phân bố', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
//               const SizedBox(height: 24),
//               SizedBox(
//                 height: 160,
//                 child: PieChart(
//                   PieChartData(
//                     sectionsSpace: 2,
//                     centerSpaceRadius: 40,
//                     sections: [
//                       if (stats['underweight'] > 0) PieChartSectionData(value: stats['underweight'].toDouble(), color: Colors.blue.shade400, title: '${stats['underweightPercent'].round()}%', radius: 40, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
//                       if (stats['normal'] > 0) PieChartSectionData(value: stats['normal'].toDouble(), color: Colors.teal.shade500, title: '${stats['normalPercent'].round()}%', radius: 45, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
//                       if (stats['overweight'] > 0) PieChartSectionData(value: stats['overweight'].toDouble(), color: Colors.orange.shade400, title: '${stats['overweightPercent'].round()}%', radius: 40, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
//                       if (stats['obese'] > 0) PieChartSectionData(value: stats['obese'].toDouble(), color: Colors.red.shade400, title: '${stats['obesePercent'].round()}%', radius: 40, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   BarChartGroupData _makeBarData(int x, double y, Color color) {
//     return BarChartGroupData(
//       x: x,
//       barRods: [
//         BarChartRodData(
//           toY: y,
//           color: color,
//           width: 22,
//           borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildClassCompletionChart(Map<String, int> classStats) {
//     if (classStats.isEmpty) {
//       return _buildCard(
//         child: const Center(
//           child: Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Text('Chưa có sinh viên nào hoàn thành cả 4 trạm.', style: TextStyle(color: Colors.grey)),
//           ),
//         ),
//       );
//     }
//
//     final classNames = classStats.keys.toList();
//     final completionCounts = classStats.values.toList();
//
//     // Tính toán trục Y sao cho không bị chạm nóc (Max + 20%)
//     double maxCount = completionCounts.reduce((a, b) => a > b ? a : b).toDouble();
//     if (maxCount == 0) maxCount = 10;
//
//     // Bảng màu cho các cột
//     final barColors = [
//       Colors.blue.shade500, Colors.purple.shade400, Colors.teal.shade500,
//       Colors.orange.shade400, Colors.pink.shade400
//     ];
//
//     return _buildCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('Hoàn thành theo lớp', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
//           Text('Sinh viên hoàn thành cả 4 trạm', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
//           const SizedBox(height: 24),
//           SizedBox(
//             height: 180,
//             child: BarChart(
//               BarChartData(
//                 alignment: BarChartAlignment.spaceAround,
//                 maxY: maxCount * 1.2,
//                 barTouchData: BarTouchData(enabled: false),
//                 titlesData: FlTitlesData(
//                   show: true,
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       getTitlesWidget: (double value, TitleMeta meta) {
//                         final index = value.toInt();
//                         if (index < 0 || index >= classNames.length) return const SizedBox.shrink();
//
//                         return Padding(
//                           padding: const EdgeInsets.only(top: 8.0),
//                           child: Text(
//                               classNames[index],
//                               style: TextStyle(color: Colors.grey.shade600, fontSize: 10, fontWeight: FontWeight.w600)
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                   topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                   rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                 ),
//                 gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade100, strokeWidth: 1)),
//                 borderData: FlBorderData(show: false),
//                 barGroups: List.generate(classNames.length, (index) {
//                   return _makeBarData(
//                       index,
//                       completionCounts[index].toDouble(),
//                       barColors[index % barColors.length]
//                   );
//                 }),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDataTable(Map<String, dynamic> stats) {
//     final rows = [
//       {'l': 'Thiếu cân', 'v': stats['underweight'], 'p': stats['underweightPercent'], 'c': Colors.blue.shade400},
//       {'l': 'Bình thường', 'v': stats['normal'], 'p': stats['normalPercent'], 'c': Colors.teal.shade500},
//       {'l': 'Thừa cân', 'v': stats['overweight'], 'p': stats['overweightPercent'], 'c': Colors.orange.shade400},
//       {'l': 'Béo phì', 'v': stats['obese'], 'p': stats['obesePercent'], 'c': Colors.red.shade400},
//     ];
//
//     return _buildCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('Bảng tổng hợp BMI', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
//           const SizedBox(height: 12),
//
//           Container(
//             padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//             decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
//             child: Row(
//               children: [
//                 Expanded(flex: 3, child: Text('Phân loại', style: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.bold))),
//                 Expanded(flex: 2, child: Text('Số lượng', style: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.bold))),
//                 Expanded(flex: 2, child: Text('Tỷ lệ', style: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.bold))),
//                 Expanded(flex: 1, child: Text('Mức độ', style: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.right)),
//               ],
//             ),
//           ),
//
//           ...rows.map((r) => Container(
//             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
//             decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade100))),
//             child: Row(
//               children: [
//                 Expanded(
//                     flex: 3,
//                     child: Row(
//                       children: [
//                         Container(width: 10, height: 10, decoration: BoxDecoration(color: r['c'] as Color, borderRadius: BorderRadius.circular(2))),
//                         const SizedBox(width: 8),
//                         Text('${r['l']}', style: const TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w500)),
//                       ],
//                     )
//                 ),
//                 Expanded(flex: 2, child: Text('${r['v']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87))),
//                 Expanded(flex: 2, child: Text('${(r['p'] as double).round()}%', style: TextStyle(fontSize: 13, color: Colors.grey.shade600))),
//                 Expanded(flex: 1, child: Align(alignment: Alignment.centerRight, child: Icon(Icons.circle, size: 12, color: r['c'] as Color))),
//               ],
//             ),
//           )),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return _buildCard(
//       padding: const EdgeInsets.all(40),
//       child: Center(
//         child: Column(
//           children: [
//             Icon(Icons.analytics_outlined, size: 48, color: Colors.grey.shade400),
//             const SizedBox(height: 16),
//             const Text('Chưa có dữ liệu thống kê', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
//             Text('Vui lòng chọn chiến dịch khác hoặc đợi sinh viên hoàn tất khám.', style: TextStyle(color: Colors.grey.shade500, fontSize: 13), textAlign: TextAlign.center),
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:fl_chart/fl_chart.dart';
// import '../../viewmodels/admin/reports_viewmodel.dart';
// import '../../di.dart';
// import 'widgets/report_export_dialog.dart';
//
// class ReportsPage extends StatelessWidget {
//   const ReportsPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => sl<ReportsViewModel>(),
//       child: Consumer<ReportsViewModel>(
//         builder: (context, viewModel, child) {
//           if (viewModel.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           final stats = viewModel.bmiStats;
//
//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Báo cáo & Thống kê',
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
//                 ),
//                 const SizedBox(height: 16),
//
//                 _buildActionToolbar(context, viewModel),
//                 const SizedBox(height: 16),
//
//                 if (stats == null || stats['total'] == 0)
//                   _buildEmptyState()
//                 else ...[
//                   _buildStatCardsRow(stats),
//                   const SizedBox(height: 16),
//                   _buildChartsRow(stats),
//                   const SizedBox(height: 16),
//                   _buildClassCompletionChart(viewModel.classCompletionStats),
//                   const SizedBox(height: 16),
//                   _buildDataTable(stats),
//                 ]
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   // --- WIDGETS CON ---
//
//   void _showExportDialog(BuildContext context, ReportsViewModel vm, String type) {
//     if (vm.bmiStats == null) return;
//
//     final campaignName = vm.campaigns.firstWhere((c) => c.id == vm.selectedCampaignId).name;
//
//     showDialog(
//       context: context,
//       builder: (BuildContext dialogContext) {
//         return ReportExportDialog(
//           exportType: type,
//           defaultCampaignName: campaignName,
//           onConfirm: (title, notes) {
//             if (type == 'pdf') {
//               vm.exportToPdf(context, title, notes);
//             } else {
//               vm.exportToExcel(context, title, notes);
//             }
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildCard({required Widget child, EdgeInsetsGeometry? padding}) {
//     return Container(
//       width: double.infinity,
//       padding: padding ?? const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade200),
//         boxShadow: [
//           BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2)),
//         ],
//       ),
//       child: child,
//     );
//   }
//
//   Widget _buildActionToolbar(BuildContext context, ReportsViewModel vm) {
//     return _buildCard(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 flex: 5,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Chiến dịch', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
//                     const SizedBox(height: 8),
//                     Container(
//                       height: 48,
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade200)),
//                       child: DropdownButtonHideUnderline(
//                         child: DropdownButton<String>(
//                           isExpanded: true,
//                           value: vm.selectedCampaignId,
//                           icon: Icon(Icons.keyboard_arrow_down_rounded, size: 24, color: Colors.grey.shade500),
//                           items: vm.campaigns.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87)))).toList(),
//                           onChanged: (val) => vm.setCampaignId(val!),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 flex: 4,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Lớp', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
//                     const SizedBox(height: 8),
//                     Container(
//                       height: 48,
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade200)),
//                       child: DropdownButtonHideUnderline(
//                         child: DropdownButton<String>(
//                           isExpanded: true,
//                           value: vm.selectedClass,
//                           icon: Icon(Icons.keyboard_arrow_down_rounded, size: 24, color: Colors.grey.shade500),
//                           items: [
//                             const DropdownMenuItem(value: 'all', child: Text('Tất cả lớp', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87))),
//                             ...vm.availableClasses.map((c) => DropdownMenuItem(value: c, child: Text(c, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87)))).toList(),
//                           ],
//                           onChanged: (val) => vm.setSelectedClass(val!),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(
//                 flex: 4,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade600, foregroundColor: Colors.white, elevation: 0, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
//                   onPressed: () => vm.refreshReport(context),
//                   child: const Text('Tạo báo cáo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 flex: 3,
//                 child: OutlinedButton.icon(
//                   style: OutlinedButton.styleFrom(foregroundColor: Colors.black87, backgroundColor: Colors.white, side: BorderSide(color: Colors.grey.shade300), padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
//                   onPressed: () => _showExportDialog(context, vm, 'pdf'),
//                   icon: const Icon(Icons.picture_as_pdf_rounded, size: 16, color: Colors.redAccent),
//                   label: const Text('Xuất PDF', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 flex: 3,
//                 child: OutlinedButton.icon(
//                   style: OutlinedButton.styleFrom(foregroundColor: Colors.green.shade700, backgroundColor: Colors.green.shade50, side: BorderSide(color: Colors.green.shade200), padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
//                   onPressed: () => _showExportDialog(context, vm, 'excel'),
//                   icon: const Icon(Icons.table_view_rounded, size: 16),
//                   label: const Text('Excel', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatCardsRow(Map<String, dynamic> stats) {
//     return GridView.count(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       crossAxisCount: 2,
//       childAspectRatio: 1.6,
//       mainAxisSpacing: 12,
//       crossAxisSpacing: 12,
//       children: [
//         _buildSingleStatCard('👥', 'Hoàn thành (cả 4 trạm)', '${stats['total']}', Colors.blue.shade600, 'Tất cả sinh viên'),
//         _buildSingleStatCard('⚖️', 'BMI Bình thường', '${stats['normal']}', Colors.teal.shade500, 'Sức khỏe tốt'),
//         _buildSingleStatCard('🫀', 'Huyết áp cao', '0', Colors.red.shade500, 'Cần theo dõi'),
//         _buildSingleStatCard('👁️', 'Thị lực kém', '0', Colors.orange.shade500, 'Cần khám lại'),
//       ],
//     );
//   }
//
//   Widget _buildSingleStatCard(String emoji, String label, String value, Color color, String sub) {
//     return _buildCard(
//       padding: const EdgeInsets.all(12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Row(
//             children: [
//               Text(emoji, style: const TextStyle(fontSize: 18)),
//               const SizedBox(width: 8),
//               Expanded(child: Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis)),
//             ],
//           ),
//           const Spacer(),
//           Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
//           Text(sub, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildChartsRow(Map<String, dynamic> stats) {
//     return Column(
//       children: [
//         _buildCard(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text('Phân bố BMI', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
//               Text('${stats['total']} sinh viên hoàn thành', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
//               const SizedBox(height: 32),
//               SizedBox(
//                 height: 200,
//                 child: BarChart(
//                   BarChartData(
//                     alignment: BarChartAlignment.spaceAround,
//                     maxY: stats['total'].toDouble() * 1.3,
//                     barTouchData: BarTouchData(
//                       enabled: false,
//                       touchTooltipData: BarTouchTooltipData(
//                         tooltipBgColor: Colors.transparent, // ✨ ĐÃ SỬA: Dùng thuộc tính tương thích với phiên bản fl_chart của bạn
//                         tooltipPadding: EdgeInsets.zero,
//                         tooltipMargin: 8,
//                         getTooltipItem: (group, groupIndex, rod, rodIndex) {
//                           return BarTooltipItem(
//                             rod.toY.round().toString(),
//                             TextStyle(color: rod.color, fontWeight: FontWeight.bold, fontSize: 13),
//                           );
//                         },
//                       ),
//                     ),
//                     titlesData: FlTitlesData(
//                       show: true,
//                       bottomTitles: AxisTitles(
//                         sideTitles: SideTitles(
//                           showTitles: true,
//                           reservedSize: 36,
//                           getTitlesWidget: (double value, TitleMeta meta) {
//                             const titles = ['Thiếu cân', 'Bình thường', 'Thừa cân', 'Béo phì'];
//                             return Padding(
//                               padding: const EdgeInsets.only(top: 8.0),
//                               child: Text(titles[value.toInt()], style: TextStyle(color: Colors.grey.shade600, fontSize: 10, fontWeight: FontWeight.w600)),
//                             );
//                           },
//                         ),
//                       ),
//                       leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                       topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                       rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                     ),
//                     gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade100, strokeWidth: 1)),
//                     borderData: FlBorderData(show: false),
//                     barGroups: [
//                       _makeBarData(0, stats['underweight'].toDouble(), Colors.blue.shade400),
//                       _makeBarData(1, stats['normal'].toDouble(), Colors.teal.shade500),
//                       _makeBarData(2, stats['overweight'].toDouble(), Colors.orange.shade400),
//                       _makeBarData(3, stats['obese'].toDouble(), Colors.red.shade400),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 16),
//         _buildCard(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text('Biểu đồ tròn BMI', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
//               Text('Tổng quan phân bố', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
//               const SizedBox(height: 24),
//               SizedBox(
//                 height: 160,
//                 child: PieChart(
//                   PieChartData(
//                     sectionsSpace: 2,
//                     centerSpaceRadius: 40,
//                     sections: [
//                       if (stats['underweight'] > 0) PieChartSectionData(value: stats['underweight'].toDouble(), color: Colors.blue.shade400, title: '${stats['underweightPercent'].round()}%', radius: 40, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
//                       if (stats['normal'] > 0) PieChartSectionData(value: stats['normal'].toDouble(), color: Colors.teal.shade500, title: '${stats['normalPercent'].round()}%', radius: 45, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
//                       if (stats['overweight'] > 0) PieChartSectionData(value: stats['overweight'].toDouble(), color: Colors.orange.shade400, title: '${stats['overweightPercent'].round()}%', radius: 40, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
//                       if (stats['obese'] > 0) PieChartSectionData(value: stats['obese'].toDouble(), color: Colors.red.shade400, title: '${stats['obesePercent'].round()}%', radius: 40, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   BarChartGroupData _makeBarData(int x, double y, Color color) {
//     return BarChartGroupData(
//       x: x,
//       barRods: [
//         BarChartRodData(
//           toY: y,
//           color: color,
//           width: 22,
//           borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
//         ),
//       ],
//       showingTooltipIndicators: [0],
//     );
//   }
//
//   Widget _buildClassCompletionChart(Map<String, int> classStats) {
//     if (classStats.isEmpty) {
//       return _buildCard(
//         child: const Center(
//           child: Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Text('Chưa có sinh viên nào hoàn thành cả 4 trạm.', style: TextStyle(color: Colors.grey)),
//           ),
//         ),
//       );
//     }
//
//     final classNames = classStats.keys.toList();
//     final completionCounts = classStats.values.toList();
//
//     double maxCount = completionCounts.reduce((a, b) => a > b ? a : b).toDouble();
//     if (maxCount == 0) maxCount = 10;
//
//     final barColors = [
//       Colors.blue.shade500, Colors.purple.shade400, Colors.teal.shade500,
//       Colors.orange.shade400, Colors.pink.shade400
//     ];
//
//     return _buildCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('Hoàn thành theo lớp', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
//           Text('Sinh viên hoàn thành cả 4 trạm', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
//           const SizedBox(height: 32),
//           SizedBox(
//             height: 180,
//             child: BarChart(
//               BarChartData(
//                 alignment: BarChartAlignment.spaceAround,
//                 maxY: maxCount * 1.3,
//
//                 // ✨ HIỂN THỊ SỐ LƯỢNG TRÊN ĐỈNH CỘT
//                 barTouchData: BarTouchData(
//                   enabled: false,
//                   touchTooltipData: BarTouchTooltipData(
//                     tooltipBgColor: Colors.transparent, // ✨ ĐÃ SỬA TƯƠNG TỰ BÊN TRÊN
//                     tooltipPadding: EdgeInsets.zero,
//                     tooltipMargin: 8,
//                     getTooltipItem: (group, groupIndex, rod, rodIndex) {
//                       return BarTooltipItem(
//                         rod.toY.round().toString(),
//                         TextStyle(color: rod.color, fontWeight: FontWeight.bold, fontSize: 13),
//                       );
//                     },
//                   ),
//                 ),
//                 titlesData: FlTitlesData(
//                   show: true,
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       reservedSize: 36,
//                       getTitlesWidget: (double value, TitleMeta meta) {
//                         final index = value.toInt();
//                         if (index < 0 || index >= classNames.length) return const SizedBox.shrink();
//
//                         return Padding(
//                           padding: const EdgeInsets.only(top: 8.0),
//                           child: Text(
//                               classNames[index],
//                               style: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.w600)
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                   topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                   rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                 ),
//                 gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade100, strokeWidth: 1)),
//                 borderData: FlBorderData(show: false),
//                 barGroups: List.generate(classNames.length, (index) {
//                   return _makeBarData(
//                       index,
//                       completionCounts[index].toDouble(),
//                       barColors[index % barColors.length]
//                   );
//                 }),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDataTable(Map<String, dynamic> stats) {
//     final rows = [
//       {'l': 'Thiếu cân', 'v': stats['underweight'], 'p': stats['underweightPercent'], 'c': Colors.blue.shade400},
//       {'l': 'Bình thường', 'v': stats['normal'], 'p': stats['normalPercent'], 'c': Colors.teal.shade500},
//       {'l': 'Thừa cân', 'v': stats['overweight'], 'p': stats['overweightPercent'], 'c': Colors.orange.shade400},
//       {'l': 'Béo phì', 'v': stats['obese'], 'p': stats['obesePercent'], 'c': Colors.red.shade400},
//     ];
//
//     return _buildCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('Bảng tổng hợp BMI', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
//           const SizedBox(height: 12),
//
//           Container(
//             padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//             decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
//             child: Row(
//               children: [
//                 Expanded(flex: 3, child: Text('Phân loại', style: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.bold))),
//                 Expanded(flex: 2, child: Text('Số lượng', style: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.bold))),
//                 Expanded(flex: 2, child: Text('Tỷ lệ', style: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.bold))),
//                 Expanded(flex: 1, child: Text('Mức độ', style: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.right)),
//               ],
//             ),
//           ),
//
//           ...rows.map((r) => Container(
//             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
//             decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade100))),
//             child: Row(
//               children: [
//                 Expanded(
//                     flex: 3,
//                     child: Row(
//                       children: [
//                         Container(width: 10, height: 10, decoration: BoxDecoration(color: r['c'] as Color, borderRadius: BorderRadius.circular(2))),
//                         const SizedBox(width: 8),
//                         Text('${r['l']}', style: const TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w500)),
//                       ],
//                     )
//                 ),
//                 Expanded(flex: 2, child: Text('${r['v']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87))),
//                 Expanded(flex: 2, child: Text('${(r['p'] as double).round()}%', style: TextStyle(fontSize: 13, color: Colors.grey.shade600))),
//                 Expanded(flex: 1, child: Align(alignment: Alignment.centerRight, child: Icon(Icons.circle, size: 12, color: r['c'] as Color))),
//               ],
//             ),
//           )),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return _buildCard(
//       padding: const EdgeInsets.all(40),
//       child: Center(
//         child: Column(
//           children: [
//             Icon(Icons.analytics_outlined, size: 48, color: Colors.grey.shade400),
//             const SizedBox(height: 16),
//             const Text('Chưa có dữ liệu thống kê', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
//             Text('Vui lòng chọn chiến dịch khác hoặc đợi sinh viên hoàn tất khám.', style: TextStyle(color: Colors.grey.shade500, fontSize: 13), textAlign: TextAlign.center),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../viewmodels/admin/reports_viewmodel.dart';
import '../../di.dart';
import 'widgets/report_export_dialog.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<ReportsViewModel>(),
      child: Consumer<ReportsViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final stats = viewModel.bmiStats;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Báo cáo & Thống kê',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 16),

                _buildActionToolbar(context, viewModel),
                const SizedBox(height: 16),

                if (stats == null || stats['total'] == 0)
                  _buildEmptyState()
                else ...[
                  _buildStatCardsRow(stats),
                  const SizedBox(height: 16),
                  _buildChartsRow(stats),
                  const SizedBox(height: 16),
                  _buildClassCompletionChart(viewModel.classCompletionStats),
                  const SizedBox(height: 16),
                  _buildDataTable(stats),
                ]
              ],
            ),
          );
        },
      ),
    );
  }

  // --- WIDGETS CON ---

  void _showExportDialog(BuildContext context, ReportsViewModel vm, String type) {
    if (vm.bmiStats == null) return;

    final campaignName = vm.campaigns.firstWhere((c) => c.id == vm.selectedCampaignId).name;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return ReportExportDialog(
          exportType: type,
          defaultCampaignName: campaignName,
          onConfirm: (title, notes) {
            if (type == 'pdf') {
              vm.exportToPdf(context, title, notes);
            } else {
              vm.exportToExcel(context, title, notes);
            }
          },
        );
      },
    );
  }

  Widget _buildCard({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: child,
    );
  }

  Widget _buildActionToolbar(BuildContext context, ReportsViewModel vm) {
    return _buildCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Chiến dịch', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
                    const SizedBox(height: 8),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade200)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: vm.selectedCampaignId,
                          icon: Icon(Icons.keyboard_arrow_down_rounded, size: 24, color: Colors.grey.shade500),
                          items: vm.campaigns.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87)))).toList(),
                          onChanged: (val) => vm.setCampaignId(val!),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Lớp', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
                    const SizedBox(height: 8),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade200)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: vm.selectedClass,
                          icon: Icon(Icons.keyboard_arrow_down_rounded, size: 24, color: Colors.grey.shade500),
                          items: [
                            const DropdownMenuItem(value: 'all', child: Text('Tất cả lớp', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87))),
                            ...vm.availableClasses.map((c) => DropdownMenuItem(value: c, child: Text(c, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87)))).toList(),
                          ],
                          onChanged: (val) => vm.setSelectedClass(val!),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade600, foregroundColor: Colors.white, elevation: 0, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  onPressed: () => vm.refreshReport(context),
                  child: const Text('Tạo báo cáo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.black87, backgroundColor: Colors.white, side: BorderSide(color: Colors.grey.shade300), padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  onPressed: () => _showExportDialog(context, vm, 'pdf'),
                  icon: const Icon(Icons.picture_as_pdf_rounded, size: 16, color: Colors.redAccent),
                  label: const Text('Xuất PDF', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.green.shade700, backgroundColor: Colors.green.shade50, side: BorderSide(color: Colors.green.shade200), padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  onPressed: () => _showExportDialog(context, vm, 'excel'),
                  icon: const Icon(Icons.table_view_rounded, size: 16),
                  label: const Text('Excel', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatCardsRow(Map<String, dynamic> stats) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.35,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _buildSingleStatCard('👥', 'Hoàn thành (cả 4 trạm)', '${stats['total']}', Colors.blue.shade600, 'Tất cả sinh viên'),
        _buildSingleStatCard('⚖️', 'BMI Bình thường', '${stats['normal']}', Colors.teal.shade500, 'Sức khỏe tốt'),
        _buildSingleStatCard('🫀', 'Huyết áp cao', '0', Colors.red.shade500, 'Cần theo dõi'),
        _buildSingleStatCard('👁️', 'Thị lực kém', '0', Colors.orange.shade500, 'Cần khám lại'),
      ],
    );
  }

  Widget _buildSingleStatCard(String emoji, String label, String value, Color color, String sub) {
    return _buildCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Expanded(child: Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis)),
            ],
          ),
          const Spacer(),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          ),
          Text(sub, style: TextStyle(fontSize: 11, color: Colors.grey.shade500), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildChartsRow(Map<String, dynamic> stats) {
    return Column(
      children: [
        _buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Phân bố BMI', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
              Text('${stats['total']} sinh viên hoàn thành', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              const SizedBox(height: 32),
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: stats['total'].toDouble() * 1.3,
                    barTouchData: BarTouchData(
                      enabled: false,
                      touchTooltipData: BarTouchTooltipData(
                        tooltipBgColor: Colors.transparent,
                        tooltipPadding: EdgeInsets.zero,
                        tooltipMargin: 8,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            rod.toY.round().toString(),
                            TextStyle(color: rod.color, fontWeight: FontWeight.bold, fontSize: 13),
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 36,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            const titles = ['Thiếu cân', 'Bình thường', 'Thừa cân', 'Béo phì'];
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(titles[value.toInt()], style: TextStyle(color: Colors.grey.shade600, fontSize: 10, fontWeight: FontWeight.w600)),
                            );
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade100, strokeWidth: 1)),
                    borderData: FlBorderData(show: false),
                    barGroups: [
                      _makeBarData(0, stats['underweight'].toDouble(), Colors.blue.shade400),
                      _makeBarData(1, stats['normal'].toDouble(), Colors.teal.shade500),
                      _makeBarData(2, stats['overweight'].toDouble(), Colors.orange.shade400),
                      _makeBarData(3, stats['obese'].toDouble(), Colors.red.shade400),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Biểu đồ tròn BMI', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
              Text('Tổng quan phân bố', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              const SizedBox(height: 24),
              SizedBox(
                height: 160,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    sections: [
                      if (stats['underweight'] > 0) PieChartSectionData(value: stats['underweight'].toDouble(), color: Colors.blue.shade400, title: '${stats['underweightPercent'].round()}%', radius: 40, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                      if (stats['normal'] > 0) PieChartSectionData(value: stats['normal'].toDouble(), color: Colors.teal.shade500, title: '${stats['normalPercent'].round()}%', radius: 45, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                      if (stats['overweight'] > 0) PieChartSectionData(value: stats['overweight'].toDouble(), color: Colors.orange.shade400, title: '${stats['overweightPercent'].round()}%', radius: 40, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                      if (stats['obese'] > 0) PieChartSectionData(value: stats['obese'].toDouble(), color: Colors.red.shade400, title: '${stats['obesePercent'].round()}%', radius: 40, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  BarChartGroupData _makeBarData(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 22,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
        ),
      ],
      showingTooltipIndicators: [0],
    );
  }

  Widget _buildClassCompletionChart(Map<String, int> classStats) {
    if (classStats.isEmpty) {
      return _buildCard(
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Chưa có sinh viên nào hoàn thành cả 4 trạm.', style: TextStyle(color: Colors.grey)),
          ),
        ),
      );
    }

    final classNames = classStats.keys.toList();
    final completionCounts = classStats.values.toList();

    double maxCount = completionCounts.reduce((a, b) => a > b ? a : b).toDouble();
    if (maxCount == 0) maxCount = 10;

    final barColors = [
      Colors.blue.shade500, Colors.purple.shade400, Colors.teal.shade500,
      Colors.orange.shade400, Colors.pink.shade400
    ];

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Hoàn thành theo lớp', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
          Text('Sinh viên hoàn thành cả 4 trạm', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          const SizedBox(height: 32),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxCount * 1.3,

                barTouchData: BarTouchData(
                  enabled: false,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.transparent,
                    tooltipPadding: EdgeInsets.zero,
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        rod.toY.round().toString(),
                        TextStyle(color: rod.color, fontWeight: FontWeight.bold, fontSize: 13),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= classNames.length) return const SizedBox.shrink();

                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                              classNames[index],
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.w600)
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade100, strokeWidth: 1)),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(classNames.length, (index) {
                  return _makeBarData(
                      index,
                      completionCounts[index].toDouble(),
                      barColors[index % barColors.length]
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(Map<String, dynamic> stats) {
    final rows = [
      {'l': 'Thiếu cân', 'v': stats['underweight'], 'p': stats['underweightPercent'], 'c': Colors.blue.shade400},
      {'l': 'Bình thường', 'v': stats['normal'], 'p': stats['normalPercent'], 'c': Colors.teal.shade500},
      {'l': 'Thừa cân', 'v': stats['overweight'], 'p': stats['overweightPercent'], 'c': Colors.orange.shade400},
      {'l': 'Béo phì', 'v': stats['obese'], 'p': stats['obesePercent'], 'c': Colors.red.shade400},
    ];

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Bảng tổng hợp BMI', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
            child: Row(
              children: [
                Expanded(flex: 3, child: Text('Phân loại', style: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('Số lượng', style: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('Tỷ lệ', style: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.bold))),
                Expanded(flex: 1, child: Text('Mức độ', style: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.right)),
              ],
            ),
          ),

          ...rows.map((r) => Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade100))),
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        Container(width: 10, height: 10, decoration: BoxDecoration(color: r['c'] as Color, borderRadius: BorderRadius.circular(2))),
                        const SizedBox(width: 8),
                        // ✨ ĐÃ SỬA: Bọc Expanded cho tên phân loại để tránh tràn 0.3 pixel
                        Expanded(child: Text('${r['l']}', style: const TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis)),
                      ],
                    )
                ),
                Expanded(flex: 2, child: Text('${r['v']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87))),
                Expanded(flex: 2, child: Text('${(r['p'] as double).round()}%', style: TextStyle(fontSize: 13, color: Colors.grey.shade600))),
                Expanded(flex: 1, child: Align(alignment: Alignment.centerRight, child: Icon(Icons.circle, size: 12, color: r['c'] as Color))),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return _buildCard(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.analytics_outlined, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text('Chưa có dữ liệu thống kê', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            Text('Vui lòng chọn chiến dịch khác hoặc đợi sinh viên hoàn tất khám.', style: TextStyle(color: Colors.grey.shade500, fontSize: 13), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}