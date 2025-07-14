import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:food_donation/routes/app_routes.dart';
import 'package:food_donation/modules/home/widgets/donation_card_widget.dart';
import 'package:food_donation/modules/home/widgets/request_card_widget.dart';
import 'package:food_donation/modules/home/widgets/action_card_widget.dart';
import 'home_viewmodel.dart';

class HomeView extends GetView<HomeViewModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Donation'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => Get.toNamed(AppRoutes.PROFILE),
          ),
        ],
      ),
      body: Obx(() => controller.isLoading.value
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: controller.refreshData,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWelcomeSection(),
                    SizedBox(height: 20),
                    _buildActionButtons(),
                    SizedBox(height: 20),
                    _buildRecentDonationsSection(),
                    SizedBox(height: 20),
                    _buildRecentRequestsSection(),
                  ],
                ),
              ),
            )),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green, Colors.green.shade300],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back, ${controller.userName}!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Share food, spread happiness',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          if (controller.stats.isNotEmpty) ...[
            SizedBox(height: 12),
            Text(
              controller.userType == 'donor'
                  ? 'Total Donations: ${controller.stats['totalDonations'] ?? 0}'
                  : 'Total Requests: ${controller.stats['totalRequests'] ?? 0}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ActionCardWidget(
            title: 'Donate Food',
            icon: Icons.volunteer_activism,
            color: Colors.orange,
            onTap: () => Get.toNamed(AppRoutes.DONATE_FOOD),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: ActionCardWidget(
            title: 'Request Food',
            icon: Icons.food_bank,
            color: Colors.blue,
            onTap: () => Get.toNamed(AppRoutes.REQUEST_FOOD),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentDonationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Donations',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        controller.recentDonations.isEmpty
            ? _buildEmptyState('No recent donations')
            : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: controller.recentDonations.length,
                itemBuilder: (context, index) {
                  return DonationCardWidget(
                    donation: controller.recentDonations[index],
                  );
                },
              ),
      ],
    );
  }

  Widget _buildRecentRequestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Requests',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        controller.recentRequests.isEmpty
            ? _buildEmptyState('No recent requests')
            : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: controller.recentRequests.length,
                itemBuilder: (context, index) {
                  return RequestCardWidget(
                    request: controller.recentRequests[index],
                  );
                },
              ),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            Icons.inbox,
            size: 60,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
