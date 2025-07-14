import 'package:flutter/material.dart';
import 'package:food_donation/modules/auth/login_view.dart';
import 'package:food_donation/modules/auth/register_view.dart';
import 'package:food_donation/modules/home/home_view.dart';
import 'package:food_donation/modules/profile/profile_view.dart';
import 'package:get/get.dart';
import 'package:food_donation/routes/app_pages.dart';
import 'package:food_donation/routes/app_routes.dart';
import 'package:food_donation/core/services/api_service.dart';
import 'package:food_donation/core/services/storage_service.dart';
import 'package:food_donation/core/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await initServices();
    runApp(MyApp());
  } catch (e) {
    print('App initialization error: $e');
    runApp(ErrorApp());
  }
}

Future<void> initServices() async {
  try {
    print('Initializing services...');

    // Initialize storage service first
    await Get.putAsync(() => StorageService().init());
    print('StorageService initialized');

    // Initialize API service
    Get.put(ApiService());
    print('ApiService initialized');

    // Initialize auth service
    Get.put(AuthService());
    print('AuthService initialized');

    print('All services initialized successfully');
  } catch (e) {
    print('Service initialization error: $e');
    rethrow;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Food Donation App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: AppRoutes.SPLASH,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

class ErrorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'App Initialization Failed',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Please restart the app'),
            ],
          ),
        ),
      ),
    );
  }
}
