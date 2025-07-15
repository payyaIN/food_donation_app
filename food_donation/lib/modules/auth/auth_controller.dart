import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:food_donation/core/services/api_service.dart'; // FIXED: Changed from data/services
import 'package:food_donation/data/models/user_model.dart';
import 'package:food_donation/routes/app_routes.dart';

class AuthController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final organizationNameController = TextEditingController();
  final registrationNumberController = TextEditingController();

  final isLoading = false.obs;
  final selectedUserType = 'donor'.obs;
  final obscurePassword = true.obs;

  final userTypes = ['donor', 'ngo', 'recipient'];

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void setUserType(String type) {
    selectedUserType.value = type;
  }

  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      final response = await _apiService.post('/auth/login', {
        'email': emailController.text.trim(),
        'password': passwordController.text,
      });

      _apiService.setToken(response['token']);
      Get.offAllNamed(AppRoutes.HOME);
      Get.snackbar('Success', 'Login successful');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    if (!registerFormKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      final userData = {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'password': passwordController.text,
        'phone': phoneController.text.trim(),
        'userType': selectedUserType.value,
        'address': addressController.text.trim(),
      };

      if (selectedUserType.value == 'ngo') {
        userData['organizationName'] = organizationNameController.text.trim();
        userData['registrationNumber'] =
            registrationNumberController.text.trim();
      }

      final response = await _apiService.post('/auth/register', userData);

      _apiService.setToken(response['token']);
      Get.offAllNamed(AppRoutes.HOME);
      Get.snackbar('Success', 'Registration successful');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    organizationNameController.dispose();
    registrationNumberController.dispose();
    super.onClose();
  }
}
