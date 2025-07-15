import 'package:food_donation/core/services/auth_service.dart';
import 'package:food_donation/core/services/api_service.dart';
import 'package:food_donation/routes/app_routes.dart';
import 'package:get/get.dart';

class SplashViewModel extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final ApiService _apiService = Get.find<ApiService>();

  final initializationStatus = 'Initializing...'.obs;

  @override
  void onInit() {
    super.onInit();
    print('✅ SplashViewModel.onInit called');
    initializationStatus.value = 'Initializing...';
    _initializeApp();
  }

  @override
  void onReady() {
    super.onReady();
    print('✅ SplashViewModel.onReady called');
  }

  Future<void> _initializeApp() async {
    try {
      print('✅ SplashViewModel._initializeApp called');

      // Update status
      initializationStatus.value = 'Checking connection...';

      // Wait for minimum splash duration
      await Future.delayed(Duration(seconds: 1));

      // Check server connection first
      initializationStatus.value = 'Connecting to server...';
      bool serverConnected = await _checkServerConnection();

      if (!serverConnected) {
        print('⚠️ Server not connected, proceeding offline');
        initializationStatus.value = 'Proceeding offline...';
        await Future.delayed(Duration(seconds: 1));
        _navigateToLogin();
        return;
      }

      // Check authentication status
      initializationStatus.value = 'Checking authentication...';
      await _checkAuthStatus();
    } catch (e) {
      print('❌ Splash initialization error: $e');
      initializationStatus.value = 'Error occurred, redirecting...';
      await Future.delayed(Duration(seconds: 1));
      _navigateToLogin();
    }
  }

  Future<bool> _checkServerConnection() async {
    try {
      print('🔍 Checking server connection...');
      bool connected = await _apiService.checkConnection();
      print('📡 Server connection status: $connected');
      return connected;
    } catch (e) {
      print('❌ Server connection check failed: $e');
      return false;
    }
  }

  Future<void> _checkAuthStatus() async {
    try {
      print('🔐 SplashViewModel._checkAuthStatus called');

      // Wait for AuthService to be fully initialized
      int maxWaitTime = 50; // 5 seconds max
      int waitCount = 0;

      while (!_authService.isInitialized && waitCount < maxWaitTime) {
        await Future.delayed(Duration(milliseconds: 100));
        waitCount++;
      }

      if (!_authService.isInitialized) {
        print('⚠️ AuthService initialization timeout');
        _navigateToLogin();
        return;
      }

      if (_authService.isLoggedIn && _authService.currentUser != null) {
        print('✅ User is logged in: ${_authService.currentUser?.name}');
        initializationStatus.value = 'Welcome back!';
        await Future.delayed(Duration(milliseconds: 500));
        _navigateToHome();
      } else {
        print('ℹ️ User is not logged in');
        initializationStatus.value = 'Please login';
        await Future.delayed(Duration(milliseconds: 500));
        _navigateToLogin();
      }
    } catch (e) {
      print('❌ Auth check error: $e');
      initializationStatus.value = 'Authentication error';
      await Future.delayed(Duration(seconds: 1));
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    try {
      print('🚀 Navigating to LOGIN');
      Get.offAllNamed(AppRoutes.LOGIN);
    } catch (e) {
      print('❌ Navigation to LOGIN failed: $e');
      // Fallback navigation
      Get.offAndToNamed(AppRoutes.LOGIN);
    }
  }

  void _navigateToHome() {
    try {
      print('🚀 Navigating to HOME');
      Get.offAllNamed(AppRoutes.HOME);
    } catch (e) {
      print('❌ Navigation to HOME failed: $e');
      // Fallback to login
      _navigateToLogin();
    }
  }

  // Debug method to force navigation
  void forceNavigation() {
    print('🔧 Force navigation triggered');
    _navigateToLogin();
  }

  // Manual retry method
  void retryInitialization() {
    print('🔄 Retrying initialization...');
    initializationStatus.value = 'Retrying...';
    _initializeApp();
  }
}
