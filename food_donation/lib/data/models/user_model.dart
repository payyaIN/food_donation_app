class UserModel {
  String? id;
  String name;
  String email;
  String phone;
  String userType; // 'donor', 'ngo', 'recipient'
  String? address;
  String? organizationName;
  String? registrationNumber;
  DateTime createdAt;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
    this.address,
    this.organizationName,
    this.registrationNumber,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      userType: json['userType'],
      address: json['address'],
      organizationName: json['organizationName'],
      registrationNumber: json['registrationNumber'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'userType': userType,
      'address': address,
      'organizationName': organizationName,
      'registrationNumber': registrationNumber,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
