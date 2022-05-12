import 'dart:ui';
import 'package:aiwe/pages/HomeCliente/HomeCliente.dart';
import 'package:aiwe/pages/HomeConductor/HomeConductor.dart';
import 'package:aiwe/pages/HomeConductor/Pages/noAutorizadoPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../utils/global.dart';
import '../../utils/preferencias.dart';
import '../../utils/provider/PeticionesHttp.dart';
import '../../utils/validaciones_utils.dart';

import 'package:aiwe/pages/HomeAdmin/HomeAdmin.dart';

class LoginPage extends StatefulWidget {
  static String idRuta = "LoginPage";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Size size;
  PreferenciasUsuario prefs = new PreferenciasUsuario();
  PeticionesHttpProvider http = new PeticionesHttpProvider();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController smsCodeController = new TextEditingController();
  var formKey = GlobalKey<FormState>();
  var formKeyCode = GlobalKey<FormState>();
  Validaciones validar = new Validaciones();
  String estado;
  Widget body;
  String roleSelected;
  bool init = true;
  @override
  Widget build(BuildContext context) {
    if (init) {
      prefs.ultima_pagina = LoginPage.idRuta;
      init = !init;
      setState(() {});
    }
    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: primaryColor,
      ),
    );
    size = MediaQuery.of(context).size;
    return Scaffold(backgroundColor: Colors.white, body: _body(context));
  }

  Widget _body(context) {
    return SingleChildScrollView(
      child: Container(
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            Container(
              width: size.width,
              height: size.height,
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.1),
                  Icon(Icons.person_pin_circle,
                      color: primaryColor, size: 100.0),
                  Text('Aiwee App',
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold)),
                  body ?? pageDigitPhoneNumber(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget pageDigitCodeSms(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 50.0, right: 50),
      child: Column(
        children: [
          SizedBox(height: size.height * 0.15),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Container(
              width: size.width,
              //  height: 20,
              child: Text(
                "Ha sido enviado exitosamente un codigo de verificacion a su numero de telefono.",
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Form(key: formKeyCode, child: _digitCodeSms()),
          SizedBox(height: 20),
          Container(
            width: size.width,
            height: 55,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: RaisedButton(
              onPressed: () {
                if (!formKeyCode.currentState.validate()) {
                  return null;
                }
                postSmsCode(context);
              },
              color: primaryColor,
              shape: StadiumBorder(),
              child: Text(
                "Ingresar",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _digitCodeSms() {
    return Container(
      width: size.width,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: smsCodeController,
        keyboardType: TextInputType.number,
        validator: (value) => validar.validateSmsCode(value),
        decoration: InputDecoration(
          // icon: Icon(Icons.phone , color:primaryColor),
          prefixIcon: Icon(Icons.comment_rounded, color: primaryColor),
          hintText: '000000',
          labelText: 'Codigo de verficacion',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Widget pageDigitPhoneNumber(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 50.0, right: 50),
      child: Column(
        children: [
          SizedBox(height: size.height * 0.15),
          Form(key: formKey, child: _digitPhoneNumber()),
          SizedBox(height: 20),
          Container(
            width: size.width,
            height: 55,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: RaisedButton(
              onPressed: () {
                if (!formKey.currentState.validate()) {
                  return null;
                }
                postLogin(context);
              },
              color: primaryColor,
              shape: StadiumBorder(),
              child: Text(
                "Ingresar",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _digitPhoneNumber() {
    return Container(
      width: size.width,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: phoneController,
        keyboardType: TextInputType.number,
        validator: (value) => validar.validateNumeroIdentidadYtelefono(value),
        decoration: InputDecoration(
          // icon: Icon(Icons.phone , color:primaryColor),
          prefixIcon: Icon(Icons.phone, color: primaryColor),
          hintText: '3132625451',
          labelText: 'Numero de telefono',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Widget pageSelectRol(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30),
      child: Column(
        children: [
          SizedBox(height: size.height * 0.08),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Container(
                width: size.width,
                //  height: 20,
                child: Text(
                  "Como desea registrarse?",
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
              width: size.width,
              height: 55,
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: RaisedButton(
                onPressed: () {
                  alerta(
                    context,
                    titulo: "Registro",
                    contenido: Text(
                      "¿Seguro que desea registrarse como cliente?",
                      textAlign: TextAlign.center,
                    ),
                    acciones: Row(
                      children: [
                        RaisedButton(
                          onPressed: () {
                            roleSelected = "client";
                            setState(() {});
                            Navigator.pop(context);
                            updateUser(context);
                          },
                          color: Colors.green,
                          child: Text(
                            "Si",
                            style: TextStyle(color: Colors.white),
                          ),
                          shape: StadiumBorder(),
                        ),
                        SizedBox(width: 5),
                        RaisedButton(
                          onPressed: () {},
                          color: primaryColor,
                          child:
                              Text("No", style: TextStyle(color: Colors.white)),
                          shape: StadiumBorder(),
                        )
                      ],
                    ),
                  );
                },
                color: primaryColor,
                shape: StadiumBorder(),
                child: Text(
                  "Cliente",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
              )),
          SizedBox(height: 20),
          Container(
            width: size.width,
            height: 55,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: RaisedButton(
              onPressed: () {
                alerta(
                  context,
                  titulo: "Registro",
                  contenido: Text(
                    "¿Seguro que desea registrarse como repartidor?",
                    textAlign: TextAlign.center,
                  ),
                  acciones: Row(
                    children: [
                      RaisedButton(
                        onPressed: () {
                          roleSelected = "driver";
                          setState(() {});
                          Navigator.pop(context);
                          updateUser(context);
                        },
                        color: Colors.green,
                        child: Text(
                          "Si",
                          style: TextStyle(color: Colors.white),
                        ),
                        shape: StadiumBorder(),
                      ),
                      SizedBox(width: 5),
                      RaisedButton(
                        onPressed: () {},
                        color: primaryColor,
                        child:
                            Text("No", style: TextStyle(color: Colors.white)),
                        shape: StadiumBorder(),
                      )
                    ],
                  ),
                );
              },
              color: Colors.green,
              shape: StadiumBorder(),
              child: Text(
                "Repartidor",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
            ),
          )
        ],
      ),
    );
  }

  postLogin(BuildContext context) async {
    try {
      load(context);
      String valMoment;
      dynamic resp = await http.postMethod(
        context: context,
        table: "login",
        body: {"phone": "${phoneController.text}", "fcm": "${prefs.fcm_token}"},
      );
      Navigator.pop(context);
      print(resp['message']);

      if (resp['message'] == "true") {
        valMoment = resp["data"]["data"]
            .toString()
            .replaceAll(new RegExp(r'send sms '), '');
        body = pageDigitCodeSms(context);
        setState(() {});
      }
      if (resp['message'] == "false") {
        return alerta(
          context,
          titulo: "Algo salio mal",
          code: false,
          contenido: "Algo salio mal, intentelo nuevamente.",
        );
      }
    } catch (e) {
      print(e);
    }
  }

  postSmsCode(BuildContext context) async {
    try {
      load(context);
      dynamic resp = await http.postMethod(
        context: context,
        table: "login",
        body: {
          "phone": "${phoneController.text}",
          "fcm": "${prefs.fcm_token}",
          "sms_code": "${smsCodeController.text}"
        },
      );
      Navigator.pop(context);
      if (resp['message'] == "true") {
        prefs.user_id = resp["data"]["user"]["id"].toString();
        prefs.token = resp["data"]["auth"]["access_token"];
        prefs.refresh_token = resp["data"]["auth"]["refresh_token"];
        prefs.role = resp["data"]["user"]["role"];
        prefs.authorized = resp["data"]["user"]["authorized"].toString();
        if (resp["data"]["user"]["role"] == "default") {
          body = pageSelectRol(context);
        } else {
          if (resp["data"]["user"]["role"] == "driver") {
            if (resp["data"]["user"]["authorized"].toString() == "0") {
              Navigator.of(context)
                  .pushReplacementNamed(NoAutorizadoPage.idRuta);
            } else {
              Navigator.of(context).pushReplacementNamed(HomeConductor.idRuta);
            }
          }
          if (resp["data"]["user"]["role"] == "client") {
            // Navigator.of(context).pushReplacementNamed(HomeCliente.idRuta);
          }
          if (resp["data"]["user"]["role"] == "admin") {
            Navigator.of(context).pushReplacementNamed(HomeAdmin.idRuta);
          }
        }
      }
      if (resp['message'] == "false") {
        return alerta(
          context,
          code: false,
          titulo: "Algo salio mal",
          contenido: "Codigo incorrecto.",
        );
      }
    } catch (e) {
      print(e);
    }
  }

  updateUser(BuildContext context) async {
    try {
      load(context);
      dynamic resp = await http.postMethod(
          context: context,
          body: {
            "role": "$roleSelected",
          },
          table: "users",
          token: prefs.token);
      Navigator.pop(context);
      if (resp['message'] == "true") {
        prefs.role = "$roleSelected";
        setState(() {});
        if (roleSelected == "driver") {
          if (prefs.authorized == "0") {
            Navigator.of(context).pushReplacementNamed(NoAutorizadoPage.idRuta);
          }
          Navigator.of(context).pushReplacementNamed(HomeConductor.idRuta);
        }
        if (roleSelected == "client") {
          Navigator.of(context).pushReplacementNamed(HomeCliente.idRuta);
        }
      }
      if (resp['message'] == "false") {
        return alerta(context,
            code: false,
            titulo: "Algo salio mal",
            contenido: "Ha ocurrido un error en el servidor");
      }
    } catch (e) {
      print(e);
    }
  }
}
