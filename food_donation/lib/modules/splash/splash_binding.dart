import 'package:get/get.dart';
import 'splash_viewmodel.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    print('SplashBinding.dependencies called');
    // Use Get.put instead of Get.lazyPut to ensure immediate instantiation
    Get.put<SplashViewModel>(SplashViewModel());
  }
}
