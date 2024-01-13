class BlockModel {
  final String message;

  BlockModel({required this.message});

  factory BlockModel.fromJson(Map<String, dynamic> json) {
    return BlockModel(
      message: json['message']?.toString() ?? "",
    );
  }
}
