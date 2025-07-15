import 'dart:convert';
import 'package:food_donation/core/services/api_service.dart';
import 'package:food_donation/core/services/storage_service.dart';
import 'package:food_donation/data/models/user_model.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  final StorageService _storageService = Get.find<StorageService>();
  final ApiService _apiService = Get.find<ApiService>();

  final _currentUser = Rxn<UserModel>();
  final _isLoggedIn = false.obs;
  final _isInitialized = false.obs;

  UserModel? get currentUser => _currentUser.value;
  bool get isLoggedIn => _isLoggedIn.value;
  bool get isInitialized => _isInitialized.value;

  @override
  void onInit() {
    super.onInit();
    print('AuthService.onInit called');
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    try {
      print('AuthService._initializeAuth called');
      await _loadUserFromStorage();
      _isInitialized.value = true;
      print('Auth service initialized. Logged in: ${_isLoggedIn.value}');
    } catch (e) {
      print('Auth initialization error: $e');
      _isInitialized.value = true;
      _isLoggedIn.value = false;
    }
  }

  Future<void> _loadUserFromStorage() async {
    try {
      final token = _storageService.token;
      final userData = _storageService.userData;

      print('Stored token: ${token.isNotEmpty ? "exists" : "empty"}');
      print('Stored user data: ${userData.isNotEmpty ? "exists" : "empty"}');

      if (token.isNotEmpty && userData.isNotEmpty) {
        try {
          final userMap = json.decode(userData);
          _currentUser.value = UserModel.fromJson(userMap);
          _apiService.setToken(token);

          // Verify token is still valid by checking with server
          await _verifyTokenValidity();
        } catch (e) {
          print('Error parsing stored user data: $e');
          await _clearStoredData();
        }
      } else {
        print('No stored user data found');
        _isLoggedIn.value = false;
      }
    } catch (e) {
      print('Error loading user from storage: $e');
      await _clearStoredData();
    }
  }

  Future<void> _verifyTokenValidity() async {
    try {
      // Try to get current user from server to verify token
      final response = await _apiService.get('/auth/me');

      if (response['user'] != null) {
        _currentUser.value = UserModel.fromJson(response['user']);
        _isLoggedIn.value = true;
        print('Token verified successfully: ${_currentUser.value?.name}');
      } else {
        await _clearStoredData();
      }
    } catch (e) {
      print('Token verification failed: $e');
      await _clearStoredData();
    }
  }

  Future<void> _clearStoredData() async {
    try {
      _currentUser.value = null;
      _isLoggedIn.value = false;
      await _storageService.removeToken();
      await _storageService.removeUserData();
      _apiService.setToken('');
      print('Stored data cleared');
    } catch (e) {
      print('Error clearing stored data: $e');
    }
  }

  Future<void> login(String email, String password) async {
    try {
      print('AuthService.login called for: $email');

      final response = await _apiService.post('/auth/login', {
        'email': email,
        'password': password,
      });

      if (response['user'] != null && response['token'] != null) {
        final user = UserModel.fromJson(response['user']);
        final token = response['token'];

        await _saveUserData(user, token);
        print('Login successful: ${user.name}');
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      print('Login error: $e');
      throw e;
    }
  }

  Future<void> register(Map<String, dynamic> userData) async {
    try {
      print('AuthService.register called for: ${userData['email']}');

      final response = await _apiService.post('/auth/register', userData);

      if (response['user'] != null && response['token'] != null) {
        final user = UserModel.fromJson(response['user']);
        final token = response['token'];

        await _saveUserData(user, token);
        print('Registration successful: ${user.name}');
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      print('Registration error: $e');
      throw e;
    }
  }

  Future<void> _saveUserData(UserModel user, String token) async {
    try {
      _currentUser.value = user;
      _isLoggedIn.value = true;

      await _storageService.setToken(token);
      await _storageService.setUserData(json.encode(user.toJson()));
      _apiService.setToken(token);

      print('User data saved successfully');
    } catch (e) {
      print('Error saving user data: $e');
      throw e;
    }
  }

  Future<void> logout() async {
    try {
      print('AuthService.logout called');

      _currentUser.value = null;
      _isLoggedIn.value = false;

      await _storageService.removeToken();
      await _storageService.removeUserData();
      _apiService.setToken('');

      print('Logout successful');
    } catch (e) {
      print('Logout error: $e');
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      _currentUser.value = user;
      await _storageService.setUserData(json.encode(user.toJson()));
      print('User updated successfully');
    } catch (e) {
      print('Error updating user: $e');
    }
  }

  // Method to refresh user data from server
  Future<void> refreshUserData() async {
    try {
      if (_isLoggedIn.value) {
        final response = await _apiService.get('/auth/me');
        if (response['user'] != null) {
          final user = UserModel.fromJson(response['user']);
          await updateUser(user);
        }
      }
    } catch (e) {
      print('Error refreshing user data: $e');
    }
  }
}
