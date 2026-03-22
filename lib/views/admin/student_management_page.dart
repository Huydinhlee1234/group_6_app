// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:uuid/uuid.dart';
// import '../../domain/entities/student.dart';
// import '../../viewmodels/admin/student_management_viewmodel.dart';
// import '../../di.dart';
// import 'widgets/student_form.dart';
// import 'widgets/import_student_dialog.dart';
// import 'widgets/delete_student_dialog.dart';
// import 'widgets/qr_code_dialog.dart';
// import 'widgets/student_detail_dialog.dart';
//
// class StudentManagementPage extends StatelessWidget {
//   const StudentManagementPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => sl<StudentManagementViewModel>(),
//       child: Consumer<StudentManagementViewModel>(
//         builder: (context, vm, child) {
//           if (vm.isLoading && vm.filteredStudents.isEmpty) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildProgressCard(context, vm),
//                 const SizedBox(height: 16),
//                 _buildFilters(vm),
//                 const SizedBox(height: 16),
//                 _buildStatsRow(vm),
//                 const SizedBox(height: 24),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     const Text('Danh sách', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
//                     const SizedBox(width: 8),
//                     Text('${vm.filteredStudents.length}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey.shade500)),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 ...vm.filteredStudents.map((s) => _buildStudentCard(context, s, vm)),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildFilters(StudentManagementViewModel vm) {
//     return Container(
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
//       child: Column(
//         children: [
//           TextField(
//             onChanged: vm.setSearchTerm,
//             decoration: InputDecoration(hintText: 'Tìm theo tên hoặc MSSV...', hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14), prefixIcon: Icon(Icons.search_rounded, color: Colors.grey.shade400), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
//           ),
//           Divider(height: 1, color: Colors.grey.shade100, indent: 16, endIndent: 16),
//           Row(
//             children: [
//               Expanded(
//                 flex: 5,
//                 child: DropdownButtonHideUnderline(
//                   child: DropdownButton<String>(
//                     isExpanded: true,
//                     value: vm.tempCampaignFilter,
//                     icon: Padding(padding: const EdgeInsets.only(right: 16.0), child: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey.shade400)),
//                     items: [
//                       const DropdownMenuItem(value: 'all', child: Padding(padding: EdgeInsets.only(left: 16), child: Text('Tất cả chiến dịch', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)))),
//                       ...vm.campaigns.map((c) => DropdownMenuItem(value: c.id, child: Padding(padding: const EdgeInsets.only(left: 16), child: Text(c.name, style: const TextStyle(fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis))))
//                     ],
//                     onChanged: (val) => vm.setTempCampaignFilter(val!),
//                   ),
//                 ),
//               ),
//               Container(width: 1, height: 48, color: Colors.grey.shade200),
//               Expanded(
//                 flex: 4,
//                 child: DropdownButtonHideUnderline(
//                   child: DropdownButton<String>(
//                     isExpanded: true,
//                     value: vm.tempClassFilter,
//                     icon: Padding(padding: const EdgeInsets.only(right: 16.0), child: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey.shade400)),
//                     items: [
//                       const DropdownMenuItem(value: 'all', child: Padding(padding: EdgeInsets.only(left: 16), child: Text('Tất cả lớp', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)))),
//                       ...vm.availableClasses.map((c) => DropdownMenuItem(value: c, child: Padding(padding: const EdgeInsets.only(left: 16), child: Text(c, style: const TextStyle(fontSize: 14)))))
//                     ],
//                     onChanged: (val) => vm.setTempClassFilter(val!),
//                   ),
//                 ),
//               ),
//               Container(width: 1, height: 48, color: Colors.grey.shade200),
//               InkWell(
//                 onTap: () => vm.applyFilters(),
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   child: Row(
//                     children: [
//                       Icon(Icons.filter_list_rounded, color: Colors.blue.shade600, size: 20),
//                       const SizedBox(width: 4),
//                       Text('Lọc', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade700)),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildProgressCard(BuildContext context, StudentManagementViewModel vm) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF00C6FF), Color(0xFF0072FF)]), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))]),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text('Tổng số sinh viên', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
//                 Text('${vm.totalStudents}', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white, height: 1.2)),
//                 const SizedBox(height: 12),
//                 Wrap(
//                   spacing: 8, runSpacing: 8,
//                   children: [
//                     OutlinedButton.icon(
//                       onPressed: () {
//                         showDialog(context: context, builder: (_) => ImportStudentDialog(existingStudents: vm.filteredStudents, onImport: (listData) async {
//                           int successCount = 0;
//
//                           // Lấy ID chiến dịch đang lọc để gán cho sinh viên import, nếu chọn 'all' thì lấy chiến dịch đầu tiên
//                           String targetCampaignId = vm.tempCampaignFilter != 'all'
//                               ? vm.tempCampaignFilter
//                               : (vm.campaigns.isNotEmpty ? vm.campaigns.first.id : '');
//
//                           for (var data in listData) {
//                             final isSuccess = await vm.createStudent(Student(
//                                 id: const Uuid().v4(),
//                                 campaignId: targetCampaignId, // ✨ Đã thêm campaignId
//                                 studentCode: data['studentCode'],
//                                 name: data['name'],
//                                 className: data['className'],
//                                 status: 'not_started'
//                             ));
//                             if (isSuccess) successCount++;
//                           }
//                           if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Import thành công $successCount sinh viên!'), backgroundColor: Colors.green));
//                         }));
//                       },
//                       icon: const Icon(Icons.upload_rounded, size: 16), label: const Text('Import'), style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: BorderSide(color: Colors.white.withOpacity(0.5)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
//                     ),
//                     ElevatedButton.icon(
//                       onPressed: () {
//                         showDialog(
//                             context: context,
//                             builder: (_) => StudentForm(
//                                 campaigns: vm.campaigns,
//                                 initialCampaignId: vm.tempCampaignFilter,
//                                 onSave: (data) async {
//                                   final newStudent = Student(
//                                       id: const Uuid().v4(),
//                                       campaignId: data['campaignId'], // ✨ Đã thêm campaignId từ form
//                                       studentCode: data['studentCode'],
//                                       name: data['name'],
//                                       className: data['className'],
//                                       status: 'not_started'
//                                   );
//                                   final success = await vm.createStudent(newStudent);
//                                   if (context.mounted) {
//                                     if (success) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thêm thành công!'), backgroundColor: Colors.green)); }
//                                     else { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vm.error), backgroundColor: Colors.red)); }
//                                   }
//                                 }
//                             )
//                         );
//                       },
//                       icon: const Icon(Icons.add_rounded, size: 16), label: const Text('Thêm'), style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.teal.shade600, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//           const SizedBox(width: 16),
//           Stack(alignment: Alignment.center, children: [SizedBox(width: 80, height: 80, child: CircularProgressIndicator(value: vm.totalStudents == 0 ? 0 : vm.completedStudents / vm.totalStudents, color: Colors.white, backgroundColor: Colors.white.withOpacity(0.2), strokeWidth: 8, strokeCap: StrokeCap.round)), Text('${vm.totalStudents == 0 ? 0 : ((vm.completedStudents / vm.totalStudents) * 100).round()}%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))])
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatsRow(StudentManagementViewModel vm) {
//     return Row(children: [_buildStatBox('Hoàn thành', vm.completedStudents, const Color(0xFFE8F8F5), Colors.green.shade600, Icons.how_to_reg_rounded), const SizedBox(width: 12), _buildStatBox('Đang khám', vm.inProgressStudents, const Color(0xFFFFF9E6), Colors.orange.shade600, Icons.schedule_rounded), const SizedBox(width: 12), _buildStatBox('Chưa khám', vm.notStartedStudents, const Color(0xFFF8F9FA), Colors.grey.shade600, Icons.access_time_rounded)]);
//   }
//
//   Widget _buildStatBox(String label, int count, Color bgColor, Color fgColor, IconData icon) {
//     return Expanded(child: Container(padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8), decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(16)), child: Column(children: [Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: fgColor.withOpacity(0.3))), child: Icon(icon, color: fgColor, size: 20)), const SizedBox(height: 12), Text('$count', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: fgColor)), const SizedBox(height: 4), Text(label, style: TextStyle(fontSize: 11, color: fgColor, fontWeight: FontWeight.w500), textAlign: TextAlign.center)])));
//   }
//
//   Widget _buildStudentCard(BuildContext context, Student student, StudentManagementViewModel vm) {
//     final completedStations = vm.getCompletedStationsCount(student.id);
//     Color statusBgColor, statusFgColor; String statusText;
//     if (student.status == 'completed') { statusBgColor = const Color(0xFFE8F8F5); statusFgColor = Colors.green.shade700; statusText = 'Hoàn thành'; }
//     else if (student.status == 'in_progress') { statusBgColor = const Color(0xFFFFF9E6); statusFgColor = Colors.orange.shade700; statusText = 'Đang khám'; }
//     else { statusBgColor = Colors.grey.shade100; statusFgColor = Colors.grey.shade700; statusText = 'Chưa khám'; }
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))]),
//       child: Column(
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CircleAvatar(radius: 24, backgroundColor: Colors.purple.shade400, child: Text(student.name[0], style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
//               const SizedBox(width: 12),
//               Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)), const SizedBox(height: 4), Text('${student.studentCode} • 🎓 ${student.className}', style: TextStyle(color: Colors.grey.shade500, fontSize: 12))])),
//               Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: statusBgColor, borderRadius: BorderRadius.circular(12)), child: Text(statusText, style: TextStyle(color: statusFgColor, fontSize: 11, fontWeight: FontWeight.bold)))
//             ],
//           ),
//           const SizedBox(height: 16),
//           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Tiến độ', style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500)), Text('$completedStations/4', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.purple, fontSize: 12))]),
//           const SizedBox(height: 6),
//           LinearProgressIndicator(value: completedStations / 4, backgroundColor: Colors.grey.shade200, valueColor: AlwaysStoppedAnimation(Colors.purple.shade400), minHeight: 6, borderRadius: BorderRadius.circular(3)),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(
//                   child: ElevatedButton.icon(
//                       style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade50, foregroundColor: Colors.blue.shade700, elevation: 0, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
//                       onPressed: () {
//                         // ✨ Đã lấy Tên Chiến Dịch truyền vào Dialog
//                         String campaignName = 'Không xác định';
//                         try {
//                           campaignName = vm.campaigns.firstWhere((c) => c.id == student.campaignId).name;
//                         } catch (_) {}
//
//                         showStudentDetailDialog(context, student, completedStations, campaignName);
//                       },
//                       icon: const Icon(Icons.visibility_rounded, size: 18),
//                       label: const Text('Chi tiết', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))
//                   )
//               ),
//               const SizedBox(width: 8),
//               _buildActionButton(Icons.qr_code_rounded, Colors.purple.shade50, Colors.purple.shade400, () => showQRCodeDialog(context, student, campaignName: 'Khám sức khỏe')),
//               const SizedBox(width: 8),
//               _buildActionButton(Icons.edit_rounded, Colors.grey.shade100, Colors.grey.shade700, () {
//                 showDialog(
//                     context: context,
//                     builder: (_) => StudentForm(
//                         student: student,
//                         campaigns: vm.campaigns,
//                         initialCampaignId: vm.tempCampaignFilter,
//                         onSave: (data) async {
//                           final success = await vm.updateStudent(Student(
//                               id: student.id,
//                               campaignId: data['campaignId'], // ✨ Đã thêm campaignId
//                               studentCode: data['studentCode'],
//                               name: data['name'],
//                               className: data['className'],
//                               status: student.status
//                           ));
//                           if (context.mounted && !success) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vm.error), backgroundColor: Colors.red));
//                         }
//                     )
//                 );
//               }),
//               const SizedBox(width: 8),
//               _buildActionButton(Icons.delete_outline_rounded, Colors.red.shade50, Colors.red.shade400, () => showDeleteStudentDialog(context, student, () async { final success = await vm.deleteStudent(student.id); if (context.mounted && !success) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vm.error), backgroundColor: Colors.red)); })),
//             ],
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget _buildActionButton(IconData icon, Color bgColor, Color iconColor, VoidCallback onTap) { return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(10), child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: iconColor, size: 20))); }
// }
//

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:uuid/uuid.dart';
// import '../../domain/entities/student.dart';
// import '../../viewmodels/admin/student_management_viewmodel.dart';
// import '../../di.dart';
// import 'widgets/student_form.dart';
// import 'widgets/import_student_dialog.dart';
// import 'widgets/delete_student_dialog.dart';
// import 'widgets/qr_code_dialog.dart';
// import 'widgets/student_detail_dialog.dart';
//
// class StudentManagementPage extends StatelessWidget {
//   const StudentManagementPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => sl<StudentManagementViewModel>(),
//       child: Consumer<StudentManagementViewModel>(
//         builder: (context, vm, child) {
//           if (vm.isLoading && vm.filteredStudents.isEmpty) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildProgressCard(context, vm),
//                 const SizedBox(height: 16),
//                 _buildFilters(vm),
//                 const SizedBox(height: 16),
//                 _buildStatsRow(vm),
//                 const SizedBox(height: 24),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     const Text(
//                       'Danh sách',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       '${vm.filteredStudents.length}',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.grey.shade500,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 ...vm.filteredStudents.map(
//                       (s) => _buildStudentCard(context, s, vm),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildFilters(StudentManagementViewModel vm) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         children: [
//           TextField(
//             onChanged: vm.setSearchTerm,
//             decoration: InputDecoration(
//               hintText: 'Tìm theo tên, MSSV, hoặc Email...',
//               hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
//               prefixIcon: Icon(
//                 Icons.search_rounded,
//                 color: Colors.grey.shade400,
//               ),
//               border: InputBorder.none,
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 14,
//               ),
//             ),
//           ),
//           Divider(
//             height: 1,
//             color: Colors.grey.shade100,
//             indent: 16,
//             endIndent: 16,
//           ),
//           Row(
//             children: [
//               Expanded(
//                 flex: 5,
//                 child: DropdownButtonHideUnderline(
//                   child: DropdownButton<String>(
//                     isExpanded: true,
//                     value: vm.tempCampaignFilter,
//                     icon: Padding(
//                       padding: const EdgeInsets.only(right: 16.0),
//                       child: Icon(
//                         Icons.keyboard_arrow_down_rounded,
//                         color: Colors.grey.shade400,
//                       ),
//                     ),
//                     items: [
//                       const DropdownMenuItem(
//                         value: 'all',
//                         child: Padding(
//                           padding: EdgeInsets.only(left: 16),
//                           child: Text(
//                             'Tất cả chiến dịch',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ),
//                       ...vm.campaigns.map(
//                             (c) => DropdownMenuItem(
//                           value: c.id,
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 16),
//                             child: Text(
//                               c.name,
//                               style: const TextStyle(fontSize: 14),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                     onChanged: (val) => vm.setTempCampaignFilter(val!),
//                   ),
//                 ),
//               ),
//               Container(width: 1, height: 48, color: Colors.grey.shade200),
//               Expanded(
//                 flex: 4,
//                 child: DropdownButtonHideUnderline(
//                   child: DropdownButton<String>(
//                     isExpanded: true,
//                     value: vm.tempClassFilter,
//                     icon: Padding(
//                       padding: const EdgeInsets.only(right: 16.0),
//                       child: Icon(
//                         Icons.keyboard_arrow_down_rounded,
//                         color: Colors.grey.shade400,
//                       ),
//                     ),
//                     items: [
//                       const DropdownMenuItem(
//                         value: 'all',
//                         child: Padding(
//                           padding: EdgeInsets.only(left: 16),
//                           child: Text(
//                             'Tất cả lớp',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ),
//                       ...vm.availableClasses.map(
//                             (c) => DropdownMenuItem(
//                           value: c,
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 16),
//                             child: Text(
//                               c,
//                               style: const TextStyle(fontSize: 14),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                     onChanged: (val) => vm.setTempClassFilter(val!),
//                   ),
//                 ),
//               ),
//               Container(width: 1, height: 48, color: Colors.grey.shade200),
//               InkWell(
//                 onTap: () => vm.applyFilters(),
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 12,
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.filter_list_rounded,
//                         color: Colors.blue.shade600,
//                         size: 20,
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         'Lọc',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.blue.shade700,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildProgressCard(
//       BuildContext context,
//       StudentManagementViewModel vm,
//       ) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
//         ),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.blue.withOpacity(0.3),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Tổng số sinh viên',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 13,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 Text(
//                   '${vm.totalStudents}',
//                   style: const TextStyle(
//                     fontSize: 36,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                     height: 1.2,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Wrap(
//                   spacing: 8,
//                   runSpacing: 8,
//                   children: [
//                     OutlinedButton.icon(
//                       onPressed: () {
//                         // Xác định tên chiến dịch đang hiển thị
//                         String targetCampaignId = vm.tempCampaignFilter != 'all'
//                             ? vm.tempCampaignFilter
//                             : (vm.campaigns.isNotEmpty
//                             ? vm.campaigns.first.id
//                             : '');
//
//                         String campName = 'Tất cả chiến dịch';
//                         try {
//                           campName = vm.campaigns
//                               .firstWhere((c) => c.id == targetCampaignId)
//                               .name;
//                         } catch (_) {}
//
//                         showDialog(
//                           context: context,
//                           builder: (_) => ImportStudentDialog(
//                             existingStudents: vm.filteredStudents,
//                             campaigns: vm.campaigns,
//                             initialCampaignId: vm.tempCampaignFilter,
//                             onImport: (targetCampaignId, listData) async {
//                               Navigator.pop(context);
//                               final success = await vm.importStudents(targetCampaignId, listData);
//                               if (context.mounted) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Text(
//                                       success ? 'Import thành công!' : vm.error,
//                                     ),
//                                     backgroundColor: success ? Colors.green : Colors.red,
//                                   ),
//                                 );
//                               }
//                             },
//                           ),
//                         );
//                       },
//                       icon: const Icon(Icons.upload_rounded, size: 16),
//                       label: const Text('Import'),
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: Colors.white,
//                         side: BorderSide(color: Colors.white.withOpacity(0.5)),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 8,
//                         ),
//                       ),
//                     ),
//                     ElevatedButton.icon(
//                       onPressed: () {
//                         showDialog(
//                           context: context,
//                           builder: (_) => StudentForm(
//                             campaigns: vm.campaigns,
//                             existingStudents: vm.allStudents,
//                             initialCampaignId: vm.tempCampaignFilter,
//                             onSave: (data) async {
//                               // ✨ ĐÃ FIX: Bổ sung trường email
//                               final newStudent = Student(
//                                 id: const Uuid().v4(),
//                                 campaignId: data['campaignId'],
//                                 studentCode: data['studentCode'],
//                                 name: data['name'],
//                                 className: data['className'],
//                                 email: data['email'] ?? '',
//                                 status: 'not_started',
//                               );
//                               final success = await vm.createStudent(
//                                 newStudent,
//                               );
//                               if (context.mounted) {
//                                 if (success) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                       content: Text('Thêm thành công!'),
//                                       backgroundColor: Colors.green,
//                                     ),
//                                   );
//                                 } else {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       content: Text(vm.error),
//                                       backgroundColor: Colors.red,
//                                     ),
//                                   );
//                                 }
//                               }
//                             },
//                           ),
//                         );
//                       },
//                       icon: const Icon(Icons.add_rounded, size: 16),
//                       label: const Text('Thêm'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         foregroundColor: Colors.teal.shade600,
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 8,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 16),
//           Stack(
//             alignment: Alignment.center,
//             children: [
//               SizedBox(
//                 width: 80,
//                 height: 80,
//                 child: CircularProgressIndicator(
//                   value: vm.totalStudents == 0
//                       ? 0
//                       : vm.completedStudents / vm.totalStudents,
//                   color: Colors.white,
//                   backgroundColor: Colors.white.withOpacity(0.2),
//                   strokeWidth: 8,
//                   strokeCap: StrokeCap.round,
//                 ),
//               ),
//               Text(
//                 '${vm.totalStudents == 0 ? 0 : ((vm.completedStudents / vm.totalStudents) * 100).round()}%',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatsRow(StudentManagementViewModel vm) {
//     return Row(
//       children: [
//         _buildStatBox(
//           'Hoàn thành',
//           vm.completedStudents,
//           const Color(0xFFE8F8F5),
//           Colors.green.shade600,
//           Icons.how_to_reg_rounded,
//         ),
//         const SizedBox(width: 12),
//         _buildStatBox(
//           'Đang khám',
//           vm.inProgressStudents,
//           const Color(0xFFFFF9E6),
//           Colors.orange.shade600,
//           Icons.schedule_rounded,
//         ),
//         const SizedBox(width: 12),
//         _buildStatBox(
//           'Chưa khám',
//           vm.notStartedStudents,
//           const Color(0xFFF8F9FA),
//           Colors.grey.shade600,
//           Icons.access_time_rounded,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStatBox(
//       String label,
//       int count,
//       Color bgColor,
//       Color fgColor,
//       IconData icon,
//       ) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
//         decoration: BoxDecoration(
//           color: bgColor,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(6),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(color: fgColor.withOpacity(0.3)),
//               ),
//               child: Icon(icon, color: fgColor, size: 20),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               '$count',
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: fgColor,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 11,
//                 color: fgColor,
//                 fontWeight: FontWeight.w500,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStudentCard(
//       BuildContext context,
//       Student student,
//       StudentManagementViewModel vm,
//       ) {
//     final completedStations = vm.getCompletedStationsCount(student.id);
//     Color statusBgColor, statusFgColor;
//     String statusText;
//     if (student.status == 'completed') {
//       statusBgColor = const Color(0xFFE8F8F5);
//       statusFgColor = Colors.green.shade700;
//       statusText = 'Hoàn thành';
//     } else if (student.status == 'in_progress') {
//       statusBgColor = const Color(0xFFFFF9E6);
//       statusFgColor = Colors.orange.shade700;
//       statusText = 'Đang khám';
//     } else {
//       statusBgColor = Colors.grey.shade100;
//       statusFgColor = Colors.grey.shade700;
//       statusText = 'Chưa khám';
//     }
//
//     String currentCampaignName = 'Không xác định';
//     try {
//       currentCampaignName = vm.campaigns
//           .firstWhere((c) => c.id == student.campaignId)
//           .name;
//     } catch (_) {}
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey.shade200),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.02),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CircleAvatar(
//                 radius: 24,
//                 backgroundColor: Colors.purple.shade400,
//                 child: Text(
//                   student.name[0],
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       student.name,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                         color: Colors.black87,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       '${student.studentCode} • 🎓 ${student.className}',
//                       style: TextStyle(
//                         color: Colors.grey.shade500,
//                         fontSize: 12,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     // ✨ ĐÃ FIX: Thêm hiển thị Email cho thẻ sinh viên
//                     Text(
//                       '✉️ ${student.email}',
//                       style: TextStyle(
//                         color: Colors.grey.shade400,
//                         fontSize: 11,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 4,
//                 ),
//                 decoration: BoxDecoration(
//                   color: statusBgColor,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   statusText,
//                   style: TextStyle(
//                     color: statusFgColor,
//                     fontSize: 11,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Tiến độ',
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey.shade600,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               Text(
//                 '$completedStations/4',
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.purple,
//                   fontSize: 12,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 6),
//           LinearProgressIndicator(
//             value: completedStations / 4,
//             backgroundColor: Colors.grey.shade200,
//             valueColor: AlwaysStoppedAnimation(Colors.purple.shade400),
//             minHeight: 6,
//             borderRadius: BorderRadius.circular(3),
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(
//                 child: ElevatedButton.icon(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue.shade50,
//                     foregroundColor: Colors.blue.shade700,
//                     elevation: 0,
//                     padding: const EdgeInsets.symmetric(vertical: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   onPressed: () {
//                     showStudentDetailDialog(
//                       context,
//                       student,
//                       completedStations,
//                       currentCampaignName,
//                     );
//                   },
//                   icon: const Icon(Icons.visibility_rounded, size: 18),
//                   label: const FittedBox(
//                     fit: BoxFit.scaleDown,
//                     child: Text(
//                       'Chi tiết',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 13,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               _buildActionButton(
//                 Icons.qr_code_rounded,
//                 Colors.purple.shade50,
//                 Colors.purple.shade400,
//                     () => showQRCodeDialog(
//                   context,
//                   student,
//                   campaignName: currentCampaignName,
//                 ),
//               ),
//               const SizedBox(width: 8),
//               _buildActionButton(
//                 Icons.edit_rounded,
//                 Colors.grey.shade100,
//                 Colors.grey.shade700,
//                     () {
//                   showDialog(
//                     context: context,
//                     builder: (_) => StudentForm(
//                       student: student,
//                       campaigns: vm.campaigns,
//                       initialCampaignId: vm.tempCampaignFilter,
//                       onSave: (data) async {
//                         // ✨ ĐÃ FIX: Bổ sung trường email
//                         final success = await vm.updateStudent(
//                           Student(
//                             id: student.id,
//                             campaignId: data['campaignId'],
//                             studentCode: data['studentCode'],
//                             name: data['name'],
//                             className: data['className'],
//                             email: data['email'] ?? '',
//                             status: student.status,
//                           ),
//                         );
//                         if (context.mounted && !success)
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text(vm.error),
//                               backgroundColor: Colors.red,
//                             ),
//                           );
//                       },
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(width: 8),
//               _buildActionButton(
//                 Icons.delete_outline_rounded,
//                 Colors.red.shade50,
//                 Colors.red.shade400,
//                     () => showDeleteStudentDialog(context, student, () async {
//                   final success = await vm.deleteStudent(student.id);
//                   if (context.mounted && !success)
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(vm.error),
//                         backgroundColor: Colors.red,
//                       ),
//                     );
//                 }),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildActionButton(
//       IconData icon,
//       Color bgColor,
//       Color iconColor,
//       VoidCallback onTap,
//       ) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(10),
//       child: Container(
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           color: bgColor,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Icon(icon, color: iconColor, size: 20),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/student.dart';
import '../../viewmodels/admin/student_management_viewmodel.dart';
import '../../di.dart';
import 'widgets/student_form.dart';
import 'widgets/import_student_dialog.dart';
import 'widgets/delete_student_dialog.dart';
import 'widgets/qr_code_dialog.dart';
import 'widgets/student_detail_dialog.dart';

class StudentManagementPage extends StatelessWidget {
  const StudentManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<StudentManagementViewModel>(),
      child: Consumer<StudentManagementViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading && vm.filteredStudents.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProgressCard(context, vm),
                const SizedBox(height: 16),
                _buildFilters(vm),
                const SizedBox(height: 16),
                _buildStatsRow(vm),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Danh sách',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${vm.filteredStudents.length}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...vm.filteredStudents.map(
                      (s) => _buildStudentCard(context, s, vm),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilters(StudentManagementViewModel vm) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          TextField(
            onChanged: vm.setSearchTerm,
            decoration: InputDecoration(
              hintText: 'Tìm theo tên, MSSV, hoặc Email...',
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: Colors.grey.shade400,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
          Divider(
            height: 1,
            color: Colors.grey.shade100,
            indent: 16,
            endIndent: 16,
          ),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: vm.tempCampaignFilter,
                    icon: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: 'all',
                        child: Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text(
                            'Tất cả chiến dịch',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      ...vm.campaigns.map(
                            (c) => DropdownMenuItem(
                          value: c.id,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text(
                              c.name,
                              style: const TextStyle(fontSize: 14),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ],
                    onChanged: (val) => vm.setTempCampaignFilter(val!),
                  ),
                ),
              ),
              Container(width: 1, height: 48, color: Colors.grey.shade200),
              Expanded(
                flex: 4,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: vm.tempClassFilter,
                    icon: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: 'all',
                        child: Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text(
                            'Tất cả lớp',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      ...vm.availableClasses.map(
                            (c) => DropdownMenuItem(
                          value: c,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text(
                              c,
                              style: const TextStyle(fontSize: 14),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ],
                    onChanged: (val) => vm.setTempClassFilter(val!),
                  ),
                ),
              ),
              Container(width: 1, height: 48, color: Colors.grey.shade200),
              InkWell(
                onTap: () => vm.applyFilters(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.filter_list_rounded,
                        color: Colors.blue.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Lọc',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(
      BuildContext context,
      StudentManagementViewModel vm,
      ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tổng số sinh viên',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${vm.totalStudents}',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        String targetCampaignId = vm.tempCampaignFilter != 'all'
                            ? vm.tempCampaignFilter
                            : (vm.campaigns.isNotEmpty
                            ? vm.campaigns.first.id
                            : '');

                        String campName = 'Tất cả chiến dịch';
                        try {
                          campName = vm.campaigns
                              .firstWhere((c) => c.id == targetCampaignId)
                              .name;
                        } catch (_) {}

                        showDialog(
                          context: context,
                          builder: (_) => ImportStudentDialog(
                            existingStudents: vm.filteredStudents,
                            campaigns: vm.campaigns,
                            initialCampaignId: vm.tempCampaignFilter,
                            onImport: (targetCampaignId, listData) async {
                              Navigator.pop(context);
                              final success = await vm.importStudents(targetCampaignId, listData);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      success ? 'Import thành công!' : vm.error,
                                    ),
                                    backgroundColor: success ? Colors.green : Colors.red,
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      },
                      icon: const Icon(Icons.upload_rounded, size: 16),
                      label: const Text('Import'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white.withOpacity(0.5)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => StudentForm(
                            campaigns: vm.campaigns,
                            // ✨ ĐÃ FIX: Dùng filteredStudents thay vì allStudents bị lỗi
                            existingStudents: vm.filteredStudents,
                            initialCampaignId: vm.tempCampaignFilter,
                            onSave: (data) async {
                              final newStudent = Student(
                                id: const Uuid().v4(),
                                campaignId: data['campaignId'],
                                studentCode: data['studentCode'],
                                name: data['name'],
                                className: data['className'],
                                email: data['email'] ?? '',
                                status: 'not_started',
                              );
                              final success = await vm.createStudent(
                                newStudent,
                              );
                              if (context.mounted) {
                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Thêm thành công!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(vm.error),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_rounded, size: 16),
                      label: const Text('Thêm'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.teal.shade600,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: vm.totalStudents == 0
                      ? 0
                      : vm.completedStudents / vm.totalStudents,
                  color: Colors.white,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  strokeWidth: 8,
                  strokeCap: StrokeCap.round,
                ),
              ),
              Text(
                '${vm.totalStudents == 0 ? 0 : ((vm.completedStudents / vm.totalStudents) * 100).round()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(StudentManagementViewModel vm) {
    return Row(
      children: [
        _buildStatBox(
          'Hoàn thành',
          vm.completedStudents,
          const Color(0xFFE8F8F5),
          Colors.green.shade600,
          Icons.how_to_reg_rounded,
        ),
        const SizedBox(width: 12),
        _buildStatBox(
          'Đang khám',
          vm.inProgressStudents,
          const Color(0xFFFFF9E6),
          Colors.orange.shade600,
          Icons.schedule_rounded,
        ),
        const SizedBox(width: 12),
        _buildStatBox(
          'Chưa khám',
          vm.notStartedStudents,
          const Color(0xFFF8F9FA),
          Colors.grey.shade600,
          Icons.access_time_rounded,
        ),
      ],
    );
  }

  Widget _buildStatBox(
      String label,
      int count,
      Color bgColor,
      Color fgColor,
      IconData icon,
      ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: fgColor.withOpacity(0.3)),
              ),
              child: Icon(icon, color: fgColor, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: fgColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: fgColor,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentCard(
      BuildContext context,
      Student student,
      StudentManagementViewModel vm,
      ) {
    final completedStations = vm.getCompletedStationsCount(student.id);
    Color statusBgColor, statusFgColor;
    String statusText;
    if (student.status == 'completed') {
      statusBgColor = const Color(0xFFE8F8F5);
      statusFgColor = Colors.green.shade700;
      statusText = 'Hoàn thành';
    } else if (student.status == 'in_progress') {
      statusBgColor = const Color(0xFFFFF9E6);
      statusFgColor = Colors.orange.shade700;
      statusText = 'Đang khám';
    } else {
      statusBgColor = Colors.grey.shade100;
      statusFgColor = Colors.grey.shade700;
      statusText = 'Chưa khám';
    }

    String currentCampaignName = 'Không xác định';
    try {
      currentCampaignName = vm.campaigns
          .firstWhere((c) => c.id == student.campaignId)
          .name;
    } catch (_) {}

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.purple.shade400,
                child: Text(
                  student.name[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${student.studentCode} • 🎓 ${student.className}',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '✉️ ${student.email}',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusFgColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tiến độ',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$completedStations/4',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: completedStations / 4,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation(Colors.purple.shade400),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade50,
                    foregroundColor: Colors.blue.shade700,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    showStudentDetailDialog(
                      context,
                      student,
                      completedStations,
                      currentCampaignName,
                    );
                  },
                  icon: const Icon(Icons.visibility_rounded, size: 18),
                  label: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Chi tiết',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _buildActionButton(
                Icons.qr_code_rounded,
                Colors.purple.shade50,
                Colors.purple.shade400,
                    () => showQRCodeDialog(
                  context,
                  student,
                  campaignName: currentCampaignName,
                ),
              ),
              const SizedBox(width: 8),
              _buildActionButton(
                Icons.edit_rounded,
                Colors.grey.shade100,
                Colors.grey.shade700,
                    () {
                  showDialog(
                    context: context,
                    builder: (_) => StudentForm(
                      student: student,
                      campaigns: vm.campaigns,
                      // ✨ ĐÃ FIX: Bổ sung existingStudents và dùng filteredStudents
                      existingStudents: vm.filteredStudents,
                      initialCampaignId: vm.tempCampaignFilter,
                      onSave: (data) async {
                        final success = await vm.updateStudent(
                          Student(
                            id: student.id,
                            campaignId: data['campaignId'],
                            studentCode: data['studentCode'],
                            name: data['name'],
                            className: data['className'],
                            email: data['email'] ?? '',
                            status: student.status,
                          ),
                        );
                        if (context.mounted && !success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(vm.error),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
              _buildActionButton(
                Icons.delete_outline_rounded,
                Colors.red.shade50,
                Colors.red.shade400,
                    () => showDeleteStudentDialog(context, student, () async {
                  final success = await vm.deleteStudent(student.id);
                  if (context.mounted && !success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(vm.error),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      IconData icon,
      Color bgColor,
      Color iconColor,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }
}