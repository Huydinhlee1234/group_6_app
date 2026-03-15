import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/user.dart';
import '../../viewmodels/login/login_viewmodel.dart';
import '../admin/admin_dashboard_page.dart';
import '../health_staff/health_staff_dashboard_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  void _onLoginSuccess(BuildContext context, User user) {
    if (user.role == UserRole.admin) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminDashboardPage()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HealthStaffDashboardPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade500, Colors.blue.shade400, Colors.blue.shade600],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo & Title
                    _buildHeader(),
                    const SizedBox(height: 32),

                    // Login Card
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      color: Colors.white.withOpacity(0.95),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Đăng nhập',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Chào mừng bạn trở lại',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 24),

                            // Error Message
                            if (viewModel.error.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  border: Border.all(color: Colors.red.shade200),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  viewModel.error,
                                  style: TextStyle(color: Colors.red.shade600, fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                              ),

                            // Username Input
                            _buildInput(
                              label: 'Tên đăng nhập',
                              icon: Icons.person_outline,
                              hint: 'Nhập tên đăng nhập',
                              onChanged: viewModel.setUsername,
                            ),
                            const SizedBox(height: 16),

                            // Password Input
                            _buildInput(
                              label: 'Mật khẩu',
                              icon: Icons.lock_outline,
                              hint: 'Nhập mật khẩu',
                              isPassword: true,
                              onChanged: viewModel.setPassword,
                            ),
                            const SizedBox(height: 24),

                            // Role Selection
                            const Text('Chọn vai trò', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 12),
                            _buildRoleSelector(
                              value: UserRole.admin,
                              groupValue: viewModel.selectedRole,
                              title: 'Quản trị viên',
                              subtitle: 'Quản lý hệ thống',
                              icon: Icons.shield,
                              onChanged: (val) => viewModel.setRole(val!),
                            ),
                            const SizedBox(height: 12),
                            _buildRoleSelector(
                              value: UserRole.healthStaff,
                              groupValue: viewModel.selectedRole,
                              title: 'Nhân viên y tế',
                              subtitle: 'Khám và ghi nhận',
                              icon: Icons.favorite,
                              onChanged: (val) => viewModel.setRole(val!),
                            ),
                            const SizedBox(height: 24),

                            // Login Button
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade600,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 4,
                              ),
                              onPressed: viewModel.isLoading
                                  ? null
                                  : () async {
                                final user = await viewModel.handleLogin();
                                if (user != null && context.mounted) {
                                  _onLoginSuccess(context, user);
                                }
                              },
                              child: viewModel.isLoading
                                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                  : const Text('Đăng nhập', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 20)],
          ),
          child: const Icon(Icons.favorite, color: Colors.blue, size: 40),
        ),
        const SizedBox(height: 16),
        const Text(
          'Health Check',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Text(
          'Hệ thống Khám Sức Khỏe Sinh Viên',
          style: TextStyle(fontSize: 14, color: Colors.blue.shade100),
        ),
      ],
    );
  }

  Widget _buildInput({
    required String label,
    required IconData icon,
    required String hint,
    bool isPassword = false,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          onChanged: onChanged,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.grey.shade400),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleSelector({
    required UserRole value,
    required UserRole groupValue,
    required String title,
    required String subtitle,
    required IconData icon,
    required Function(UserRole?) onChanged,
  }) {
    final isSelected = value == groupValue;
    final color = value == UserRole.admin ? Colors.blue : Colors.purple;

    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade200,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? color.withOpacity(0.05) : Colors.transparent,
        ),
        child: Row(
          children: [
            Radio<UserRole>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: color,
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: isSelected ? Colors.white : Colors.grey.shade500),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                  Text(subtitle, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}