import 'package:flutter/material.dart';
import 'package:real_time_chat/global/environment.dart';
import 'package:real_time_chat/services/auth_service.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus{
  online,
  offline,
  connecting
}

class SocketService with ChangeNotifier{

  ServerStatus _serverStatus=ServerStatus.connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus=>_serverStatus;

  IO.Socket get socket=>_socket;
  Function get emit=>_socket.emit;

  void connect()async{

    final token=await AuthService.getToken();

    // Dart client
    _socket = IO.io(Environment.socketUrl,{
      'transports':['websocket'],
      'autoConnect':true,
      'forceNew':true,//gasta mas recuros pero es necesario
      'extraHeaders':{
        'x-token':token
      }
    });

    _socket.on('connect',(_) {
      _serverStatus=ServerStatus.online;
      notifyListeners();
    });
    _socket.on('disconnect',(_) {
      _serverStatus=ServerStatus.offline;
      notifyListeners();
    });
  }

  void disconnect(){
    _socket.disconnect();
  }

}