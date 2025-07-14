import 'package:food_donation/core/services/api_service.dart';
import 'package:get/get.dart';

class RequestRepository {
  final ApiService _apiService = Get.find<ApiService>();

  Future<Map<String, dynamic>> createRequest(
      Map<String, dynamic> requestData) async {
    return await _apiService.post('/requests', requestData);
  }

  Future<Map<String, dynamic>> getRequests({
    int page = 1,
    int limit = 10,
    String? foodType,
    String? urgency,
    String status = 'pending',
  }) async {
    String query = '?page=$page&limit=$limit&status=$status';
    if (foodType != null && foodType.isNotEmpty) {
      query += '&foodType=$foodType';
    }
    if (urgency != null && urgency.isNotEmpty) {
      query += '&urgency=$urgency';
    }
    return await _apiService.get('/requests$query');
  }

  Future<Map<String, dynamic>> getMyRequests() async {
    return await _apiService.get('/requests/my-requests');
  }

  Future<Map<String, dynamic>> getRequestById(String id) async {
    return await _apiService.get('/requests/$id');
  }

  Future<Map<String, dynamic>> fulfillRequest(String id) async {
    return await _apiService.put('/requests/$id/fulfill', {});
  }

  Future<Map<String, dynamic>> updateRequest(
      String id, Map<String, dynamic> data) async {
    return await _apiService.put('/requests/$id', data);
  }

  Future<Map<String, dynamic>> cancelRequest(String id) async {
    return await _apiService.put('/requests/$id/cancel', {});
  }

  Future<Map<String, dynamic>> deleteRequest(String id) async {
    return await _apiService.delete('/requests/$id');
  }
}
