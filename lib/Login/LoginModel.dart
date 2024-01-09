import 'package:flutter/cupertino.dart';

class LoginModel {
  final String token;
  final String id;
  final String name;
  final String email;
  final String photo;

  LoginModel(
      {required this.token,
      required this.id,
      required this.name,
      required this.email,
      required this.photo});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    // Extracting the 'token' from within the nested 'data' map
    var data = json['data'] as Map<String, dynamic>;

    return LoginModel(
      token: data['token']?.toString() ?? "",
      id: data['id']?.toString() ?? "",
      name: data['name']?.toString() ?? "",
      email: data['email']?.toString() ?? "",
      photo: data['photo']?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'id': id,
      'name': name,
      'email': email,
      'photo': photo,
    };
  }
}
