import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:real_time_chat/widgets/chat_message.dart';

class ChatPage extends StatefulWidget{
  @override
  _ChatPageState createState()=>_ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final _textController=TextEditingController();
  final _focusNode=FocusNode();

  List<ChatMessage> _messages=[ ];

  bool _escribiendo=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              child: Text('Te', style: TextStyle(fontSize: 12)),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox(height: 3),
            Text('Cosme',
                style: TextStyle(color: Colors.black87, fontSize: 12)),
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (_, i) => _messages[i],
                reverse: true,
              ),
            ),

            Divider(height: 1),

            Container(
              color: Colors.white,
              child: _inputChat(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputChat(){
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (String texto){
                  //saber cuando hay un valor
                  setState(() {
                    if(texto.trim().length>0){
                      _escribiendo=true;
                    }else{
                      _escribiendo=false;
                    }
                  });
                },
                decoration: InputDecoration.collapsed(hintText: 'Enviar mensaje'),
                focusNode: _focusNode,
              ),
            ),

            //boton de enviar
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: Platform.isIOS
                  ? CupertinoButton(
                      child: Text('Enviar'),
                      onPressed: _escribiendo
                      ? ()=>_handleSubmit(_textController.text.trim())
                      : null,
                  )


                  : Container(margin: EdgeInsets.symmetric(horizontal: 4.0),
                    child: IconTheme(
                      data: IconThemeData(color: Colors.blue[400]),
                      child: IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        icon: Icon(Icons.send),
                        onPressed: _escribiendo
                          ? ()=>_handleSubmit(_textController.text.trim())
                          : null,
                      ),
                    )
                  ),
            ),

          ],
        ),
      ),
    );
  }

  _handleSubmit(String text){

    if(text.isEmpty) return;

    print(text);

    _textController.clear();
    _focusNode.requestFocus();

    final newMessage=ChatMessage(
        texto: text,
        uid: '123777',
        animationController: AnimationController(vsync: this,duration: Duration(milliseconds: 300)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _escribiendo=false;
    });
  }

  @override
  void dispose() {
    // TODO: off del socket

    //limpieza de controllers
    for(ChatMessage message in _messages){
      message.animationController.dispose();
    }

    super.dispose();
  }
}
