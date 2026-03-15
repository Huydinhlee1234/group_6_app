// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../di.dart';
// import '../../viewmodels/health_staff/station_selection_viewmodel.dart';
// import '../../viewmodels/health_staff/student_check_in_viewmodel.dart';
// import 'student_check_in_page.dart';
//
// class StationSelectionPage extends StatefulWidget {
//   const StationSelectionPage({super.key});
//
//   @override
//   State<StationSelectionPage> createState() => _StationSelectionPageState();
// }
//
// class _StationSelectionPageState extends State<StationSelectionPage> {
//   String? _campaignId;
//   String? _stationId;
//
//   // ✨ BỔ SUNG: Hàm lấy Icon tương ứng cho từng trạm
//   IconData _getStationIcon(String id) {
//     switch (id) {
//       case 'physical':
//         return Icons.accessibility_new_rounded; // Thể lực
//       case 'vision':
//         return Icons.remove_red_eye_rounded; // Thị lực
//       case 'blood_pressure':
//         return Icons.favorite_rounded; // Huyết áp
//       case 'general':
//         return Icons.medical_services_rounded; // Tổng quát
//       default:
//         return Icons.health_and_safety_rounded;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final vm = context.watch<StationSelectionViewModel>();
//
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       body: SafeArea(
//         child: vm.isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : SingleChildScrollView(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             children: [
//               const Text('Chọn Trạm Làm Việc', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 24),
//               // Ô CHỌN CHIẾN DỊCH
//               DropdownButtonFormField<String>(
//                 decoration: InputDecoration(
//                   labelText: 'Chiến dịch',
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                   filled: vm.activeCampaigns.isEmpty,
//                   fillColor: Colors.grey.shade100,
//                 ),
//                 value: _campaignId,
//                 hint: Text(
//                   vm.activeCampaigns.isEmpty
//                       ? 'Không có chiến dịch nào đang diễn ra'
//                       : 'Chọn chiến dịch',
//                   style: TextStyle(
//                     color: vm.activeCampaigns.isEmpty ? Colors.red : Colors.grey.shade700,
//                     fontWeight: vm.activeCampaigns.isEmpty ? FontWeight.bold : FontWeight.normal,
//                   ),
//                 ),
//                 items: vm.activeCampaigns.isEmpty
//                     ? null
//                     : vm.activeCampaigns.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
//                 onChanged: vm.activeCampaigns.isEmpty
//                     ? null
//                     : (val) => setState(() => _campaignId = val),
//               ),
//               const SizedBox(height: 24),
//
//               // DANH SÁCH TRẠM KHÁM
//               GridView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 16,
//                   mainAxisSpacing: 16,
//                   childAspectRatio: 1.1, // Chỉnh lại tỷ lệ cho ô vuông vắn đẹp hơn
//                 ),
//                 itemCount: vm.stations.length,
//                 itemBuilder: (context, index) {
//                   final station = vm.stations[index];
//                   final isSelected = _stationId == station.id;
//
//                   return GestureDetector(
//                     onTap: () => setState(() => _stationId = station.id),
//                     child: AnimatedContainer(
//                       duration: const Duration(milliseconds: 200),
//                       decoration: BoxDecoration(
//                         color: isSelected ? Colors.blue.shade600 : Colors.white,
//                         borderRadius: BorderRadius.circular(16),
//                         border: Border.all(
//                           color: isSelected ? Colors.transparent : Colors.grey.shade300,
//                           width: 2,
//                         ),
//                         boxShadow: isSelected
//                             ? [BoxShadow(color: Colors.blue.shade200, blurRadius: 10, offset: const Offset(0, 4))]
//                             : [],
//                       ),
//                       // ✨ ĐÃ NÂNG CẤP GIAO DIỆN TỪNG Ô: Thêm Icon vào đây
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             _getStationIcon(station.id),
//                             size: 40,
//                             color: isSelected ? Colors.white : Colors.blue.shade600,
//                           ),
//                           const SizedBox(height: 12),
//                           Text(
//                             station.name,
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: isSelected ? Colors.white : Colors.black87,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 15,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(height: 32),
//
//               // NÚT BẮT ĐẦU LÀM VIỆC
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: (_campaignId != null && _stationId != null) ? () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => ChangeNotifierProvider(
//                           create: (_) => sl<StudentCheckInViewModel>(),
//                           child: StudentCheckInPage(
//                               campaignId: _campaignId!,
//                               stationId: _stationId!
//                           ),
//                         ),
//                       ),
//                     );
//                   } : null,
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     backgroundColor: Colors.blue.shade600,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                   child: const Text('Bắt đầu làm việc', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../di.dart';
import '../../viewmodels/health_staff/station_selection_viewmodel.dart';
import '../../viewmodels/health_staff/student_check_in_viewmodel.dart';
import 'student_check_in_page.dart';

class StationSelectionPage extends StatefulWidget {
  const StationSelectionPage({super.key});

  @override
  State<StationSelectionPage> createState() => _StationSelectionPageState();
}

class _StationSelectionPageState extends State<StationSelectionPage> {
  String? _campaignId;
  String? _stationId;

  // Hàm lấy Icon tương ứng cho từng trạm
  IconData _getStationIcon(String id) {
    switch (id) {
      case 'physical':
        return Icons.accessibility_new_rounded; // Thể lực
      case 'vision':
        return Icons.remove_red_eye_rounded; // Thị lực
      case 'blood_pressure':
        return Icons.favorite_rounded; // Huyết áp
      case 'general':
        return Icons.medical_services_rounded; // Tổng quát
      default:
        return Icons.health_and_safety_rounded;
    }
  }

  // ✨ BỔ SUNG: Hàm lấy Màu sắc tương ứng cho từng trạm
  Color _getStationColor(String id) {
    switch (id) {
      case 'physical':
        return Colors.blue.shade500;     // Thể lực: Xanh dương
      case 'vision':
        return Colors.purple.shade500;   // Thị lực: Tím
      case 'blood_pressure':
        return Colors.red.shade500;      // Huyết áp: Đỏ
      case 'general':
        return Colors.green.shade500;    // Tổng quát: Xanh lá
      default:
        return Colors.blue.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StationSelectionViewModel>();

    // Lấy màu của trạm đang được chọn (dùng cho nút Bắt đầu)
    final selectedColor = _stationId != null ? _getStationColor(_stationId!) : Colors.blue.shade600;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: vm.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text('Chọn Trạm Làm Việc', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              // Ô CHỌN CHIẾN DỊCH
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Chiến dịch',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: vm.activeCampaigns.isEmpty,
                  fillColor: Colors.grey.shade100,
                ),
                value: _campaignId,
                hint: Text(
                  vm.activeCampaigns.isEmpty
                      ? 'Không có chiến dịch nào đang diễn ra'
                      : 'Chọn chiến dịch',
                  style: TextStyle(
                    color: vm.activeCampaigns.isEmpty ? Colors.red : Colors.grey.shade700,
                    fontWeight: vm.activeCampaigns.isEmpty ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                items: vm.activeCampaigns.isEmpty
                    ? null
                    : vm.activeCampaigns.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                onChanged: vm.activeCampaigns.isEmpty
                    ? null
                    : (val) => setState(() => _campaignId = val),
              ),
              const SizedBox(height: 24),

              // DANH SÁCH TRẠM KHÁM
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemCount: vm.stations.length,
                itemBuilder: (context, index) {
                  final station = vm.stations[index];
                  final isSelected = _stationId == station.id;
                  final stationColor = _getStationColor(station.id); // Lấy màu riêng cho trạm này

                  return GestureDetector(
                    onTap: () => setState(() => _stationId = station.id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        // ✨ ĐÃ NÂNG CẤP: Áp dụng màu riêng khi được chọn
                        color: isSelected ? stationColor : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? Colors.transparent : Colors.grey.shade300,
                          width: 2,
                        ),
                        boxShadow: isSelected
                            ? [BoxShadow(color: stationColor.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4))]
                            : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _getStationIcon(station.id),
                            size: 40,
                            // ✨ ĐÃ NÂNG CẤP: Icon có màu riêng khi chưa chọn, thành màu trắng khi chọn
                            color: isSelected ? Colors.white : stationColor,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            station.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),

              // NÚT BẮT ĐẦU LÀM VIỆC
              SizedBox(
                width: double.infinity,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: ElevatedButton(
                    onPressed: (_campaignId != null && _stationId != null) ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChangeNotifierProvider(
                            create: (_) => sl<StudentCheckInViewModel>(),
                            child: StudentCheckInPage(
                                campaignId: _campaignId!,
                                stationId: _stationId!
                            ),
                          ),
                        ),
                      );
                    } : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      // ✨ ĐÃ NÂNG CẤP: Nút chuyển sang màu của trạm đang được chọn
                      backgroundColor: selectedColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Bắt đầu làm việc', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}