import 'package:get/get.dart';
import 'donate_viewmodel.dart';

class DonateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DonateViewModel>(() => DonateViewModel());
  }
}
