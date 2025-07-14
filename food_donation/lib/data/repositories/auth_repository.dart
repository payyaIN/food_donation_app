import 'package:food_donation/core/services/api_service.dart';
import 'package:get/get.dart';

class AuthRepository {
  final ApiService _apiService = Get.find<ApiService>();

  Future<Map<String, dynamic>> login(String email, String password) async {
    return await _apiService.post('/auth/login', {
      'email': email,
      'password': password,
    });
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    return await _apiService.post('/auth/register', userData);
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    return await _apiService.get('/auth/me');
  }

  Future<Map<String, dynamic>> updateProfile(
      Map<String, dynamic> userData) async {
    return await _apiService.put('/users/profile', userData);
  }
}
