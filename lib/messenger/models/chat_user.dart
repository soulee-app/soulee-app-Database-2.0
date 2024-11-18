import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUser {
  ChatUser({
    required this.image,
    required this.name,
    required this.createdAt,
    this.gender, // Optional field
    required this.isOnline, // Required field
    this.mobile, // Optional field
    required this.email,
    required this.pushToken,
    required this.lastActive,
    this.password, // Optional field
    required this.id,
    required this.about, // Required field
  });

  late String image; // imageurl from Firestore
  late String name; // name from Firestore
  late String createdAt; // createdAt field as a String
  String? gender; // Optional field for gender
  String? mobile; // Optional field for mobile
  late bool isOnline; // Required field for online status
  late String email; // email from Firestore
  late String pushToken; // push_token from Firestore
  late String lastActive; // last_active from Firestore
  String? password; // Optional field for password
  late String id; // id field
  late String about; // about field

  ChatUser.fromJson(Map<String, dynamic> json) {
    image = json['imageurl'] ?? ''; // Corrected to match Firestore field
    name = json['name'] ?? '';

    // Convert Timestamp to String
    if (json['dof'] is Timestamp) {
      createdAt = (json['dof'] as Timestamp)
          .toDate()
          .toIso8601String(); // Convert to String
    } else {
      createdAt = json['dof'] ?? ''; // Fallback in case it's not a Timestamp
    }

    gender = json['gender']; // Optional
    mobile = json['mobile']?.toString(); // Convert to String if not null
    isOnline = json['is_online'] ?? false; // Ensure it's a bool
    email = json['email'] ?? '';
    pushToken = json['push_token'] ?? '';
    lastActive = json['last_active'] ?? ''; // Added last_active
    password = json['password']; // Optional
    id = json['id'] ?? ''; // Added id
    about = json['about'] ?? ''; // Added about
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['imageurl'] = image; // Corrected to match Firestore field
    data['name'] = name;
    data['dof'] = createdAt; // Store as String or Timestamp
    data['gender'] = gender; // Optional
    data['is_online'] = isOnline; // Ensure isOnline is included
    data['mobile'] = mobile != null
        ? int.tryParse(mobile!)
        : null; // Convert back to int if not null
    data['email'] = email;
    data['push_token'] = pushToken;
    data['last_active'] = lastActive; // Added last_active
    data['password'] = password; // Optional
    data['id'] = id; // Added id
    data['about'] = about; // Added about
    return data;
  }
}
