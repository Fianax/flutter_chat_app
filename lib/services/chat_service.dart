import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:real_time_chat/global/environment.dart';
import 'package:real_time_chat/models/mensajes_response.dart';
import 'package:real_time_chat/models/usuario.dart';
import 'package:real_time_chat/services/auth_service.dart';

class ChatService with ChangeNotifier{

  late Usuario usuarioPara;//para quien van los mensajes

  Future<List<Mensaje>> getChat(String usuarioID) async{

    String? token = await AuthService.getToken();

    final resp=await http.get(Uri.parse('${Environment.apiUrl}/mensajes/$usuarioID'),
      headers: {
        'Content-Type':'application/json',
        'x-token':token.toString()
      }
    );

    final mensajesResp=mensajesResponseFromJson(resp.body);

    return mensajesResp.mensajes;

  }

}