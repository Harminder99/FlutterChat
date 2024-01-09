class CallBackSocketModel {
  final String status;
  final String message;

  CallBackSocketModel({required this.status, required this.message});

  factory CallBackSocketModel.fromJson(Map<String, dynamic> json) {
    return CallBackSocketModel(
      status: json['status']?.toString() ?? "",
      message: json['message']?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }
}
