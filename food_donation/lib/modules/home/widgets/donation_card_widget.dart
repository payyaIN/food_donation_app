import 'package:flutter/material.dart';
import 'package:food_donation/data/models/donation_model.dart';

class DonationCardWidget extends StatelessWidget {
  final DonationModel donation;

  const DonationCardWidget({
    Key? key,
    required this.donation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(Icons.food_bank, color: Colors.white),
        ),
        title: Text(
          donation.foodType,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(donation.description),
            SizedBox(height: 4),
            Text(
              '${donation.quantity} ${donation.unit}',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getStatusColor(donation.status),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            donation.status.toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'available':
        return Colors.green;
      case 'requested':
        return Colors.orange;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
