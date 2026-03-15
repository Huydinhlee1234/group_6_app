import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../di.dart';
import '../../viewmodels/health_staff/station_selection_viewmodel.dart';
import '../../viewmodels/login/login_viewmodel.dart'; // ✨ BẮT BUỘC IMPORT ĐỂ BƠM VÀO LOGIN PAGE
import '../login/login_page.dart';
import 'station_selection_page.dart';

class HealthStaffDashboardPage extends StatelessWidget {
  const HealthStaffDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              // ✨ ĐÃ FIX: Bơm LoginViewModel cho LoginPage khi chuyển trang
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                    create: (_) => sl<LoginViewModel>(),
                    child: const LoginPage(),
                  ),
                ),
                    (route) => false, // Xóa sạch lịch sử để không back lại được
              );
            },
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text('Đăng xuất', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: ChangeNotifierProvider(
        create: (_) => sl<StationSelectionViewModel>(),
        child: const StationSelectionPage(),
      ),
    );
  }
}