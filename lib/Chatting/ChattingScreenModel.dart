
import 'ReceiverProfile.dart';

enum MessageStatus { pending, sent, delivered, seen }

class ChattingScreenModel {
  final bool isSender;
  final String message;
  final DateTime date;
  final MessageStatus status;
  final String id;
  final ReceiverProfile receiverProfile;

  ChattingScreenModel({
    required this.isSender,
    required this.message,
    required this.date,
    required this.status,
    required this.id,
    required this.receiverProfile,
  });

  factory ChattingScreenModel.fromJson(Map<String, dynamic> json) {
    return ChattingScreenModel(
      isSender: json['isSender'] as bool,
      message: json['message'] as String,
      date: DateTime.parse(json['date'] as String),
      status: MessageStatus.values.firstWhere(
            (e) => e.toString() == 'MessageStatus.${json['status']}',
      ),
      id: json['id'] as String,
      receiverProfile: ReceiverProfile.fromJson(json['reciverProfile'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isSender': isSender,
      'message': message,
      'date': date.toIso8601String(),
      'status': status.toString().split('.').last,
      'id': id,
      'reciverProfile': receiverProfile.toJson(),
    };
  }
}
