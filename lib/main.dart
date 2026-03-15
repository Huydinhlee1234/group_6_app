import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import cấu hình Dependency Injection
import 'di.dart';

// Import ViewModels cho màn hình khởi đầu
import 'viewmodels/login/login_viewmodel.dart';

// Import các màn hình (Views)
import 'views/login/login_page.dart';
import 'views/admin/admin_dashboard_page.dart';
import 'views/health_staff/health_staff_dashboard_page.dart';

// Import Database (Tuỳ chọn: Để khởi tạo DB ngay khi mở app)
import 'data/implementations/local/app_database.dart';

void main() async {
  // Bắt buộc phải có dòng này khi hàm main() dùng async
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Database SQLite (Giúp chạy hàm onCreate tạo bảng và insert Mock Data ngay lập tức)
  await AppDatabase.instance.db;

  // Khởi tạo toàn bộ Dependencies (APIs, Repositories, ViewModels)
  setupDependencies();

  // Chạy ứng dụng
  runApp(const HealthCheckApp());
}

class HealthCheckApp extends StatelessWidget {
  const HealthCheckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Check System',
      debugShowCheckedModeBanner: false, // Ẩn chữ "DEBUG" ở góc phải

      // Cấu hình Theme chung cho toàn app
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue.shade600,
          secondary: Colors.purple,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),

      // Route mặc định khi mở app
      initialRoute: '/',

      // Định nghĩa bản đồ điều hướng (Routing Map)
      routes: {
        // 1. Màn hình Đăng nhập (Bọc Provider để cung cấp LoginViewModel)
        '/': (context) => ChangeNotifierProvider(
          // Dùng Service Locator (sl) để lấy LoginViewModel đã được tiêm Repositories
          create: (_) => sl<LoginViewModel>(),
          child: const LoginPage(),
        ),

        // 2. Màn hình Dashboard của Admin
        // Lưu ý: Các ViewModel của các tab bên trong AdminDashboardPage đã được
        // bọc ChangeNotifierProvider trực tiếp trong từng file page (vd: admin_overview_page.dart)
        '/admin': (context) => const AdminDashboardPage(),

        // 3. Màn hình Dashboard của Nhân viên y tế
        '/health_staff': (context) => const HealthStaffDashboardPage(),
      },
    );
  }
}