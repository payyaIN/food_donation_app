class DonationModel {
  String? id;
  String donorId;
  String foodType;
  String description;
  int quantity;
  String unit;
  DateTime expiryDate;
  String pickupAddress;
  String status; // 'available', 'requested', 'completed'
  String? requestedBy;
  DateTime createdAt;
  List<String> images;

  DonationModel({
    this.id,
    required this.donorId,
    required this.foodType,
    required this.description,
    required this.quantity,
    required this.unit,
    required this.expiryDate,
    required this.pickupAddress,
    this.status = 'available',
    this.requestedBy,
    required this.createdAt,
    this.images = const [],
  });

  factory DonationModel.fromJson(Map<String, dynamic> json) {
    return DonationModel(
      id: json['_id'],
      donorId: json['donorId'],
      foodType: json['foodType'],
      description: json['description'],
      quantity: json['quantity'],
      unit: json['unit'],
      expiryDate: DateTime.parse(json['expiryDate']),
      pickupAddress: json['pickupAddress'],
      status: json['status'],
      requestedBy: json['requestedBy'],
      createdAt: DateTime.parse(json['createdAt']),
      images: List<String>.from(json['images'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'donorId': donorId,
      'foodType': foodType,
      'description': description,
      'quantity': quantity,
      'unit': unit,
      'expiryDate': expiryDate.toIso8601String(),
      'pickupAddress': pickupAddress,
      'status': status,
      'requestedBy': requestedBy,
      'createdAt': createdAt.toIso8601String(),
      'images': images,
    };
  }
}
