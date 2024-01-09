
import '../NetworkApi/SocketResponse.dart';

class ChatTempModel extends SocketResponse{
  final String message;

  ChatTempModel({
    required this.message,
    required super.data,
    required super.room,
    required super.event,
  });

// Optionally, add a factory method to create a HomeScreenModel from a map (e.g., from JSON)
  factory ChatTempModel.fromJson(Map<String, dynamic> json) {
    final data = ["data"] as Map<String, dynamic>;
    return ChatTempModel(
      message: data['message'] as String,
      data: data,
      room: json['room'] as String,
      event: json['event'] as String,
    );
  }

// Optionally, add a method to convert the user model to a map (e.g., for JSON serialization)
  @override
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      "room":room,
      "data":data,
      "event":event
    };
  }
}
