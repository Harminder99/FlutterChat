class ChatTempModel {
  final String message;

  ChatTempModel({required this.message});

// Optionally, add a factory method to create a HomeScreenModel from a map (e.g., from JSON)
  factory ChatTempModel.fromJson(Map<String, dynamic> json) {
    return ChatTempModel(message: json['message'] as String);
  }

// Optionally, add a method to convert the user model to a map (e.g., for JSON serialization)
  Map<String, dynamic> toJson() {
    return {'message': message};
  }
}
