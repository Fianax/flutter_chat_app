import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chat/pages/usuarios_page.dart';
import 'package:real_time_chat/services/auth_service.dart';
import 'package:real_time_chat/services/socket_service.dart';

import 'login_page.dart';

class LoadingPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: chekLoginState(context),
        builder: (context,snapshot){
          return Center(
            child: Text('Espere...'),
          );
        },
      ),
    );
  }

  Future chekLoginState(BuildContext context)async{

    final authService=Provider.of<AuthService>(context,listen: false);
    final socketService=Provider.of<SocketService>(context,listen: false);
    final autenticado=await authService.isLoggedIn();

    if(autenticado){
      //connectar al socket server
      socketService.connect();
      //Navigator.pushReplacementNamed(context, 'usuarios');
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_,__,___)=>UsuariosPage(),
            transitionDuration: Duration.zero
          )
      );
    }else{
      //Navigator.pushReplacementNamed(context, 'login');
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (_,__,___)=>LoginPage(),
              transitionDuration: Duration.zero
          )
      );
    }

  }

}