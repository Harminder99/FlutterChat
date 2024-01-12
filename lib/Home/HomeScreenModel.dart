import 'package:flutter/cupertino.dart';

import '../Chatting/ChattingScreenModel.dart';

class HomeScreenModel {
  final String id;
  final String username;
  final String email;
  final String photo;
  String message;
  DateTime? date; // Allowing date to be null
  int count;

  HomeScreenModel({
    required this.id,
    required this.username,
    required this.email,
    required this.photo,
    required this.message,
    this.date, // Nullable date
    this.count = 0,
  });

  void updateCount(int v) {
    count = v;
  }

  factory HomeScreenModel.updateModelFromChatModel(ChattingScreenModel model) {
    return HomeScreenModel(
        id: model.receiverProfile.id,
        username: model.receiverProfile.name,
        email: model.receiverProfile.email,
        photo: model.receiverProfile.photo,
        message: model.message,
        count: 1,
        date: model.date);
  }

// Optionally, add a factory method to create a HomeScreenModel from a map (e.g., from JSON)
  factory HomeScreenModel.fromJson(Map<String, dynamic> json) {
    return HomeScreenModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? "",
      username: json['name']?.toString() ?? "",
      email: json['email']?.toString() ?? "",
      photo: json['photo']?.toString() ?? "",
      message: json['message']?.toString() ?? "",
      count: 0,
      date: DateTime.parse(json['createdAt']),
    );
  }

  factory HomeScreenModel.fromSocketJson(Map<String, dynamic> json) {
    return HomeScreenModel(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      photo: json['photo'] as String,
      message: json['message'] as String,
      count: json['count'] as int,
      date: DateTime.parse(json['date']),
    );
  }

// Optionally, add a method to convert the user model to a map (e.g., for JSON serialization)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'photo': photo,
      'message': message,
      "count": count,
      'date': date?.toIso8601String(),
    };
  }
}
