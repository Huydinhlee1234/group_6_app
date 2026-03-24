// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../di.dart';
// import '../../viewmodels/health_staff/station_selection_viewmodel.dart';
// import '../../viewmodels/login/login_viewmodel.dart'; // ✨ BẮT BUỘC IMPORT ĐỂ BƠM VÀO LOGIN PAGE
// import '../login/login_page.dart';
// import 'station_selection_page.dart';
//
// class HealthStaffDashboardPage extends StatelessWidget {
//   const HealthStaffDashboardPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Nhân viên Y tế', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//             Text('Hệ thống khám sức khỏe', style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
//           ],
//         ),
//         backgroundColor: Colors.blue.shade600,
//         foregroundColor: Colors.white,
//         actions: [
//           TextButton.icon(
//             onPressed: () {
//               // ✨ ĐÃ FIX: Bơm LoginViewModel cho LoginPage khi chuyển trang
//               Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ChangeNotifierProvider(
//                     create: (_) => sl<LoginViewModel>(),
//                     child: const LoginPage(),
//                   ),
//                 ),
//                     (route) => false, // Xóa sạch lịch sử để không back lại được
//               );
//             },
//             icon: const Icon(Icons.logout, color: Colors.white),
//             label: const Text('Đăng xuất', style: TextStyle(color: Colors.white)),
//           )
//         ],
//       ),
//       body: ChangeNotifierProvider(
//         create: (_) => sl<StationSelectionViewModel>(),
//         child: const StationSelectionPage(),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ✨ THÊM THƯ VIỆN: Để chỉnh màu thanh điều hướng hệ thống
import 'package:provider/provider.dart';
import '../../../di.dart';
import '../../viewmodels/health_staff/station_selection_viewmodel.dart';
import '../../viewmodels/login/login_viewmodel.dart';
import '../login/login_page.dart';
import 'station_selection_page.dart';

class HealthStaffDashboardPage extends StatelessWidget {
  const HealthStaffDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ✨ ĐÃ SỬA: Bọc AnnotatedRegion để đồng bộ màu thanh gạt hệ thống dưới đáy
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.grey.shade50, // Đồng bộ màu với màu nền của Scaffold
        systemNavigationBarIconBrightness: Brightness.dark, // Icon hệ thống màu tối để dễ nhìn
      ),
      child: Scaffold(
        backgroundColor: Colors.grey.shade50, // ✨ THÊM MÀU NỀN CỐ ĐỊNH
        appBar: AppBar(
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nhân viên Y tế', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text('Hệ thống khám sức khỏe', style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
            ],
          ),
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
          actions: [
            TextButton.icon(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                      create: (_) => sl<LoginViewModel>(),
                      child: const LoginPage(),
                    ),
                  ),
                      (route) => false,
                );
              },
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text('Đăng xuất', style: TextStyle(color: Colors.white)),
            )
          ],
        ),

        // ✨ ĐÃ SỬA: Bọc SafeArea để đẩy nội dung khỏi thanh điều hướng ảo
        body: SafeArea(
          bottom: true,
          child: ChangeNotifierProvider(
            create: (_) => sl<StationSelectionViewModel>(),
            child: const StationSelectionPage(),
          ),
        ),
      ),
    );
  }
}