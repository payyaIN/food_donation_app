class RequestModel {
  String? id;
  String requesterId;
  String foodType;
  String description;
  int quantity;
  String unit;
  String deliveryAddress;
  String urgency; // 'low', 'medium', 'high'
  String status; // 'pending', 'fulfilled', 'cancelled'
  String? fulfilledBy;
  DateTime createdAt;

  RequestModel({
    this.id,
    required this.requesterId,
    required this.foodType,
    required this.description,
    required this.quantity,
    required this.unit,
    required this.deliveryAddress,
    required this.urgency,
    this.status = 'pending',
    this.fulfilledBy,
    required this.createdAt,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['_id'],
      requesterId: json['requesterId'],
      foodType: json['foodType'],
      description: json['description'],
      quantity: json['quantity'],
      unit: json['unit'],
      deliveryAddress: json['deliveryAddress'],
      urgency: json['urgency'],
      status: json['status'],
      fulfilledBy: json['fulfilledBy'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requesterId': requesterId,
      'foodType': foodType,
      'description': description,
      'quantity': quantity,
      'unit': unit,
      'deliveryAddress': deliveryAddress,
      'urgency': urgency,
      'status': status,
      'fulfilledBy': fulfilledBy,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
