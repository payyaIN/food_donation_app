import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:food_donation/routes/app_pages.dart';
import 'package:food_donation/routes/app_routes.dart';
import 'package:food_donation/core/services/api_service.dart';
import 'package:food_donation/core/services/storage_service.dart';
import 'package:food_donation/core/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    print('🚀 Starting app initialization...');
    await initServices();
    print('✅ All services initialized successfully');
    runApp(MyApp());
  } catch (e) {
    print('❌ App initialization error: $e');
    runApp(ErrorApp(error: e.toString()));
  }
}

Future<void> initServices() async {
  try {
    print('🔧 Initializing services...');

    // Initialize storage service first (required by other services)
    print('📦 Initializing StorageService...');
    await Get.putAsync(() => StorageService().init());
    print('✅ StorageService initialized successfully');

    // Initialize API service
    print('🌐 Initializing ApiService...');
    Get.put(ApiService());
    print('✅ ApiService initialized successfully');

    // Initialize auth service (depends on storage and api services)
    print('🔐 Initializing AuthService...');
    Get.put(AuthService());
    print('✅ AuthService initialized successfully');

    print('🎉 All services initialized successfully');
  } catch (e) {
    print('❌ Service initialization error: $e');
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
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      initialRoute: AppRoutes.SPLASH,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fade,
      transitionDuration: Duration(milliseconds: 300),
    );
  }
}

class ErrorApp extends StatelessWidget {
  final String error;

  const ErrorApp({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Donation App - Error',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        backgroundColor: Colors.red.shade50,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 80,
                    color: Colors.red,
                  ),
                  SizedBox(height: 24),
                  Text(
                    'App Initialization Failed',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Something went wrong during app startup',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade300),
                    ),
                    child: Text(
                      'Error Details:\n$error',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red.shade800,
                        fontFamily: 'monospace',
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Restart the app
                      main();
                    },
                    icon: Icon(Icons.refresh),
                    label: Text('Restart App'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'If this problem persists, please check:\n'
                    '• Your internet connection\n'
                    '• Backend server is running on port 3001\n'
                    '• Device/emulator network settings',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
