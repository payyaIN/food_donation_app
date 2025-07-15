import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'splash_viewmodel.dart';

class SplashView extends GetView<SplashViewModel> {
  @override
  Widget build(BuildContext context) {
    print('SplashView.build called');

    // Ensure the controller is instantiated
    Get.find<SplashViewModel>();

    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.food_bank,
              size: 100,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              'Food Donation App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Share Food, Share Love',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 50),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            SizedBox(height: 20),
            Obx(() => Text(
                  controller.initializationStatus.value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                )),
            SizedBox(height: 20),
            // Add a debug button to manually trigger navigation
            if (Get.isDarkMode) // Only show in debug mode
              ElevatedButton(
                onPressed: () => controller.forceNavigation(),
                child: Text('Force Navigation'),
              ),
          ],
        ),
      ),
    );
  }
}
