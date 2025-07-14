import 'package:food_donation/core/services/auth_service.dart';
import 'package:food_donation/routes/app_routes.dart';
import 'package:get/get.dart';

class SplashViewModel extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();
    print('SplashViewModel.onInit called');
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      print('SplashViewModel._initializeApp called');
      await Future.delayed(Duration(seconds: 2));
      await _checkAuthStatus();
    } catch (e) {
      print('Splash initialization error: $e');
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }

  Future<void> _checkAuthStatus() async {
    try {
      print('SplashViewModel._checkAuthStatus called');
      if (_authService.isLoggedIn && _authService.currentUser != null) {
        print('User is logged in: ${_authService.currentUser?.name}');
        Get.offAllNamed(AppRoutes.HOME);
      } else {
        print('User is not logged in');
        Get.offAllNamed(AppRoutes.LOGIN);
      }
    } catch (e) {
      print('Auth check error: $e');
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }
}
