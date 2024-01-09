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
    debugPrint("START EMIT $event == $data");
    _socket.emitWithAck(event, data, ack: (response) {
      debugPrint("response ==> $response");
      CallBackSocketModel model = CallBackSocketModel.fromJson(response);
      // Handle the callback model here
      debugPrint("Status: ${model.status}, Message: ${model.message}");
      if (callback != null) {
        callback!(model);
      }
    });
  }

  void emit(String event, dynamic data) {
    _socket.emit(event, data);
  }

  void off(String event) {
    _socket.off(event);
  }

  // void on(String event, Function(dynamic) callback) {
  //   _socket.on(event, callback);
  // }

  void on<T extends SocketResponse>(String event, Function(T) callback) {
    _socket.on(event, (data) {
      // Assuming the incoming data is a Map
      debugPrint("Event ==> $data");
      T model = modelFromJson<T>(data) as T;
      debugPrint("Event ==> ${model.event}");
      if (model.room == room) {
        callback(model);
      } else {
        debugPrint("This Message is not For this room");
      }
    });
  }

  @override
  void dispose() {
    _socket.dispose();
    super.dispose();
  }
}
