// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../viewmodels/admin/admin_overview_viewmodel.dart';
// import '../../di.dart';
// import 'widgets/bulk_email_dialog.dart';
//
// class AdminOverviewPage extends StatelessWidget {
//   const AdminOverviewPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//         create: (_) => sl<AdminOverviewViewModel>(),
//         child: Consumer<AdminOverviewViewModel>(
//             builder: (context, vm, child) {
//               if (vm.isLoading) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//
//               return SingleChildScrollView(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text('Hello!', style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500)),
//                     const Text('Admin Dashboard', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
//                     const SizedBox(height: 24),
//
//                     // 1. Thẻ tiến độ khám
//                     _buildProgressCard(context, vm),
//
//                     const SizedBox(height: 28),
//                     const Text('Các trạm khám (4)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
//                     const SizedBox(height: 12),
//
//                     // 2. Danh sách các trạm khám (Có Icon riêng biệt)
//                     if (vm.stationStats.isEmpty)
//                       const Text('Chưa có dữ liệu khám', style: TextStyle(color: Colors.grey)),
//                     ...vm.stationStats.map((stat) {
//                       final stationId = stat['station'].id;
//                       IconData icon;
//
//                       // ✨ Gán Icon chuyên biệt theo từng ID trạm
//                       switch (stationId) {
//                         case 'physical': icon = Icons.accessibility_new_rounded; break;
//                         case 'vision': icon = Icons.remove_red_eye_rounded; break;
//                         case 'blood_pressure': icon = Icons.monitor_heart_rounded; break;
//                         case 'general': default: icon = Icons.medical_services_rounded; break;
//                       }
//
//                       return _buildStationCard(
//                         stat['station'].name,
//                         '${stat['completed']} sinh viên đã khám',
//                         '${stat['percentage'].toStringAsFixed(0)}%',
//                         icon, // Truyền icon vào
//                       );
//                     }),
//
//                     const SizedBox(height: 24),
//
//                     // 3. Thông tin chiến dịch hiện tại
//                     _buildCurrentCampaignCard(vm),
//                     const SizedBox(height: 24),
//                   ],
//                 ),
//               );
//             }
//         )
//     );
//   }
//
//   // --- WIDGET THẺ TIẾN ĐỘ ---
//   Widget _buildProgressCard(BuildContext context, AdminOverviewViewModel vm) {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFF9C27B0), Color(0xFF2196F3)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [BoxShadow(color: Colors.purple.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text('Tiến độ khám hôm nay', style: TextStyle(color: Colors.white70, fontSize: 12)),
//               const SizedBox(height: 4),
//               const Text('Sắp hoàn thành!', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 16),
//
//               ElevatedButton(
//                 onPressed: () {
//                   showDialog(
//                     context: context,
//                     barrierDismissible: false,
//                     builder: (ctx) => BulkEmailDialog(students: vm.recentStudents),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.white,
//                   foregroundColor: Colors.purple.shade600,
//                   elevation: 0,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                 ),
//                 child: const Text('Gửi Email', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
//               )
//             ],
//           ),
//
//           Stack(
//             alignment: Alignment.center,
//             children: [
//               SizedBox(
//                 width: 70, height: 70,
//                 child: CircularProgressIndicator(
//                   value: vm.totalStudents == 0 ? 0 : vm.completionRate / 100,
//                   backgroundColor: Colors.white.withOpacity(0.2),
//                   valueColor: const AlwaysStoppedAnimation(Colors.white),
//                   strokeWidth: 6,
//                   strokeCap: StrokeCap.round,
//                 ),
//               ),
//               Text('${vm.completionRate}%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
//             ],
//           )
//         ],
//       ),
//     );
//   }
//
//   // --- WIDGET CÁC TRẠM KHÁM ---
//   Widget _buildStationCard(String title, String subtitle, String percent, IconData icon) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey.shade200),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 4, offset: const Offset(0, 2))],
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
//             child: Icon(icon, color: Colors.blue.shade600, size: 22), // Dùng Icon truyền vào
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
//                 const SizedBox(height: 2),
//                 Text(subtitle, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
//               ],
//             ),
//           ),
//           Text(percent, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
//         ],
//       ),
//     );
//   }
//
//   // --- WIDGET CHIẾN DỊCH HIỆN TẠI ---
//   Widget _buildCurrentCampaignCard(AdminOverviewViewModel vm) {
//     final currentCamp = vm.currentCampaign;
//
//     if (currentCamp == null) {
//       return Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(16)),
//         child: const Center(child: Text('Chưa có dữ liệu chiến dịch trong Database', style: TextStyle(color: Colors.grey))),
//       );
//     }
//
//     bool isActive = currentCamp.status.toLowerCase() == 'active' || currentCamp.status.toLowerCase() == 'ongoing';
//
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(16)),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(14),
//             decoration: BoxDecoration(color: Colors.blue.shade200.withOpacity(0.5), borderRadius: BorderRadius.circular(12)),
//             child: Icon(Icons.calendar_today_rounded, color: Colors.blue.shade700, size: 24),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text('Chiến dịch hiện tại', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
//                     if (!isActive) ...[
//                       const SizedBox(width: 6),
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                         decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(4)),
//                         child: Text(currentCamp.status.toUpperCase(), style: TextStyle(color: Colors.orange.shade800, fontSize: 10, fontWeight: FontWeight.bold)),
//                       )
//                     ]
//                   ],
//                 ),
//                 const SizedBox(height: 2),
//                 Text(currentCamp.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
//                 const SizedBox(height: 4),
//                 Row(
//                   children: [
//                     Icon(Icons.location_on, size: 14, color: Colors.grey.shade500),
//                     const SizedBox(width: 4),
//                     Expanded(child: Text(currentCamp.location, style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis)),
//                   ],
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../domain/entities/station.dart';
// import '../../viewmodels/admin/admin_overview_viewmodel.dart';
// import '../../di.dart';
// import 'widgets/bulk_email_dialog.dart';
//
// class AdminOverviewPage extends StatelessWidget {
//   const AdminOverviewPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//         create: (_) => sl<AdminOverviewViewModel>(),
//         child: Consumer<AdminOverviewViewModel>(
//             builder: (context, vm, child) {
//               if (vm.isLoading) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//
//               return SingleChildScrollView(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text('Hello!', style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500)),
//                     const Text('Admin Dashboard', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
//                     const SizedBox(height: 24),
//
//                     _buildProgressCard(context, vm),
//
//                     const SizedBox(height: 28),
//                     Row(
//                       children: [
//                         const Text('Các trạm khám', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
//                         const SizedBox(width: 8),
//                         Text('4', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade400)),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//
//                     if (vm.stationStats.isEmpty || vm.currentCampaign == null)
//                       Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.all(20),
//                         decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(16)),
//                         child: const Text('Chưa có dữ liệu trạm khám (Không có chiến dịch Active)', style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
//                       )
//                     else
//                       ...vm.stationStats.map((stat) {
//                         final Station station = stat['station'];
//                         final int completed = stat['completed'];
//                         final double percentage = stat['percentage'];
//
//                         Color stationColor;
//                         IconData stationIcon;
//                         switch (station.id) {
//                           case 'physical': stationColor = Colors.pink.shade400; stationIcon = Icons.bolt_rounded; break;
//                           case 'vision': stationColor = Colors.purple.shade500; stationIcon = Icons.verified_outlined; break;
//                           case 'blood_pressure': stationColor = Colors.orange.shade500; stationIcon = Icons.trending_up_rounded; break;
//                           case 'general': default: stationColor = Colors.blue.shade600; stationIcon = Icons.people_alt_outlined; break;
//                         }
//
//                         return _buildStationCard(title: station.name, subtitle: '$completed sinh viên', percentage: percentage, icon: stationIcon, color: stationColor);
//                       }),
//
//                     const SizedBox(height: 24),
//                     _buildCurrentCampaignCard(vm),
//                     const SizedBox(height: 24),
//                   ],
//                 ),
//               );
//             }
//         )
//     );
//   }
//
//   // ✨ HÀM XỬ LÝ LOGIC CHỮ ĐỘNG (Thêm mới)
//   String _getProgressText(double percent) {
//     if (percent == 0) {
//       return 'Chưa bắt đầu';
//     } else if (percent < 50) {
//       return 'Đang tiến hành';
//     } else if (percent < 100) {
//       return 'Sắp hoàn thành!';
//     } else {
//       return 'Đã hoàn thành!';
//     }
//   }
//
//   Widget _buildProgressCard(BuildContext context, AdminOverviewViewModel vm) {
//     // Lấy phần trăm tiến độ từ ViewModel
//     final double progressPercent = vm.totalStudents == 0 ? 0.0 : vm.completionRate.toDouble();
//
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(colors: [Color(0xFF9C27B0), Color(0xFF2196F3)], begin: Alignment.topLeft, end: Alignment.bottomRight),
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [BoxShadow(color: Colors.purple.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text('Tiến độ khám hôm nay', style: TextStyle(color: Colors.white70, fontSize: 13)),
//               const SizedBox(height: 6),
//
//               // ✨ ĐÃ SỬA: Thay thế dòng code cứng bằng hàm _getProgressText
//               Text(
//                   _getProgressText(progressPercent),
//                   style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)
//               ),
//
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   if (vm.recentStudents.isNotEmpty) {
//                     showDialog(context: context, barrierDismissible: false, builder: (ctx) => BulkEmailDialog(students: vm.recentStudents));
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.purple.shade600, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
//                 child: const Text('Gửi Email', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
//               )
//             ],
//           ),
//           Stack(
//             alignment: Alignment.center,
//             children: [
//               SizedBox(width: 75, height: 75, child: CircularProgressIndicator(value: progressPercent / 100, backgroundColor: Colors.white.withOpacity(0.2), valueColor: const AlwaysStoppedAnimation(Colors.white), strokeWidth: 6, strokeCap: StrokeCap.round)),
//               Text('${progressPercent.toInt()}%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
//             ],
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStationCard({required String title, required String subtitle, required double percentage, required IconData icon, required Color color}) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))]),
//       child: Row(
//         children: [
//           Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 24)),
//           const SizedBox(width: 16),
//           Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)), const SizedBox(height: 4), Text(subtitle, style: TextStyle(color: Colors.grey.shade500, fontSize: 13))])),
//           SizedBox(width: 50, height: 50, child: Stack(alignment: Alignment.center, children: [CircularProgressIndicator(value: 1.0, backgroundColor: Colors.transparent, valueColor: AlwaysStoppedAnimation(Colors.grey.shade100), strokeWidth: 4), CircularProgressIndicator(value: percentage / 100, backgroundColor: Colors.transparent, valueColor: AlwaysStoppedAnimation(color), strokeWidth: 4, strokeCap: StrokeCap.round), Text('${percentage.toStringAsFixed(0)}%', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87))])),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCurrentCampaignCard(AdminOverviewViewModel vm) {
//     final currentCamp = vm.currentCampaign;
//
//     if (currentCamp == null) {
//       return Container(
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
//         decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid)),
//         child: Row(
//           children: [
//             Icon(Icons.event_busy_rounded, color: Colors.grey.shade400, size: 32),
//             const SizedBox(width: 16),
//             const Expanded(
//               child: Text(
//                   'Hiện tại không có chiến dịch nào Đang diễn ra.',
//                   style: TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w500)
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//
//     return Container(
//       padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(20)),
//       child: Row(
//         children: [
//           Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)), child: Icon(Icons.calendar_today_rounded, color: Colors.blue.shade400, size: 24)),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text('Chiến dịch hiện tại', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 Text(currentCamp.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
//                 const SizedBox(height: 6),
//                 Row(children: [Icon(Icons.location_on_outlined, size: 14, color: Colors.grey.shade600), const SizedBox(width: 4), Expanded(child: Text(currentCamp.location, style: TextStyle(color: Colors.grey.shade600, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis))])
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../domain/entities/station.dart';
// import '../../viewmodels/admin/admin_overview_viewmodel.dart';
// import '../../di.dart';
// import 'widgets/bulk_email_dialog.dart';
//
// class AdminOverviewPage extends StatelessWidget {
//   const AdminOverviewPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//         create: (_) => sl<AdminOverviewViewModel>(),
//         child: Consumer<AdminOverviewViewModel>(
//             builder: (context, vm, child) {
//               if (vm.isLoading) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//
//               return SingleChildScrollView(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text('Hello!', style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500)),
//                     const Text('Admin Dashboard', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
//                     const SizedBox(height: 24),
//
//                     _buildProgressCard(context, vm),
//
//                     const SizedBox(height: 28),
//                     Row(
//                       children: [
//                         const Text('Các trạm khám', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
//                         const SizedBox(width: 8),
//                         Text('4', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade400)),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//
//                     if (vm.stationStats.isEmpty || vm.currentCampaign == null)
//                       Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.all(20),
//                         decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(16)),
//                         child: const Text('Chưa có dữ liệu trạm khám (Không có chiến dịch Active)', style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
//                       )
//                     else
//                       ...vm.stationStats.map((stat) {
//                         final Station station = stat['station'];
//                         final int completed = stat['completed'];
//                         final double percentage = stat['percentage'];
//
//                         Color stationColor;
//                         IconData stationIcon;
//                         switch (station.id) {
//                           case 'physical': stationColor = Colors.pink.shade400; stationIcon = Icons.bolt_rounded; break;
//                           case 'vision': stationColor = Colors.purple.shade500; stationIcon = Icons.verified_outlined; break;
//                           case 'blood_pressure': stationColor = Colors.orange.shade500; stationIcon = Icons.trending_up_rounded; break;
//                           case 'general': default: stationColor = Colors.blue.shade600; stationIcon = Icons.people_alt_outlined; break;
//                         }
//
//                         return _buildStationCard(title: station.name, subtitle: '$completed sinh viên', percentage: percentage, icon: stationIcon, color: stationColor);
//                       }),
//
//                     const SizedBox(height: 24),
//                     _buildCurrentCampaignCard(vm),
//                     const SizedBox(height: 24),
//                   ],
//                 ),
//               );
//             }
//         )
//     );
//   }
//
//   String _getProgressText(double percent) {
//     if (percent == 0) return 'Chưa bắt đầu';
//     else if (percent < 50) return 'Đang tiến hành';
//     else if (percent < 100) return 'Sắp hoàn thành!';
//     else return 'Đã hoàn thành!';
//   }
//
//   Widget _buildProgressCard(BuildContext context, AdminOverviewViewModel vm) {
//     final double progressPercent = vm.totalStudents == 0 ? 0.0 : vm.completionRate.toDouble();
//
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(colors: [Color(0xFF9C27B0), Color(0xFF2196F3)], begin: Alignment.topLeft, end: Alignment.bottomRight),
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [BoxShadow(color: Colors.purple.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded( // ✨ Thêm Expanded để chữ không đẩy Layout
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text('Tiến độ khám hôm nay', style: TextStyle(color: Colors.white70, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
//                 const SizedBox(height: 6),
//                 Text(
//                     _getProgressText(progressPercent),
//                     style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
//                     maxLines: 1, overflow: TextOverflow.ellipsis // ✨ Chống tràn ngang
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     if (vm.recentStudents.isNotEmpty) {
//                       showDialog(context: context, barrierDismissible: false, builder: (ctx) => BulkEmailDialog(students: vm.recentStudents));
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.purple.shade600, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
//                   child: const Text('Gửi Email', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
//                 )
//               ],
//             ),
//           ),
//           const SizedBox(width: 16),
//           Stack(
//             alignment: Alignment.center,
//             children: [
//               SizedBox(width: 75, height: 75, child: CircularProgressIndicator(value: progressPercent / 100, backgroundColor: Colors.white.withOpacity(0.2), valueColor: const AlwaysStoppedAnimation(Colors.white), strokeWidth: 6, strokeCap: StrokeCap.round)),
//               Text('${progressPercent.toInt()}%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
//             ],
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStationCard({required String title, required String subtitle, required double percentage, required IconData icon, required Color color}) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))]),
//       child: Row(
//         children: [
//           Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 24)),
//           const SizedBox(width: 16),
//           Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87), maxLines: 1, overflow: TextOverflow.ellipsis), const SizedBox(height: 4), Text(subtitle, style: TextStyle(color: Colors.grey.shade500, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis)])),
//           SizedBox(width: 50, height: 50, child: Stack(alignment: Alignment.center, children: [CircularProgressIndicator(value: 1.0, backgroundColor: Colors.transparent, valueColor: AlwaysStoppedAnimation(Colors.grey.shade100), strokeWidth: 4), CircularProgressIndicator(value: percentage / 100, backgroundColor: Colors.transparent, valueColor: AlwaysStoppedAnimation(color), strokeWidth: 4, strokeCap: StrokeCap.round), Text('${percentage.toStringAsFixed(0)}%', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87))])),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCurrentCampaignCard(AdminOverviewViewModel vm) {
//     final currentCamp = vm.currentCampaign;
//
//     if (currentCamp == null) {
//       return Container(
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
//         decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid)),
//         child: Row(
//           children: [
//             Icon(Icons.event_busy_rounded, color: Colors.grey.shade400, size: 32),
//             const SizedBox(width: 16),
//             const Expanded(
//               child: Text(
//                   'Hiện tại không có chiến dịch nào Đang diễn ra.',
//                   style: TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w500)
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//
//     return Container(
//       padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(20)),
//       child: Row(
//         children: [
//           Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)), child: Icon(Icons.calendar_today_rounded, color: Colors.blue.shade400, size: 24)),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text('Chiến dịch hiện tại', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 Text(currentCamp.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87), maxLines: 1, overflow: TextOverflow.ellipsis), // ✨ Chống tràn ngang tên chiến dịch
//                 const SizedBox(height: 6),
//                 Row(children: [Icon(Icons.location_on_outlined, size: 14, color: Colors.grey.shade600), const SizedBox(width: 4), Expanded(child: Text(currentCamp.location, style: TextStyle(color: Colors.grey.shade600, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis))])
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/station.dart';
import '../../viewmodels/admin/admin_overview_viewmodel.dart';
import '../../di.dart';
import 'widgets/bulk_email_dialog.dart';

class AdminOverviewPage extends StatefulWidget {
  const AdminOverviewPage({super.key});

  @override
  State<AdminOverviewPage> createState() => _AdminOverviewPageState();
}

class _AdminOverviewPageState extends State<AdminOverviewPage> {
  late AdminOverviewViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = sl<AdminOverviewViewModel>();

    // ✨ GỌI HÀM LOADDATA: Ép ViewModel tải lại dữ liệu mới nhất từ Database mỗi khi mở tab này
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _vm.loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: _vm,
        child: Consumer<AdminOverviewViewModel>(
            builder: (context, vm, child) {
              if (vm.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Hello!', style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500)),
                    const Text('Admin Dashboard', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const SizedBox(height: 24),

                    _buildProgressCard(context, vm),

                    const SizedBox(height: 28),
                    Row(
                      children: [
                        const Text('Các trạm khám', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                        const SizedBox(width: 8),
                        Text('${vm.stationStats.length}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade400)),
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (vm.stationStats.isEmpty || vm.currentCampaign == null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(16)),
                        child: const Text('Chưa có dữ liệu trạm khám (Không có chiến dịch Active)', style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
                      )
                    else
                      ...vm.stationStats.map((stat) {
                        final Station station = stat['station'];
                        final int completed = stat['completed'];
                        final double percentage = stat['percentage'];

                        Color stationColor;
                        IconData stationIcon;
                        switch (station.id) {
                          case 'physical': stationColor = Colors.pink.shade400; stationIcon = Icons.bolt_rounded; break;
                          case 'vision': stationColor = Colors.purple.shade500; stationIcon = Icons.verified_outlined; break;
                          case 'blood_pressure': stationColor = Colors.orange.shade500; stationIcon = Icons.trending_up_rounded; break;
                          case 'general': default: stationColor = Colors.blue.shade600; stationIcon = Icons.people_alt_outlined; break;
                        }

                        return _buildStationCard(
                            title: station.name,
                            subtitle: '$completed/${vm.totalStudents} sinh viên đã qua trạm này',
                            percentage: percentage,
                            icon: stationIcon,
                            color: stationColor
                        );
                      }),

                    const SizedBox(height: 24),
                    _buildCurrentCampaignCard(vm),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            }
        )
    );
  }

  String _getProgressText(double percent) {
    if (percent == 0) return 'Chưa bắt đầu';
    else if (percent < 50) return 'Đang tiến hành';
    else if (percent < 100) return 'Sắp hoàn thành!';
    else return 'Đã hoàn thành!';
  }

  Widget _buildProgressCard(BuildContext context, AdminOverviewViewModel vm) {
    final double progressPercent = vm.totalStudents == 0 ? 0.0 : vm.completionRate.toDouble();

    // ✨ ĐỒNG BỘ 100% VỚI TRẠNG THÁI BÊN TRANG SINH VIÊN:
    // Dựa trực tiếp vào status của student để lấy số lượng đang khám và hoàn thành
    int fullyCompleted = vm.completedStudents;
    int inProgress = vm.recentStudents.where((s) => s.status == 'in_progress').length;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF9C27B0), Color(0xFF2196F3)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.purple.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tiến độ (${vm.totalStudents} sinh viên)', style: const TextStyle(color: Colors.white70, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Text(
                    _getProgressText(progressPercent),
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    maxLines: 1, overflow: TextOverflow.ellipsis
                ),
                const SizedBox(height: 12),

                // Hiển thị chi tiết số lượng Xong và Đang khám
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.how_to_reg_rounded, color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text('$fullyCompleted xong', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 12),
                      const Icon(Icons.schedule_rounded, color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text('$inProgress đang khám', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (vm.recentStudents.isNotEmpty) {
                      showDialog(context: context, barrierDismissible: false, builder: (ctx) => BulkEmailDialog(students: vm.recentStudents));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Chưa có sinh viên nào trong chiến dịch này!'), backgroundColor: Colors.orange));
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.purple.shade600, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                  child: const Text('Gửi Email', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                )
              ],
            ),
          ),
          const SizedBox(width: 16),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(width: 75, height: 75, child: CircularProgressIndicator(value: progressPercent / 100, backgroundColor: Colors.white.withOpacity(0.2), valueColor: const AlwaysStoppedAnimation(Colors.white), strokeWidth: 6, strokeCap: StrokeCap.round)),
              Text('${progressPercent.toInt()}%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStationCard({required String title, required String subtitle, required double percentage, required IconData icon, required Color color}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 24)),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87), maxLines: 1, overflow: TextOverflow.ellipsis), const SizedBox(height: 4), Text(subtitle, style: TextStyle(color: Colors.grey.shade500, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis)])),
          SizedBox(width: 50, height: 50, child: Stack(alignment: Alignment.center, children: [CircularProgressIndicator(value: 1.0, backgroundColor: Colors.transparent, valueColor: AlwaysStoppedAnimation(Colors.grey.shade100), strokeWidth: 4), CircularProgressIndicator(value: percentage / 100, backgroundColor: Colors.transparent, valueColor: AlwaysStoppedAnimation(color), strokeWidth: 4, strokeCap: StrokeCap.round), Text('${percentage.toStringAsFixed(0)}%', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87))])),
        ],
      ),
    );
  }

  Widget _buildCurrentCampaignCard(AdminOverviewViewModel vm) {
    final currentCamp = vm.currentCampaign;

    if (currentCamp == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid)),
        child: Row(
          children: [
            Icon(Icons.event_busy_rounded, color: Colors.grey.shade400, size: 32),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                  'Hiện tại không có chiến dịch nào Đang diễn ra.',
                  style: TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w500)
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)), child: Icon(Icons.calendar_today_rounded, color: Colors.blue.shade400, size: 24)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Chiến dịch hiện tại', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(currentCamp.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Row(children: [Icon(Icons.location_on_outlined, size: 14, color: Colors.grey.shade600), const SizedBox(width: 4), Expanded(child: Text(currentCamp.location, style: TextStyle(color: Colors.grey.shade600, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis))])
              ],
            ),
          )
        ],
      ),
    );
  }
}


