import 'dart:io';

class Environment{

  static String apiUrl=Platform.isAndroid ? 'https://chat-server-nube.herokuapp.com/api' : 'https://chat-server-nube.herokuapp.com/api';
  static String socketUrl=Platform.isAndroid ? 'https://chat-server-nube.herokuapp.com/' : 'https://chat-server-nube.herokuapp.com/';
}