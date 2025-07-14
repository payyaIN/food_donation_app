import 'package:get/get.dart';
import 'package:food_donation/data/repositories/donation_repository.dart';
import 'package:food_donation/data/repositories/request_repository.dart';
import 'package:food_donation/data/models/donation_model.dart';
import 'package:food_donation/data/models/request_model.dart';
import 'package:food_donation/core/services/auth_service.dart';

class HomeViewModel extends GetxController {
  final DonationRepository _donationRepository = DonationRepository();
  final RequestRepository _requestRepository = RequestRepository();
  final AuthService _authService = Get.find<AuthService>();

  // Observable variables
  final isLoading = false.obs;
  final recentDonations = <DonationModel>[].obs;
  final recentRequests = <RequestModel>[].obs;
  final stats = <String, int>{}.obs;

  // Getters
  String get userName => _authService.currentUser?.name ?? 'User';
  String get userType => _authService.currentUser?.userType ?? 'donor';

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    try {
      isLoading.value = true;

      await Future.wait([
        _loadRecentDonations(),
        _loadRecentRequests(),
        _loadStats(),
      ]);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load data: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadRecentDonations() async {
    try {
      final response = await _donationRepository.getDonations(limit: 5);
      recentDonations.value = (response['donations'] as List)
          .map((json) => DonationModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error loading donations: $e');
    }
  }

  Future<void> _loadRecentRequests() async {
    try {
      final response = await _requestRepository.getRequests(limit: 5);
      recentRequests.value = (response['requests'] as List)
          .map((json) => RequestModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error loading requests: $e');
    }
  }

  Future<void> _loadStats() async {
    try {
      // Load statistics based on user type
      if (userType == 'donor') {
        final myDonations = await _donationRepository.getMyDonations();
        stats['totalDonations'] = (myDonations['donations'] as List).length;
      } else {
        final myRequests = await _requestRepository.getMyRequests();
        stats['totalRequests'] = (myRequests['requests'] as List).length;
      }
    } catch (e) {
      print('Error loading stats: $e');
    }
  }

  Future<void> refreshData() async {
    await loadHomeData();
  }
}
