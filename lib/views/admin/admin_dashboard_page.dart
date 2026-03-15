// import 'package:flutter/material.dart';
// import 'admin_overview_page.dart';
// import 'campaign_management_page.dart';
// import 'student_management_page.dart';
// import 'health_staff_management_page.dart';
// import 'reports_page.dart';
//
// class AdminDashboardPage extends StatefulWidget {
//   const AdminDashboardPage({super.key});
//
//   @override
//   State<AdminDashboardPage> createState() => _AdminDashboardPageState();
// }
//
// class _AdminDashboardPageState extends State<AdminDashboardPage> {
//   int _currentIndex = 0;
//
//   void _handleLogout() {
//     Navigator.of(context).pushReplacementNamed('/');
//   }
//
//   void _openBulkEmailDialog() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Chức năng Gửi Email hàng loạt sẽ mở tại đây')),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Khởi tạo danh sách các trang
//     final List<Widget> pages = [
//       AdminOverviewPage(onOpenBulkEmail: _openBulkEmailDialog),
//       const CampaignManagementPage(),
//       const StudentManagementPage(),
//       const HealthStaffManagementPage(),
//       const ReportsPage(),
//     ];
//
//     final isDesktop = MediaQuery.of(context).size.width > 768;
//
//     if (isDesktop) {
//       return Scaffold(
//         body: Row(
//           children: [
//             _buildDesktopSidebar(),
//             Expanded(
//               child: Container(
//                 color: Colors.grey.shade50,
//                 child: pages[_currentIndex],
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Admin Dashboard', style: TextStyle(fontSize: 16)),
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
//           ),
//         ),
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(icon: const Icon(Icons.logout), onPressed: _handleLogout)
//         ],
//       ),
//       body: Container(
//         color: Colors.grey.shade50,
//         child: pages[_currentIndex],
//       ),
//       floatingActionButton: _currentIndex == 0 ? FloatingActionButton(
//         onPressed: _openBulkEmailDialog,
//         backgroundColor: Colors.purple,
//         child: const Icon(Icons.mail, color: Colors.white),
//       ) : null,
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (index) => setState(() => _currentIndex = index),
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: Colors.purple,
//         unselectedItemColor: Colors.grey,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Tổng quan'),
//           BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Chiến dịch'),
//           BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Sinh viên'),
//           BottomNavigationBarItem(icon: Icon(Icons.medical_services), label: 'Nhân viên'),
//           BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Báo cáo'),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDesktopSidebar() {
//     return Container(
//       width: 280,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border(right: BorderSide(color: Colors.grey.shade200)),
//       ),
//       child: Column(
//         children: [
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(24),
//             decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.blue, Colors.purple])),
//             child: const Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Health Check', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
//                 Text('Admin Dashboard', style: TextStyle(color: Colors.white70, fontSize: 14)),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.all(16),
//               children: [
//                 _SidebarItem(icon: Icons.dashboard, label: 'Tổng quan', isSelected: _currentIndex == 0, onTap: () => setState(() => _currentIndex = 0)),
//                 _SidebarItem(icon: Icons.calendar_month, label: 'Chiến dịch', isSelected: _currentIndex == 1, onTap: () => setState(() => _currentIndex = 1)),
//                 _SidebarItem(icon: Icons.people, label: 'Sinh viên', isSelected: _currentIndex == 2, onTap: () => setState(() => _currentIndex = 2)),
//                 _SidebarItem(icon: Icons.medical_services, label: 'Nhân viên y tế', isSelected: _currentIndex == 3, onTap: () => setState(() => _currentIndex = 3)),
//                 _SidebarItem(icon: Icons.bar_chart, label: 'Báo cáo', isSelected: _currentIndex == 4, onTap: () => setState(() => _currentIndex = 4)),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: OutlinedButton.icon(
//               style: OutlinedButton.styleFrom(foregroundColor: Colors.red, minimumSize: const Size.fromHeight(48)),
//               onPressed: _handleLogout,
//               icon: const Icon(Icons.logout),
//               label: const Text('Đăng xuất'),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
//
// class _SidebarItem extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final bool isSelected;
//   final VoidCallback onTap;
//
//   const _SidebarItem({required this.icon, required this.label, required this.isSelected, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: Icon(icon, color: isSelected ? Colors.white : Colors.grey.shade600),
//       title: Text(label, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? Colors.white : Colors.black87)),
//       selected: isSelected,
//       selectedTileColor: Colors.purple.shade500,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       onTap: onTap,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'admin_overview_page.dart';
import 'campaign_management_page.dart';
import 'student_management_page.dart';
import 'health_staff_management_page.dart';
import 'reports_page.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _menuItems = [
    {'title': 'Tổng quan', 'icon': Icons.dashboard_rounded, 'color': Colors.blue.shade600},
    {'title': 'Chiến dịch', 'icon': Icons.event_note_rounded, 'color': Colors.teal.shade600},
    {'title': 'Sinh viên', 'icon': Icons.school_rounded, 'color': Colors.orange.shade600},
    {'title': 'Nhân viên', 'icon': Icons.medical_services_rounded, 'color': Colors.pink.shade400},
    {'title': 'Báo cáo', 'icon': Icons.analytics_rounded, 'color': Colors.deepPurple.shade500},
  ];

  void _handleLogout() {
    Navigator.of(context).pushReplacementNamed('/');
  }

  // void _openBulkEmailDialog() {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text('Chức năng Gửi Email hàng loạt sẽ mở tại đây')),
  //   );
  // }

  void _onSelectItem(int index) {
    setState(() {
      _currentIndex = index;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const AdminOverviewPage(),
      const CampaignManagementPage(),
      const StudentManagementPage(),
      const HealthStaffManagementPage(),
      const ReportsPage(),
    ];

    final currentMenu = _menuItems[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,

      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade200, height: 1.0),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: currentMenu['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(currentMenu['icon'], color: currentMenu['color'], size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              currentMenu['title'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Nguyễn Admin',
                      style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Quản trị viên',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.blue.shade50,
                  child: Text('N', style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ],
            ),
          )
        ],
      ),

      drawer: _buildDrawer(),

      body: pages[_currentIndex],

      // Đã xóa phần floatingActionButton ở đây để làm giao diện sạch sẽ hơn!
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue.shade700, Colors.blue.shade500],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
                  ),
                  child: Icon(Icons.favorite_rounded, color: Colors.blue.shade600, size: 32),
                ),
                const SizedBox(height: 20),
                const Text('Health Check', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                Text('Hệ thống Quản trị v1.0', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final item = _menuItems[index];
                final isSelected = _currentIndex == index;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    leading: Icon(
                      item['icon'],
                      color: isSelected ? item['color'] : Colors.grey.shade500,
                    ),
                    title: Text(
                      item['title'],
                      style: TextStyle(
                        color: isSelected ? Colors.black87 : Colors.grey.shade700,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    selected: isSelected,
                    selectedTileColor: item['color'].withOpacity(0.08),
                    onTap: () => _onSelectItem(index),
                  ),
                );
              },
            ),
          ),

          Divider(color: Colors.grey.shade200, height: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: _handleLogout,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.logout_rounded, color: Colors.red.shade600, size: 20),
                    const SizedBox(width: 12),
                    Text('Đăng xuất', style: TextStyle(color: Colors.red.shade600, fontWeight: FontWeight.bold, fontSize: 15)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}