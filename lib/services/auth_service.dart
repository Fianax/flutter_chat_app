import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:real_time_chat/global/environment.dart';
import 'package:real_time_chat/models/login_response.dart';
import 'package:real_time_chat/models/usuario.dart';

class AuthService with ChangeNotifier{

  late Usuario usuario;//yo, el usuario que lanza la app
  bool _autenticando=false;

  //crear storage para guardar el token
  final _storage = FlutterSecureStorage();

  bool get autenticando=>_autenticando;
  set autenticando(bool valor){
    _autenticando=valor;
    notifyListeners();//notifica el cambio a todos los que escuchen para repintarse
  }

  //Getters del token de forma statica
  static Future<String?> getToken()async{
    final _storage = FlutterSecureStorage();
    final token=await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken()async{
    final _storage = FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email,String password) async{

    autenticando=true;

    final data={
      'email':email,
      'password':password
    };

    final resp=await http.post(Uri.parse('${Environment.apiUrl}/login'),
      body: jsonEncode(data),
      headers:{
        'Content-Type':'application/json'
      }
    );

    autenticando=false;
    if(resp.statusCode==200){
      final loginResponse=loginResponseFromJson(resp.body);
      usuario=loginResponse.usuario;

      //guardar token en lugar seguro
      await _guardarToken(loginResponse.token);

      return true;
    }else{
      return false;
    }

  }

  Future register(String nombre,String email,String password) async{

    autenticando=true;

    final data={
      'nombre':nombre,
      'email':email,
      'password':password
    };
    
    final resp=await http.post(Uri.parse('${Environment.apiUrl}/login/new'),
      body: jsonEncode(data),
      headers:{
        'Content-Type':'application/json'
      }
    );

    autenticando=false;

    if(resp.statusCode==200){
      final loginResponse=loginResponseFromJson(resp.body);
      usuario=loginResponse.usuario;

      //guardar token en lugar seguro
      await _guardarToken(loginResponse.token);

      return true;
    }else{
      Map<dynamic,dynamic> respBody=jsonDecode(resp.body);
      if(respBody.containsKey('errors')){
        return respBody['errors']['password']['msg'];
      }else{
        return respBody['msg'];
      }
    }

  }

  Future<bool> isLoggedIn() async{

    final token=await _storage.read(key: 'token')??'';

    final resp=await http.get(Uri.parse('${Environment.apiUrl}/login/renew'),
      headers: {
        'Content-Type':'application/json',
        'x-token':token
      }
    );

    if(resp.statusCode==200){
      final loginResponse=loginResponseFromJson(resp.body);
      usuario=loginResponse.usuario;
      await _guardarToken(loginResponse.token);

      return true;
    }else{
      logout();//borrar el token que no sirve
      return false;
    }

  }

  Future _guardarToken(String token) async{
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async{
    return await _storage.delete(key: 'token');
  }

}