import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:food_donation/data/services/api_service.dart';
import 'package:food_donation/data/models/donation_model.dart';

class DonateController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final formKey = GlobalKey<FormState>();
  final foodTypeController = TextEditingController();
  final descriptionController = TextEditingController();
  final quantityController = TextEditingController();
  final pickupAddressController = TextEditingController();

  final isLoading = false.obs;
  final selectedUnit = 'kg'.obs;
  final selectedExpiryDate = DateTime.now().add(Duration(days: 1)).obs;

  final units = ['kg', 'pieces', 'liters', 'packets', 'boxes'];

  void setUnit(String unit) {
    selectedUnit.value = unit;
  }

  void setExpiryDate(DateTime date) {
    selectedExpiryDate.value = date;
  }

  Future<void> selectExpiryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedExpiryDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      setExpiryDate(picked);
    }
  }

  Future<void> createDonation() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      final donationData = {
        'foodType': foodTypeController.text.trim(),
        'description': descriptionController.text.trim(),
        'quantity': int.parse(quantityController.text),
        'unit': selectedUnit.value,
        'expiryDate': selectedExpiryDate.value.toIso8601String(),
        'pickupAddress': pickupAddressController.text.trim(),
      };

      await _apiService.post('/donations', donationData);

      Get.back();
      Get.snackbar('Success', 'Donation created successfully');
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
    pickupAddressController.dispose();
    super.onClose();
  }
}
