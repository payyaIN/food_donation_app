import 'package:get/get.dart';
import 'package:food_donation/data/services/api_service.dart';
import 'package:food_donation/data/models/donation_model.dart';
import 'package:food_donation/data/models/request_model.dart';

class HomeController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final isLoading = false.obs;
  final recentDonations = <DonationModel>[].obs;
  final recentRequests = <RequestModel>[].obs;
  final stats = {}.obs;

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    try {
      isLoading.value = true;

      // Load recent donations
      final donationsResponse = await _apiService.get('/donations?limit=5');
      recentDonations.value = (donationsResponse['donations'] as List)
          .map((json) => DonationModel.fromJson(json))
          .toList();

      // Load recent requests
      final requestsResponse = await _apiService.get('/requests?limit=5');
      recentRequests.value = (requestsResponse['requests'] as List)
          .map((json) => RequestModel.fromJson(json))
          .toList();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await loadHomeData();
  }
}
