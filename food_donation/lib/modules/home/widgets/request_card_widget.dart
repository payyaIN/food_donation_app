import 'package:flutter/material.dart';
import 'package:food_donation/data/models/request_model.dart';

class RequestCardWidget extends StatelessWidget {
  final RequestModel request;

  const RequestCardWidget({
    Key? key,
    required this.request,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.restaurant, color: Colors.white),
        ),
        title: Text(
          request.foodType,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(request.description),
            SizedBox(height: 4),
            Text(
              '${request.quantity} ${request.unit}',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getUrgencyColor(request.urgency),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            request.urgency.toUpperCase(),
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

  Color _getUrgencyColor(String urgency) {
    switch (urgency) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
