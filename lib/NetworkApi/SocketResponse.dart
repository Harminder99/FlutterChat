class SocketResponse {
  final String event;
  final String room;
  final Map<String, dynamic> data;

  SocketResponse({required this.event, required this.room, required this.data});

  factory SocketResponse.fromJson(Map<String, dynamic> json) {
    // Extracting the 'token' from within the nested 'data' map
    var data = json['data'] as Map<String, dynamic>;

    return SocketResponse(
        event: data['event']?.toString() ?? "",
        room: data['room']?.toString() ?? "",
        data: data);
  }

  Map<String, dynamic> toJson() {
    return {'event': event, 'room': room, 'data': data};
  }
}

T Function<T extends SocketResponse>(Map<String, dynamic>) modelFromJson<T>(
    data) {
  // TODO: implement modelFromJson
  throw UnimplementedError();
}