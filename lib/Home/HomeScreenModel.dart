class HomeScreenModel {
  final String id;
  final String username;
  final String email;
  final String photo;
  final String message;
  final DateTime? date; // Allowing date to be null
  final int count;

  HomeScreenModel({
    required this.id,
    required this.username,
    required this.email,
    required this.photo,
    required this.message,
    this.date, // Nullable date
    this.count = 0,
  });



// Optionally, add a factory method to create a HomeScreenModel from a map (e.g., from JSON)
  factory HomeScreenModel.fromJson(Map<String, dynamic> json) {
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
