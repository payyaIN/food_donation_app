import 'package:food_donation/core/services/api_service.dart';
import 'package:get/get.dart';

class DonationRepository {
  final ApiService _apiService = Get.find<ApiService>();

  Future<Map<String, dynamic>> createDonation(
      Map<String, dynamic> donationData) async {
    return await _apiService.post('/donations', donationData);
  }

  Future<Map<String, dynamic>> getDonations({
    int page = 1,
    int limit = 10,
    String? foodType,
    String status = 'available',
  }) async {
    String query = '?page=$page&limit=$limit&status=$status';
    if (foodType != null && foodType.isNotEmpty) {
      query += '&foodType=$foodType';
    }
    return await _apiService.get('/donations$query');
  }

  Future<Map<String, dynamic>> getMyDonations() async {
    return await _apiService.get('/donations/my-donations');
  }

  Future<Map<String, dynamic>> getDonationById(String id) async {
    return await _apiService.get('/donations/$id');
  }

  Future<Map<String, dynamic>> requestDonation(String id) async {
    return await _apiService.put('/donations/$id/request', {});
  }

  Future<Map<String, dynamic>> completeDonation(String id) async {
    return await _apiService.put('/donations/$id/complete', {});
  }

  Future<Map<String, dynamic>> updateDonation(
      String id, Map<String, dynamic> data) async {
    return await _apiService.put('/donations/$id', data);
  }

  Future<Map<String, dynamic>> deleteDonation(String id) async {
    return await _apiService.delete('/donations/$id');
  }
}
