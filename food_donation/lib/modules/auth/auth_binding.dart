import 'package:food_donation/modules/auth/auth_controller.dart';
import 'package:get/get.dart';
import 'auth_viewmodel.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<AuthViewModel>(() => AuthViewModel());
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
