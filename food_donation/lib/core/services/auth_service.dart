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
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    try {
      await _loadUserFromStorage();
      _isInitialized.value = true;
      print('Auth service initialized. Logged in: $_isLoggedIn');
    } catch (e) {
      print('Auth initialization error: $e');
      _isInitialized.value = true;
    }
  }

  Future<void> _loadUserFromStorage() async {
    try {
      final token = _storageService.token;
      final userData = _storageService.userData;

      print('Stored token: ${token.isNotEmpty ? "exists" : "empty"}');
      print('Stored user data: ${userData.isNotEmpty ? "exists" : "empty"}');

      if (token.isNotEmpty && userData.isNotEmpty) {
        _currentUser.value = UserModel.fromJson(json.decode(userData));
        _apiService.setToken(token);
        _isLoggedIn.value = true;
        print('User loaded from storage: ${_currentUser.value?.name}');
      } else {
        print('No stored user data found');
        _isLoggedIn.value = false;
      }
    } catch (e) {
      print('Error loading user from storage: $e');
      await logout();
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await _apiService.post('/auth/login', {
        'email': email,
        'password': password,
      });

      final user = UserModel.fromJson(response['user']);
      final token = response['token'];

      await _saveUserData(user, token);
      print('Login successful: ${user.name}');
    } catch (e) {
      print('Login error: $e');
      throw e;
    }
  }

  Future<void> register(Map<String, dynamic> userData) async {
    try {
      final response = await _apiService.post('/auth/register', userData);

      final user = UserModel.fromJson(response['user']);
      final token = response['token'];

      await _saveUserData(user, token);
      print('Registration successful: ${user.name}');
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
}
