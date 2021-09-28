import 'package:flutter/material.dart';

class Labels extends StatelessWidget{

  final String ruta;
  final String msg1;
  final String msg2;

  Labels({required this.ruta,required this.msg1,required this.msg2});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 170,
        child: Column(
          children: [
            Text(msg1, style: TextStyle(color: Colors.black54, fontSize: 13, fontWeight: FontWeight.w300)),
            SizedBox(height: 10),
            GestureDetector(
              child: Text(msg2, style: TextStyle(color:  Colors.blue[600],fontSize: 15, fontWeight: FontWeight.bold)),
              onTap: (){
                Navigator.pushReplacementNamed(context, ruta);
              },
            ),
          ],
        ),
      ),
    );
  }
}