import 'dart:convert';

class User {
  int? userId;
  String userName;
  String password;
  String email;
  String userType;

  User({
    this.userId,
    required this.userName,
    required this.password,
    required this.email,
    required this.userType,
  });

  // Convert User to Map for SQLite storage
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'password': password,
      'email': email,
      'userType': userType,
    };
  }

  // Create a User object from a Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['userId'],
      userName: map['userName'],
      password: map['password'],
      email: map['email'],
      userType: map['userType'],
    );
  }

  // Convert User to JSON
  String toJson() => json.encode(toMap());

  // Create a User object from JSON
  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}

class Admin extends User {
  int? adminId;
  String adminName;
  int membershipID; // Only for Admin

  Admin({
    this.adminId,
    required this.adminName,
    required this.membershipID,
    required super.userName,
    required super.password,
    required super.email,
  }) : super(userType: "Admin");

  // Convert Admin to Map
  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map['adminId'] = adminId;
    map['adminName'] = adminName;
    map['membershipID'] = membershipID; // Store membershipID
    return map;
  }

  // Create an Admin from Map
  factory Admin.fromMap(Map<String, dynamic> map) {
    return Admin(
      adminId: map['adminId'],
      adminName: map['adminName'],
      membershipID: map['membershipID'],
      userName: map['userName'],
      password: map['password'],
      email: map['email'],
    );
  }
}

class BusinessOwner extends User {
  int? businessId;
  String businessName;
  int membershipID; // Only for BusinessOwner

  BusinessOwner({
    this.businessId,
    required this.businessName,
    required this.membershipID,
    required super.userName,
    required super.password,
    required super.email,
  }) : super(userType: "BusinessOwner");

  // Convert BusinessOwner to Map
  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map['businessId'] = businessId;
    map['businessName'] = businessName;
    map['membershipID'] = membershipID; // Store membershipID
    return map;
  }

  // Create a BusinessOwner from Map
  factory BusinessOwner.fromMap(Map<String, dynamic> map) {
    return BusinessOwner(
      businessId: map['businessId'],
      businessName: map['businessName'],
      membershipID: map['membershipID'],
      userName: map['userName'],
      password: map['password'],
      email: map['email'],
    );
  }
}

class Customer extends User {
  int? customerId;
  String customerName;
  String location;

  Customer({
    this.customerId,
    required this.customerName,
    required this.location,
    required super.userName,
    required super.password,
    required super.email,
  }) : super(userType: "Customer");

  // Convert Customer to Map
  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map['customerId'] = customerId;
    map['customerName'] = customerName;
    map['location'] = location;
    return map;
  }

  // Create a Customer from Map
  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      customerId: map['customerId'],
      customerName: map['customerName'],
      location: map['location'],
      userName: map['userName'],
      password: map['password'],
      email: map['email'],
    );
  }
}
