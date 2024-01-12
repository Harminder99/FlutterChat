
import 'package:flutter/cupertino.dart';

import 'ReceiverProfile.dart';

enum MessageStatus {sending, pending, sent, delivered, seen }

class ChattingScreenModel {
  final bool isSender;
  final String message;
  final DateTime date;
   MessageStatus status;
  final String messageId;
  final ReceiverProfile receiverProfile;

  ChattingScreenModel({
    required this.isSender,
    required this.message,
    required this.date,
    required this.status,
    required this.messageId,
    required this.receiverProfile,
  });

  factory ChattingScreenModel.fromJson(Map<String, dynamic> json) {

    final profile = ReceiverProfile.fromJson(json['receiverProfile'] as Map<String, dynamic>);
    return ChattingScreenModel(
      isSender: false,
      message: json['message'] as String,
      date: json['date'] != null ? DateTime.parse(json['date'].toString()) : DateTime.timestamp(),
      status: json['status'] != null ? MessageStatus.values.firstWhere(
            (e) => e.toString() == 'MessageStatus.${json['status']}',
      ) : MessageStatus.delivered,
      messageId: json['messageId']?.toString() ?? "",
      receiverProfile: profile,
    );
  }

  factory ChattingScreenModel.fromRecJson(Map<String, dynamic> json) {

    final profile = ReceiverProfile.fromJson(json['receiverProfile'] as Map<String, dynamic>);
    return ChattingScreenModel(
      isSender: false,
      message: json['message'] as String,
      date: DateTime.timestamp(),
      status: json['status'] != null ? MessageStatus.values.firstWhere(
            (e) => e.toString() == 'MessageStatus.${json['status']}',
      ) : MessageStatus.delivered,
      messageId: json['messageId']?.toString() ?? "",
      receiverProfile: profile,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isSender': isSender,
      'message': message,
      'date': date.toUtc().toIso8601String(),
      'status': status.toString().split('.').last,
      'messageId': messageId,
      'receiverProfile': receiverProfile.toJson(),
    };
  }
}
