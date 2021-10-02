import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:real_time_chat/models/usuario.dart';
import 'package:real_time_chat/services/auth_service.dart';
import 'package:real_time_chat/services/chat_service.dart';
import 'package:real_time_chat/services/socket_service.dart';
import 'package:real_time_chat/services/usuarios_service.dart';

class UsuariosPage extends StatefulWidget {
  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  final usuariosService=UsuariosService();

  List<Usuario> usuarios=[];


  @override
  void initState() {
    _cargarUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final authService=Provider.of<AuthService>(context);
    final socketService=Provider.of<SocketService>(context);
    final usuario=authService.usuario;

    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Text(usuario.nombre, style: TextStyle(color: Colors.black54)),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.exit_to_app, color: Colors.black87),
          onPressed: () {
            //desconectarnos del sockect server
            socketService.disconnect();

            Navigator.pushReplacementNamed(context, 'login');
            AuthService.deleteToken();
          },
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: socketService.serverStatus==ServerStatus.online
                ? Icon(Icons.check_circle, color: Colors.blue[400])
                : Icon(Icons.offline_bolt, color: Colors.red[400]),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _cargarUsuarios,
        header: WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue[400]),
          waterDropColor: Colors.blue,
        ),
        child: _listViewUsuarios(),
      ),
    );
  }

  ListView _listViewUsuarios(){
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, i) => _usuarioListTile(usuarios[i]),
      separatorBuilder: (_, i) => Divider(),
      itemCount: usuarios.length,
    );
  }

  ListTile _usuarioListTile(Usuario usuario){
    return ListTile(
      title: Text(usuario.nombre),
      leading: CircleAvatar(
        child: Text(usuario.nombre.substring(0, 2)),
        backgroundColor: Colors.blue[100],
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: usuario.online ? Colors.green[300] : Colors.red,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      onTap: (){
        final chatService=Provider.of<ChatService>(context,listen: false);
        chatService.usuarioPara=usuario;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }

  _cargarUsuarios() async {

    usuarios=await usuariosService.getUsuarios();
    setState(() { });
    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.refreshCompleted();
  }
}
