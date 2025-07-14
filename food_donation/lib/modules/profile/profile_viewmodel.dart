import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:food_donation/core/services/auth_service.dart';
import 'package:food_donation/data/repositories/auth_repository.dart';
import 'package:food_donation/data/models/user_model.dart';
import 'package:food_donation/routes/app_routes.dart';

class ProfileViewModel extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final AuthRepository _authRepository = AuthRepository();

  // Observable variables
  final isLoading = false.obs;
  final user = Rxn<UserModel>();

  // Controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final organizationNameController = TextEditingController();
  final registrationNumberController = TextEditingController();

  // Getters
  String get userInitial =>
      user.value?.name.substring(0, 1).toUpperCase() ?? 'U';
  String get userName => user.value?.name ?? '';
  String get userType => user.value?.userType.toUpperCase() ?? '';
  bool get isNGO => user.value?.userType == 'ngo';

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    try {
      isLoading.value = true;

      user.value = _authService.currentUser;
      _populateFormFields();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void _populateFormFields() {
    if (user.value != null) {
      nameController.text = user.value!.name;
      phoneController.text = user.value!.phone;
      addressController.text = user.value!.address ?? '';
      organizationNameController.text = user.value!.organizationName ?? '';
      registrationNumberController.text = user.value!.registrationNumber ?? '';
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

      if (isNGO) {
        updateData['organizationName'] = organizationNameController.text.trim();
        updateData['registrationNumber'] =
            registrationNumberController.text.trim();
      }

      final response = await _authRepository.updateProfile(updateData);
      final updatedUser = UserModel.fromJson(response['user']);

      user.value = updatedUser;
      await _authService.updateUser(updatedUser);

      Get.snackbar('Success', 'Profile updated successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    Get.dialog(
      AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: Text('Logout'),
            onPressed: () async {
              Get.back();
              await _authService.logout();
              Get.offAllNamed(AppRoutes.LOGIN);
              Get.snackbar('Success', 'Logged out successfully');
            },
          ),
        ],
      ),
    );
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
