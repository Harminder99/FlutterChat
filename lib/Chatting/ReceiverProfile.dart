import 'package:flutter/cupertino.dart';

class ReceiverProfile {
  final String name;
  final String email;
  final String id;
  final String photo;

  ReceiverProfile({
    required this.name,
    required this.id,
    required this.photo,
    required this.email,
  });

  factory ReceiverProfile.fromJson(Map<String, dynamic> json) {
    return ReceiverProfile(
        name: json['name']?.toString() ?? "",
        id: json['id']?.toString() ?? "",
        photo: json['photo']?.toString() ?? "",
        email: json['email']?.toString() ?? "");
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'photo': photo,
      'email': email,
    };
  }
}
