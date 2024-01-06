class ReceiverProfile {
  final String name;
  final String id;
  final String photo;

  ReceiverProfile({
    required this.name,
    required this.id,
    required this.photo,
  });

  factory ReceiverProfile.fromJson(Map<String, dynamic> json) {
    return ReceiverProfile(
      name: json['name'] as String,
      id: json['id'] as String,
      photo: json['photo'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'photo': photo,
    };
  }
}
