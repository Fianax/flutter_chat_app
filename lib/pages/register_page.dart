import 'package:flutter/material.dart';
import 'package:real_time_chat/widgets/btn_azul.dart';
import 'package:real_time_chat/widgets/custom_input.dart';
import 'package:real_time_chat/widgets/labels.dart';
import 'package:real_time_chat/widgets/logo.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF2F2F2),
        body: SafeArea(
            child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Logo(
                        titulo: 'Registro',
                      ),
                      _Form(),
                      Labels(
                        ruta: 'login',
                        msg1: '¿Ya tienes una cuenta?',
                        msg2: 'Ingresa ahora!',
                      ),
                      Text('Terminos y condiciones de uso',
                          style: TextStyle(fontWeight: FontWeight.w200)),
                    ],
                  ),
                ))));
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.perm_identity,
            placeholder: 'Nombre',
            keyboardType: TextInputType.text,
            textEditingController: nameCtrl,
          ),
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Email',
            keyboardType: TextInputType.emailAddress,
            textEditingController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outlined,
            placeholder: 'Contraseña',
            isPassword: true,
            textEditingController: passCtrl,
          ),
          Btn_azul(
            etiqueta: 'Ingrese',
            onPress: () {
              print(emailCtrl.text);
              print(passCtrl.text);
            },
          ),
        ],
      ),
    );
  }
}
