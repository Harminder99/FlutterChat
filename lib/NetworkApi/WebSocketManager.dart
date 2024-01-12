import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as io_socket;
import 'package:untitled2/Login/LoginViewModel.dart';
import 'package:untitled2/NetworkApi/ApiEndpoints.dart';

import 'CallBackSocketModel.dart';
import 'SocketResponse.dart';

class WebSocketManager with ChangeNotifier {
  late io_socket.Socket _socket;
  String room = "room";

  io_socket.Socket get socket => _socket;

  void disConnect() {
    _socket.dispose();
  }

  void connect(BuildContext context) {
    _socket = io_socket.io(ApiEndpoints.socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true
    });

    _socket.onConnect((_) {
      debugPrint('Connected');
      onConnect();
    });

    _socket.onDisconnect((_) {
      debugPrint('Disconnected');
      onDisconnect();
    });

    // Handle automatic reconnection
    _socket.on('connect_error', (error) {
      Future.delayed(const Duration(seconds: 5), () {
        _socket.connect();
      });
    });
    final viewModel = Provider.of<LoginViewModel>(context, listen: false);
    room = "CHAT_ROOM${viewModel.model?.id}";
    _socket.io.options?['extraHeaders'] = {
      'Authorization': 'bearer ${viewModel.model?.token}'
    };
    _socket.connect();
  }

  void onConnect() {
    // Custom logic when connected
    _socket.emit("joinRoom");
  }

  void onDisconnect() {
    // Custom logic when disconnected
  }

  void emitWithCallBack(String event, dynamic data,
      [Function(CallBackSocketModel)? callback]) {
    _socket.emitWithAck(event, data, ack: (response) {
      CallBackSocketModel model = CallBackSocketModel.fromJson(response);
      if (callback != null) {
        callback!(model);
      }
    });
  }

  void emit(String event, dynamic data) {
    _socket.emit(event, data);
  }

  void off(String event) {
    debugPrint("OFF $event");
    _socket.off(event);
  }

  // void on(String event, Function(dynamic) callback) {
  //   _socket.on(event, callback);
  // }

  void on(String event, Function(SocketResponse) callback) {
    debugPrint("ON $event");
    _socket.on(event, (data) {
      debugPrint("data ===> $data");
      SocketResponse model = SocketResponse.fromJson(data);
      debugPrint("Message Found ${model.room} == $room");
      if (model.room == room) {
        callback(model);
      } else {
        debugPrint("This Message is not For this room ${model.room} == $room");
      }
    });
  }

  @override
  void dispose() {
    _socket.dispose();
    super.dispose();
  }
}
