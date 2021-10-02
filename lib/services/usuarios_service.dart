import 'package:real_time_chat/global/environment.dart';
import 'package:real_time_chat/models/usuario.dart';
import 'package:http/http.dart' as http;
import 'package:real_time_chat/models/usuarios_response.dart';
import 'package:real_time_chat/services/auth_service.dart';

class UsuariosService{

  Future<List<Usuario>> getUsuarios()async{

    try{

      String? token = await AuthService.getToken();
      
      final resp=await http.get(Uri.parse('${Environment.apiUrl}/usuarios'),
        headers: {
          'Content-Type':'application/json',
          'x-token':token.toString()
        }
      );

      final usuariosResponse=usuariosResponseFromJson(resp.body);

      return usuariosResponse.usuarios;

    }catch(error){
      return [];
    }
  }

}