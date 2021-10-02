import 'package:flutter/material.dart';

class Btn_azul extends StatelessWidget{

  final String etiqueta;

  final Function()? onPress;

  final ButtonStyle style=ElevatedButton.styleFrom(
      elevation: 2,
      shape: StadiumBorder(),
      primary: Colors.blue
  );

  Btn_azul({required this.etiqueta, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        style: style,
        onPressed: onPress,
        child: Container(
            width: double.infinity,
            height: 55,
            child: Center(
              child: Text(etiqueta,style: TextStyle(color: Colors.white,fontSize: 13)),
            )
        ),
      ),
    );
  }
}