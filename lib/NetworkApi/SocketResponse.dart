class SocketResponse {
  final String? event;
  final String? room;
  final Map<String, dynamic>? data;

  SocketResponse({this.event, this.room, this.data});

  factory SocketResponse.fromJson(Map<String, dynamic> json) {
    var eventData = json['data'] as Map<String, dynamic>?;

    return SocketResponse(
        event: json['event']?.toString() ?? "",
        room: json['room']?.toString() ?? "not found",
        data: eventData);
  }
}
