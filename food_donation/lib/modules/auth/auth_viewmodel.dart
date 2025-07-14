import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:food_donation/core/services/auth_service.dart';
import 'package:food_donation/data/repositories/auth_repository.dart';
import 'package:food_donation/routes/app_routes.dart';

class AuthViewModel extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final AuthRepository _authRepository = AuthRepository();

  // Form keys
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();

  // Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final organizationNameController = TextEditingController();
  final registrationNumberController = TextEditingController();

  // Observable variables
  final isLoading = false.obs;
  final selectedUserType = 'donor'.obs;
  final obscurePassword = true.obs;

  // Constants
  final userTypes = ['donor', 'ngo', 'recipient'];

  // Methods
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

      await _authService.login(
        emailController.text.trim(),
        passwordController.text,
      );

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

      await _authService.register(userData);

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
