import 'package:get/get.dart';
import 'package:food_donation/modules/splash/splash_binding.dart';
import 'package:food_donation/modules/splash/splash_view.dart';
import 'package:food_donation/modules/auth/auth_binding.dart';
import 'package:food_donation/modules/auth/login_view.dart';
import 'package:food_donation/modules/auth/register_view.dart';
import 'package:food_donation/modules/home/home_binding.dart';
import 'package:food_donation/modules/home/home_view.dart';
import 'package:food_donation/modules/donate/donate_binding.dart';
import 'package:food_donation/modules/donate/donate_view.dart';
import 'package:food_donation/modules/request/request_binding.dart';
import 'package:food_donation/modules/request/request_view.dart';
import 'package:food_donation/modules/profile/profile_binding.dart';
import 'package:food_donation/modules/profile/profile_view.dart';
import 'package:food_donation/routes/app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.REGISTER,
      page: () => RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.DONATE_FOOD,
      page: () => DonateView(),
      binding: DonateBinding(),
    ),
    GetPage(
      name: AppRoutes.REQUEST_FOOD,
      page: () => RequestView(),
      binding: RequestBinding(),
    ),
    GetPage(
      name: AppRoutes.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
  ];
}
