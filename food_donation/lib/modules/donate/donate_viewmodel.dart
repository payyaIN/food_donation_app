import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:food_donation/data/repositories/donation_repository.dart';

class DonateViewModel extends GetxController {
  final DonationRepository _donationRepository = DonationRepository();

  // Form key
  final formKey = GlobalKey<FormState>();

  // Controllers
  final foodTypeController = TextEditingController();
  final descriptionController = TextEditingController();
  final quantityController = TextEditingController();
  final pickupAddressController = TextEditingController();

  // Observable variables
  final isLoading = false.obs;
  final selectedUnit = 'kg'.obs;
  final selectedExpiryDate = DateTime.now().add(Duration(days: 1)).obs;

  // Constants
  final units = ['kg', 'pieces', 'liters', 'packets', 'boxes'];

  // Methods
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

      await _donationRepository.createDonation(donationData);

      Get.back();
      Get.snackbar('Success', 'Donation created successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  void clearForm() {
    foodTypeController.clear();
    descriptionController.clear();
    quantityController.clear();
    pickupAddressController.clear();
    selectedUnit.value = 'kg';
    selectedExpiryDate.value = DateTime.now().add(Duration(days: 1));
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
