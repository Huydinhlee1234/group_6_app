import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/user.dart';
import '../../viewmodels/admin/health_staff_management_viewmodel.dart';
import '../../di.dart';
import 'widgets/health_staff_form.dart';
import 'widgets/delete_health_staff_dialog.dart';

class HealthStaffManagementPage extends StatelessWidget {
  const HealthStaffManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<HealthStaffManagementViewModel>(),
      child: Consumer<HealthStaffManagementViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && viewModel.filteredStaff.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildStatsCard(context, viewModel),
                const SizedBox(height: 16),
                _buildSearch(viewModel),
                const SizedBox(height: 24),
                Text('Danh sách (${viewModel.filteredStaff.length})', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ...viewModel.filteredStaff.map((staff) => _buildStaffCard(context, staff, viewModel)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const CircleAvatar(radius: 28, backgroundColor: Colors.cyan, child: Icon(Icons.medical_services, color: Colors.white, size: 28)),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Quản lý', style: TextStyle(color: Colors.grey, fontSize: 14)),
              Text('Nhân viên y tế', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildStatsCard(BuildContext context, HealthStaffManagementViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(gradient: const LinearGradient(colors: [Colors.blue, Colors.cyan]), borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tổng số nhân viên', style: TextStyle(color: Colors.white70)),
                Text('${vm.totalStaff}', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => HealthStaffForm(
                        existingUsernames: vm.filteredStaff.map((s) => s.username).toList(),
                        onSave: (data) async { // Thêm async vào đây
                          final newStaff = User(
                            id: const Uuid().v4(), // DÙNG UUID CHUẨN ĐỂ SQLITE KHÔNG BÁO LỖI
                            username: data['username'],
                            password: data['password'] ?? '',
                            name: data['name'],
                            role: UserRole.healthStaff,
                          );

                          // Chờ lưu xong và lấy kết quả
                          final success = await vm.createHealthStaff(newStaff);

                          if (context.mounted) {
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thêm nhân viên thành công!'), backgroundColor: Colors.green));
                            } else {
                              // Hiển thị lỗi từ ViewModel ra màn hình để biết tại sao DB từ chối
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vm.error), backgroundColor: Colors.red));
                            }
                          }
                        },
                      ),
                    );
                  },
                  icon: const Icon(Icons.add, size: 16), label: const Text('Thêm mới'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.blue),
                )
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(padding: const EdgeInsets.all(16), decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle), child: const Icon(Icons.person_add, color: Colors.white, size: 40))
        ],
      ),
    );
  }

  Widget _buildSearch(HealthStaffManagementViewModel vm) {
    return TextField(
      onChanged: vm.setSearchTerm,
      decoration: InputDecoration(hintText: 'Tìm theo tên hoặc tài khoản...', prefixIcon: const Icon(Icons.search), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
    );
  }

  Widget _buildStaffCard(BuildContext context, User staff, HealthStaffManagementViewModel vm) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(backgroundColor: Colors.blue, child: Text(staff.name[0], style: const TextStyle(color: Colors.white))),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(staff.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Text('@${staff.username}', style: const TextStyle(color: Colors.grey, fontSize: 13))])),
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)), child: const Text('Nhân viên', style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold)))
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => HealthStaffForm(
                          staff: staff,
                          existingUsernames: vm.filteredStaff.where((s) => s.id != staff.id).map((s) => s.username).toList(),
                          onSave: (data) {
                            final updatedStaff = User(id: staff.id, username: data['username'], password: data['password'] ?? staff.password, name: data['name'], role: UserRole.healthStaff);
                            vm.updateHealthStaff(updatedStaff);
                          },
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit, size: 16), label: const Text('Chỉnh sửa'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => showDeleteHealthStaffDialog(context, staff, () => vm.deleteHealthStaff(staff.id)),
                  style: IconButton.styleFrom(backgroundColor: Colors.red.shade50),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}