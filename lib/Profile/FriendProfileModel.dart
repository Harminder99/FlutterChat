class FriendProfileModel {
  final String id;
  final String name;
  final String email;
  final String photo;

  FriendProfileModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.photo});

  factory FriendProfileModel.fromJson(Map<String, dynamic> json) {
    // Extracting the 'token' from within the nested 'data' map
    var data = json['data'] as Map<String, dynamic>;
    return FriendProfileModel(
      id: data['_id']?.toString() ?? "",
      name: data['name']?.toString() ?? "",
      email: data['email']?.toString() ?? "",
      photo: data['photo']?.toString() ?? "",
    );
  }
}
