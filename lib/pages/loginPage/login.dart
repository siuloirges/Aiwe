import 'package:aiwe/pages/HomeCliente/HomeCliente.dart';
import 'package:aiwe/pages/HomeConductor/HomeConductor.dart';
import 'package:flutter/material.dart';
import '../../utils/global.dart';
import '../../utils/preferencias.dart';
import '../../utils/provider/PeticionesHttp.dart';
import '../../utils/validaciones_utils.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
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

  int time = 0;
  initTime() async {
    if (time >= 1) {
      await Future.delayed(Duration(seconds: 1));
      time--;

      if (time >= 1) {
        body = pageDigitCodeSms(context);
      }
      print(time);
      setState(() {});
      initTime();
    }
  }

  var values = [];

  addValue(v) {
    if (values.length <= 3) {
      values.add(v);
    }
    print(values);
  }

  removeValue() {
    if (values.length >= 1) {
      values.removeAt(values.length - 1);
    }
    print(values);
  }

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
    return Scaffold(
        backgroundColor: Colors.white, body: body ?? _body(context));
  }

  Widget _body(context) {
    return Container(
      width: size.width,
      height: size.height,
      child: Container(
        width: size.width,
        height: size.height,
        child: Container(
          // color: Colors.amber,
          child: Stack(
            children: backdround()
              ..addAll([
                Container(
                  // color: Colors.amberAccent,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // SizedBox(height: size.height * 0.2),
                      pageDigitPhoneNumber(context),
                    ],
                  ),
                ),
              ]),
          ),
        ),
      ),
    );
  }

  Widget pageDigitCodeSms(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Center(
              child: Image.asset("assets/Loading.png"),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Verifica tu ",
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: "Raleway",
                      ),
                    ),
                    Text(
                      "codigo",
                      style: TextStyle(
                          fontSize: 30,
                          fontFamily: "Raleway",
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                Text("Pide tu codigo desde el: +57${phoneController.text}"),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 40, right: 10),
                        child: Container(
                          child: Center(
                              child: Text(
                            (values.length >= 1 ? values[0] : '').toString(),
                            style: TextStyle(fontSize: 35),
                          )),
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black38,
                                    offset: Offset(1, 1),
                                    blurRadius: 5)
                              ],
                              borderRadius: BorderRadius.circular(100),
                              color: Color.fromRGBO(215, 215, 215, 1)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          child: Center(
                              child: Text(
                            (values.length > 1 ? values[1] : '').toString(),
                            style: TextStyle(fontSize: 35),
                          )),
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black38,
                                    offset: Offset(1, 1),
                                    blurRadius: 5)
                              ],
                              borderRadius: BorderRadius.circular(100),
                              color: Color.fromRGBO(215, 215, 215, 1)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          child: Center(
                              child: Text(
                            (values.length > 2 ? values[2] : '').toString(),
                            style: TextStyle(fontSize: 35),
                          )),
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black38,
                                    offset: Offset(1, 1),
                                    blurRadius: 5)
                              ],
                              borderRadius: BorderRadius.circular(100),
                              color: Color.fromRGBO(215, 215, 215, 1)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 40),
                        child: Container(
                          child: Center(
                              child: Text(
                            (values.length > 3 ? values[3] : '').toString(),
                            style: TextStyle(fontSize: 35),
                          )),
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black38,
                                    offset: Offset(1, 1),
                                    blurRadius: 5)
                              ],
                              borderRadius: BorderRadius.circular(100),
                              color: Color.fromRGBO(215, 215, 215, 1)),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: TextButton(
                          child: Text(
                            time <= 1
                                ? "Reenviar Codigo"
                                : "00:" + time.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontFamily: "Raleway",
                                color: primaryColor,
                                fontSize: 16),
                          ),
                          onPressed: time <= 1
                              ? () {
                                  postLogin(context);

                                  values = [];
                                  setState(() {});
                                }
                              : null,
                        ),
                      ),
                      Text(" | "),
                      TextButton(
                          onPressed: () {
                            final url =
                                'whatsapp://send?phone=${numberPhoneBot}&text=Hola!, Quiero mi codigo de verificacion para Travel!';
                            url_launcher.launchUrl(Uri.parse(url));
                          },
                          child: Text(
                            "Ir a WhatsApp",
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontFamily: "Raleway",
                                color: primaryColor,
                                fontSize: 16),
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  boton("1"),
                  boton("2"),
                  boton("3"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  boton("4"),
                  boton("5"),
                  boton("6"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  boton("7"),
                  boton("8"),
                  boton("9"),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  children: [
                    Expanded(
                        child: IconButton(
                      onPressed: () {
                        removeValue();
                        body = pageDigitCodeSms(context);
                        setState(() {});
                      },
                      icon: Icon(Icons.backspace_rounded),
                    )),
                    Expanded(child: boton("0")),
                    Expanded(
                        child: IconButton(
                      onPressed: () {
                        if (values.length != 4) {
                          return alerta(context,
                              contenido: "Numero incompleto", code: false);
                        }

                        postSmsCode(context);
                        setState(() {});
                      },
                      icon: Icon(Icons.done, size: 40),
                    ))
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
    // return Padding(
    //   padding: const EdgeInsets.only(left: 50.0, right: 50),
    //   child: Column(
    //     children: [
    //       SizedBox(height: size.height * 0.15),
    //       Padding(
    //         padding: const EdgeInsets.only(bottom: 20.0),
    //         child: Container(
    //           width: size.width,
    //           //  height: 20,
    //           child: Text(
    //             "Escribenos por WhatsApp con este numero de telefono para obtener tu código de verificación",
    //             textAlign: TextAlign.center,
    //           ),
    //         ),
    //       ),
    //       TextButton(
    //           onPressed: () {
    //             final url =
    //                 'whatsapp://send?phone=${numberPhoneBot}&text=Hola!, Quiero mi codigo de verificacion para Travel!';
    //             url_launcher.launchUrl(Uri.parse(url));
    //           },
    //           child: Text("Ir a WhatsApp")),
    //       Form(key: formKeyCode, child: _digitCodeSms()),
    //       SizedBox(height: 20),
    //       Container(
    //         width: size.width,
    //         height: 55,
    //         padding: EdgeInsets.symmetric(horizontal: 20.0),
    //         child: RaisedButton(
    //           onPressed: () {
    //             if (!formKeyCode.currentState.validate()) {
    //               return null;
    //             }
    //             postSmsCode(context);
    //           },
    //           color: primaryColor,
    //           shape: StadiumBorder(),
    //           child: Text(
    //             "Confirmar",
    //             style: TextStyle(color: Colors.white),
    //           ),
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }

  Widget _digitCodeSms() {
    return Container(
      width: size.width,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: TextFormField(
        controller: smsCodeController,
        keyboardType: TextInputType.number,
        validator: (value) => validar.validateSmsCode(value),
        decoration: InputDecoration(
          // icon: Icon(Icons.phone , color:primaryColor),
          prefixIcon: Icon(Icons.comment_rounded, color: primaryColor),
          hintText: '000000',
          labelText: 'Codigo de verificacion',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Widget pageDigitPhoneNumber(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20),
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
                "Confirmar",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.05),
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
                    "¿Seguro que desea registrarse como Conductor?",
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

                          // roleSelected = "driver";
                          // setState(() {});
                          // Navigator.of(context)
                          //     .pushReplacementNamed(HomeConductor.idRuta);
                          //updateUser(context);
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
                "Conductor",
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
      print("==============================:" + prefs.fcm_token);

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
        time = 60;
        initTime();

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
      print("==============================*****************************************************:" +
          "${values[0] + '' + values[1] + '' + values[2] + '' + values[3] + ''}");
      load(context);
      dynamic resp = await http.postMethod(
        context: context,
        table: "login",
        body: {
          "phone": "${phoneController.text}",
          "fcm": "${prefs.fcm_token}",
          "sms_code":
              "${values[0] + '' + values[1] + '' + values[2] + '' + values[3] + ''}"
        },
      );
      Navigator.pop(context);
      if (resp['message'] == "true") {
        print(
            "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");

        time = 0;
        prefs.user_id = resp["data"]["user"]["id"].toString();
        prefs.token = resp["data"]["auth"]["access_token"];
        prefs.refresh_token = resp["data"]["auth"]["refresh_token"];
        prefs.role = resp["data"]["user"]["role"];
        prefs.authorized = resp["data"]["user"]["authorized"].toString();
        if (resp["data"]["user"]["role"] == "default") {
          body = pageSelectRol(context);
          setState(() {});
        } else {
          if (resp["data"]["user"]["role"] == "driver") {
            // if (resp["data"]["user"]["authorized"].toString() == "0") {
            //   Navigator.of(context)
            //       .pushReplacementNamed(NoAutorizadoPage.idRuta);
            // } else {
            Navigator.of(context).pushReplacementNamed(HomeConductor.idRuta);
            // }
          }
          if (resp["data"]["user"]["role"] == "client") {
            Navigator.of(context).pushReplacementNamed(HomeCliente.idRuta);
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

  List<Widget> backdround() {
    return body == null
        ? [
            Transform.translate(
              offset: Offset(-180, size.height / 3.4),
              child: Transform.scale(
                scale: 1.7,
                child: Container(
                  child: Image.asset(
                    "assets/moto.png",
                  ),
                ),
              ),
            ),
            Container(
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Transform.translate(
                    offset: Offset(0, size.height / 8.5),

                    // scale: 1.7,
                    child: Container(
                      child: Image(
                        image: AssetImage('assets/Loading.png'),
                        // color: verde,
                        width: 130,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                duration: Duration(seconds: 1),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                      Color.fromRGBO(255, 255, 255, 1),
                      Color.fromRGBO(255, 255, 255, 0.9),
                      Color.fromRGBO(255, 255, 255, 0),
                    ])),
                height: size.height / 2.8,
                width: size.width,
              ),
            ),
          ]
        : [];
  }

  boton(numero) {
    return IconButton(
        onPressed: () {
          addValue(numero);
          body = pageDigitCodeSms(context);
          setState(() {});
        },
        iconSize: 40,
        icon: Text(
          numero,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 35, fontFamily: "Raleway"),
        ));
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
          // if (prefs.authorized == "0") {
          //   Navigator.of(context).pushReplacementNamed(NoAutorizadoPage.idRuta);
          // }
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


// class Boton extends StatefulWidget {
//   String numero;
//   Boton(this.numero);

//   @override
//   _BotonState createState() => _BotonState();
// }

// class _BotonState extends State<Boton> {

//     final KeyboardController keyboardController = Get.find<KeyboardController>(); 

//   @override
//   Widget build(BuildContext context) {
//     return 
//   }
// }
