import 'package:flutter/material.dart';
import 'package:food_donation/core/services/api_service.dart';
import 'package:get/get.dart';

class RequestController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final formKey = GlobalKey<FormState>();
  final foodTypeController = TextEditingController();
  final descriptionController = TextEditingController();
  final quantityController = TextEditingController();
  final deliveryAddressController = TextEditingController();

  final isLoading = false.obs;
  final selectedUnit = 'kg'.obs;
  final selectedUrgency = 'medium'.obs;

  final units = ['kg', 'pieces', 'liters', 'packets', 'boxes'];
  final urgencyLevels = ['low', 'medium', 'high'];

  void setUnit(String unit) {
    selectedUnit.value = unit;
  }

  void setUrgency(String urgency) {
    selectedUrgency.value = urgency;
  }

  Future<void> createRequest() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      final requestData = {
        'foodType': foodTypeController.text.trim(),
        'description': descriptionController.text.trim(),
        'quantity': int.parse(quantityController.text),
        'unit': selectedUnit.value,
        'deliveryAddress': deliveryAddressController.text.trim(),
        'urgency': selectedUrgency.value,
      };

      await _apiService.post('/requests', requestData);

      Get.back();
      Get.snackbar('Success', 'Request created successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    foodTypeController.dispose();
    descriptionController.dispose();
    quantityController.dispose();
    deliveryAddressController.dispose();
    super.onClose();
  }
}
