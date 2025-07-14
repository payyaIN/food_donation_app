import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<StorageService> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
      print('StorageService initialized successfully');
      return this;
    } catch (e) {
      print('StorageService initialization error: $e');
      rethrow;
    }
  }

  // Token management
  String get token {
    if (!_isInitialized) {
      print('Warning: StorageService not initialized');
      return '';
    }
    return _prefs.getString('auth_token') ?? '';
  }

  Future<bool> setToken(String token) async {
    if (!_isInitialized) return false;
    try {
      return await _prefs.setString('auth_token', token);
    } catch (e) {
      print('Error setting token: $e');
      return false;
    }
  }

  Future<bool> removeToken() async {
    if (!_isInitialized) return false;
    try {
      return await _prefs.remove('auth_token');
    } catch (e) {
      print('Error removing token: $e');
      return false;
    }
  }

  // User data
  String get userData {
    if (!_isInitialized) {
      print('Warning: StorageService not initialized');
      return '';
    }
    return _prefs.getString('user_data') ?? '';
  }

  Future<bool> setUserData(String userData) async {
    if (!_isInitialized) return false;
    try {
      return await _prefs.setString('user_data', userData);
    } catch (e) {
      print('Error setting user data: $e');
      return false;
    }
  }

  Future<bool> removeUserData() async {
    if (!_isInitialized) return false;
    try {
      return await _prefs.remove('user_data');
    } catch (e) {
      print('Error removing user data: $e');
      return false;
    }
  }

  // App settings
  bool get isFirstTime {
    if (!_isInitialized) return true;
    return _prefs.getBool('is_first_time') ?? true;
  }

  Future<bool> setFirstTime(bool value) async {
    if (!_isInitialized) return false;
    try {
      return await _prefs.setBool('is_first_time', value);
    } catch (e) {
      print('Error setting first time: $e');
      return false;
    }
  }
}
