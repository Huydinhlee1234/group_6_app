import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/campaign.dart';
import '../../viewmodels/admin/campaign_management_viewmodel.dart';
import 'widgets/campaign_form.dart';
import 'widgets/campaign_detail_dialog.dart';
import 'widgets/delete_campaign_dialog.dart'; // ✨ Import hộp thoại xóa
import '../../di.dart';

class CampaignManagementPage extends StatelessWidget {
  const CampaignManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<CampaignManagementViewModel>(),
      child: Consumer<CampaignManagementViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading && vm.campaigns.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, vm),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Danh sách chiến dịch', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const SizedBox(width: 8),
                    Text('${vm.campaigns.length}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey.shade500)),
                  ],
                ),
                const SizedBox(height: 16),
                ...vm.campaigns.map((c) => _buildCampaignCard(c, vm, context)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, CampaignManagementViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.teal.shade500, Colors.teal.shade300]), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.teal.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Quản lý', style: TextStyle(color: Colors.white70, fontSize: 13)),
                const Text('Chiến dịch Y tế', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(context: context, builder: (_) => CampaignForm(onSave: (newCamp) => vm.createCampaign(newCamp)));
                  },
                  icon: const Icon(Icons.add_rounded, size: 16), label: const Text('Thêm chiến dịch'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.teal.shade700, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                )
              ],
            ),
          ),
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle), child: const Icon(Icons.calendar_month_rounded, color: Colors.white, size: 40))
        ],
      ),
    );
  }

  Widget _buildCampaignCard(Campaign campaign, CampaignManagementViewModel vm, BuildContext context) {
    Color statusBgColor, statusFgColor; String statusText;
    if (campaign.status == 'active' || campaign.status == 'ongoing') {
      statusBgColor = const Color(0xFFE8F8F5); statusFgColor = Colors.green.shade700; statusText = 'Đang diễn ra';
    }
    else if (campaign.status == 'upcoming') {
      statusBgColor = const Color(0xFFE3F2FD); statusFgColor = Colors.blue.shade700; statusText = 'Sắp tới';
    }
    else {
      statusBgColor = Colors.grey.shade100; statusFgColor = Colors.grey.shade700; statusText = 'Đã kết thúc';
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.teal.shade50, borderRadius: BorderRadius.circular(12)), child: Icon(Icons.event_note_rounded, color: Colors.teal.shade600)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(campaign.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)), const SizedBox(height: 4), Row(children: [Icon(Icons.place_rounded, size: 14, color: Colors.grey.shade400), const SizedBox(width: 4), Expanded(child: Text(campaign.location, style: TextStyle(color: Colors.grey.shade500, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis))])])),
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: statusBgColor, borderRadius: BorderRadius.circular(12)), child: Text(statusText, style: TextStyle(color: statusFgColor, fontSize: 11, fontWeight: FontWeight.bold)))
            ],
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1)),
          Row(children: [Icon(Icons.date_range_rounded, size: 16, color: Colors.grey.shade500), const SizedBox(width: 8), Text('${campaign.startDate}  -  ${campaign.endDate}', style: TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w500))]),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade50, foregroundColor: Colors.blue.shade700, elevation: 0, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), onPressed: () => showCampaignDetailDialog(context, campaign), icon: const Icon(Icons.visibility_rounded, size: 18), label: const Text('Chi tiết', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)))),
              const SizedBox(width: 8),
              _buildActionButton(Icons.edit_rounded, Colors.grey.shade100, Colors.grey.shade700, () {
                showDialog(context: context, builder: (_) => CampaignForm(campaign: campaign, onSave: (updatedCamp) => vm.updateCampaign(updatedCamp)));
              }),
              const SizedBox(width: 8),
              // ✨ GỌI HỘP THOẠI XÓA MÀU ĐỎ Ở ĐÂY
              _buildActionButton(Icons.delete_outline_rounded, Colors.red.shade50, Colors.red.shade400, () {
                showDeleteCampaignDialog(context, campaign, () async {
                  final success = await vm.deleteCampaign(campaign.id);
                  if (context.mounted && !success) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vm.error), backgroundColor: Colors.red));
                });
              }),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, Color bgColor, Color iconColor, VoidCallback onTap) {
    return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(10), child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: iconColor, size: 20)));
  }
}