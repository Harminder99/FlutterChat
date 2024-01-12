class CallBackSocketModel {
  final String status;
  final String message;
  final String messageId;

  CallBackSocketModel(
      {required this.status, required this.message, required this.messageId});

  factory CallBackSocketModel.fromJson(Map<String, dynamic> json) {
    return CallBackSocketModel(
      status: json['status']?.toString() ?? "",
      message: json['message']?.toString() ?? "",
      messageId: json['messageId']?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message, "messageId": messageId};
  }
}
