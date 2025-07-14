import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:food_donation/data/services/api_service.dart';
import 'package:food_donation/data/models/user_model.dart';
import 'package:food_donation/routes/app_routes.dart';

class ProfileController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final isLoading = false.obs;
  final user = Rxn<UserModel>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final organizationNameController = TextEditingController();
  final registrationNumberController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    try {
      isLoading.value = true;

      final response = await _apiService.get('/users/profile');
      user.value = UserModel.fromJson(response['user']);

      // Populate form fields
      nameController.text = user.value?.name ?? '';
      phoneController.text = user.value?.phone ?? '';
      addressController.text = user.value?.address ?? '';
      organizationNameController.text = user.value?.organizationName ?? '';
      registrationNumberController.text = user.value?.registrationNumber ?? '';
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    try {
      isLoading.value = true;

      final updateData = {
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'address': addressController.text.trim(),
      };

      if (user.value?.userType == 'ngo') {
        updateData['organizationName'] = organizationNameController.text.trim();
        updateData['registrationNumber'] =
            registrationNumberController.text.trim();
      }

      final response = await _apiService.put('/users/profile', updateData);
      user.value = UserModel.fromJson(response['user']);

      Get.snackbar('Success', 'Profile updated successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    _apiService.setToken('');
    Get.offAllNamed(AppRoutes.LOGIN);
    Get.snackbar('Success', 'Logged out successfully');
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    organizationNameController.dispose();
    registrationNumberController.dispose();
    super.onClose();
  }
}
