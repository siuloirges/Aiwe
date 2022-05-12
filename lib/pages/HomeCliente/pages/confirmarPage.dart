import 'dart:convert';

import 'package:aiwe/pages/HomeCliente/pages/orderClientePage.dart';
import 'package:aiwe/pages/HomeCliente/utils/ConfirmarClienteProvider.dart';
import 'package:aiwe/utils/global.dart';
import 'package:aiwe/utils/preferencias.dart';
import 'package:aiwe/utils/provider/sendNotifi.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

ConfirmarClienteProvider confirmarClienteProvider =
    new ConfirmarClienteProvider();

class ConfirmarClientePage extends StatefulWidget {
  static String idRuta = "ConfirmarClientePage";

  ConfirmarClientePage({Key key}) : super(key: key);

  @override
  ConfirmarClientePageState createState() => ConfirmarClientePageState();
}

class ConfirmarClientePageState extends State<ConfirmarClientePage> {
  PageController pageController = new PageController();
  @override
  void initState() {
    super.initState();
    activoRefresh();
  }

  @override
  void dispose() {
    super.dispose();
    // activoConductor = false;
  }

  bool init = false;
  List<dynamic> listData;
  bool page = false;
  Size size;
  PreferenciasUsuario prefs = new PreferenciasUsuario();
  @override
  Widget build(BuildContext context) {
    if (!init) {
      init = true;
      prefs.ultima_pagina=ConfirmarClientePage.idRuta;
      size = MediaQuery.of(context).size;
      
    }

    listData = confirmarClienteProvider.notifiChanel;
    print(listData.toString() + "|===== Page");
    return Scaffold(
      drawer: Drawer(),
      backgroundColor: Color.fromRGBO(243, 247, 243, 1),
      appBar: AppBar(
        title: Text(
          "Encontrar Mototaxi",
          style: TextStyle(color: primaryColor),
        ),
        // leading:
        //     IconButton(icon: Icon(Icons.delivery_dining), onPressed: () {}),
        iconTheme: IconThemeData(color: primaryColor),
        backgroundColor: Colors.transparent,
        actions: actions(),
        elevation: 0,
        centerTitle: true,
      ),
      body: body(),
    );
  }

  List<Widget> actions() {
    return [
      // IconButton(icon: Icon(Icons.delivery_dining), onPressed: () {}),
      IconButton(
        icon: Icon(Icons.close_rounded),
        onPressed: () {
          confirmarClienteProvider.deleteAllnotifiChanel();
          setState(() {});
        },
      ),
    ];
  }

  body() {
    return Container(
        // color: page ? primaryColor.withOpacity(0.1) : null,
        child: listData.length != 0
            ? ListView.builder(
                itemCount: listData.length,
                // reverse: true,
                itemBuilder: (BuildContext context, int i) {
                  // int invert = listData.length - i - 1;
                  return Item(
                    estado: listData[i]['data']['estado'],
                    dataGlobal: listData[i]['data'],
                    duration: int.parse(listData[i]['duration'].toString()),
                    unique: int.parse(listData[i]['unique'].toString()),
                  );
                  // return Icon(Icons.ac_unit);
                })
            : Center(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.st,
                  children: [
                    SizedBox(height: size.height * 0.25),
                    Image.asset(
                      'assets/radar3.gif',
                      // color: Colors.grey,
                      width: 200,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Esperando ofertas de tarifas",
                      style: TextStyle(
                          fontWeight: FontWeight.w300, color: Colors.black),
                    ),
                  ],
                ),
              ));
  }

  activoRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    if (confirmarClienteProvider.notifiChanel.length == listData.length) {
    } else {
      // print('true');
      setState(() {});
    }
    activoRefresh2();
    //  activoRefresh();
    // }
  }

  activoRefresh2() async {
    // while (activo) {
    // print("try");
    await Future.delayed(Duration(seconds: 1));
    if (confirmarClienteProvider.notifiChanel.length == listData.length) {
      // print('false');
      // reload();

    } else {
      // print('true');
      setState(() {});
    }
    activoRefresh();
  }
}

class Item extends StatefulWidget {
  dynamic dataGlobal;
  int duration;
  int unique;
  String estado;

  Item({
    Key key,
    this.dataGlobal,
    this.duration,
    this.unique,
    this.estado,
  });

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  void initState() {
    super.initState();

    confirmarClienteProvider.deleteDelayNotifiChanel(
        unique: this.widget.unique, delay: this.widget.duration);

    // incioConductorProvider.searchItemNotifiChanel(
    //     unique: int.parse(this.widget.unique.toString()));
  }

  Size size;
  dynamic dataLocal;
  bool init = false;
  Map<String, dynamic> origen;
  Map<String, dynamic> destino;
  Map<String, dynamic> conductor;
  Map<String, dynamic> cliente;
  bool maxExtend = false;
  bool maxExtendRoud = false;
  EnviarNotifi enviarNotifi = new EnviarNotifi();
  TextEditingController regateoController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (!init) {
      dataLocal = this.widget.dataGlobal;
      origen = json.decode(dataLocal['origen']);
      destino = json.decode(dataLocal['destino']);
      conductor = json.decode(dataLocal['conductor']);
      cliente = json.decode(dataLocal['cliente']);
    }

    size = MediaQuery.of(context).size;
    try {
      return Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: FadeInUp(
          from: 20,
          // animate: !this.widget.activo,
          child: Dismissible(
            direction: DismissDirection.startToEnd,
            background: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.red,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Eliminar",
                      style: TextStyle(
                        color: Colors.white,
                      ))
                ],
              ),
            ),
            onDismissed: (value) {
              confirmarClienteProvider.deleteNotifiChanel(
                  unique: this.widget.unique);
            },
            key: Key(this.widget.unique.toString()),
            child: GestureDetector(
              onTap: () async {
                maxExtend = !maxExtend;
                setState(() {});
                // if (maxExtendRoud == true)
                //   await Future.delayed(Duration(milliseconds: 400));

                maxExtendRoud = !maxExtendRoud;
                setState(() {});
              },
              child: Column(
                children: [
                  Container(
                    child: Center(
                      child: Text(
                        origen["direccion"],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    height: 25,
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 400),
                    height: 75,
                    decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.3),
                        borderRadius: BorderRadius.only(
                            bottomLeft:
                                Radius.circular(maxExtendRoud != true ? 20 : 0),
                            bottomRight: Radius.circular(
                                maxExtendRoud != true ? 20 : 0))),
                    child: ListTile(
                      contentPadding: EdgeInsets.only(left: 20, right: 20),
                      trailing: Icon(
                          maxExtend != true
                              ? Icons.arrow_downward_rounded
                              : Icons.arrow_upward_rounded,
                          // size: 45,
                          color: primaryColor),
                      leading: conductor['url_foto_perfil'] == null
                          ? Container(
                              width: 0,
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(
                                  conductor['url_foto_perfil'],
                                  scale: 8)),
                      title: conductor['nombre'] == null
                          ? Container()
                          : Text(conductor['nombre']),
                      subtitle: dataLocal['oferta_conductor'] !=
                              dataLocal['oferta_cliente']
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    // Text("Oferta: "),
                                    Text(
                                      " ${formatter.format(int.parse(dataLocal['oferta_cliente'].toString()))} - ",
                                      style: TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Colors.red),
                                    ),
                                    Text(
                                      " ${formatter.format(int.parse(dataLocal['oferta_conductor'].toString() ?? ""))}",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ],
                                ),
                                Text('Fecha: ${dataLocal['fecha'] ?? ''}'),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                        " ${formatter.format(int.parse(dataLocal['oferta_conductor'].toString()))}",
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Text('Fecha: ${dataLocal['fecha'] ?? ''}'),
                              ],
                            ),
                    ),
                  ),
                  AnimatedContainer(
                    decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.4),
                        borderRadius: BorderRadius.only(
                            topLeft:
                                Radius.circular(maxExtend == true ? 0 : 20),
                            topRight:
                                Radius.circular(maxExtend == true ? 0 : 20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20))),
                    duration: Duration(
                      milliseconds: 400,
                    ),
                    curve: maxExtend == false ? Curves.ease : Curves.ease,
                    height: maxExtend == true ? 75 : 0,
                    width: maxExtend == true ? size.width : size.width * 0.75,
                    child: actions(),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      return Center(child: Text(e.toString()));
    }
  }

  actions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        horizontalRoundButton("Aceptar", onTap: () async {
          sendPeticion2(regateoController.text, "accept", pop: false);
          // print(resp.toString() + "Aquiiiiiii!!!!!-====");
          // if (resp) {

          // }
        }),
        horizontalRoundButton(
          "Rechazar",
          onTap: () async {
            sendPeticion2(regateoController.text, "denegate", pop: false);
          },
        ),
        horizontalRoundButton(
          "Regatear",
          onTap: () async {
            alerta(
              context,
              titulo: "regatear",
              contenido: Column(
                children: [
                  TextFormField(
                    controller: regateoController,
                    keyboardType: TextInputType.number,
                    // validator: (value) => validar.validateGenerico(value),
                    decoration: InputDecoration(
                      // icon: Icon(Icons.phone , color:primaryColor),
                      prefixIcon: Icon(Icons.attach_money_outlined,
                          color: primaryColor),
                      hintText: '25.2',
                      labelText: 'Nueva oferta',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onChanged: (value) {
                      // altura = double.parse(value.toString());
                    },
                  ),
                ],
              ),
              acciones: horizontalRoundButton(
                "Regatear",
                onTap: () async {
                  await sendPeticion2(
                      regateoController.text ?? dataLocal['oferta_cliente'],
                      "insert",
                      pop: true);
                },
              ),
            );
          },
        ),
      ],
    );
  }

  // sendPeticion(String precio, String tipo) async {
  //   try {
  //     load(context);
  //     dynamic bodyAux = {
  //       "data": {
  //         "tipo": tipo,
  //         "fecha": dataLocal['fecha'],
  //         "origen": origen,
  //         "destino": destino,
  //         "distancia": dataLocal['distancia'],
  //         "oferta_cliente": precio ?? dataLocal['oferta_cliente'],
  //         "oferta_conductor": dataLocal['oferta_conductor'],
  //         "estado": "pediente",
  //         "cliente": cliente,
  //         "conductor": conductor
  //       },
  //       "unique": dataLocal["unique"],
  //       "duration": "15"
  //     };
  //     print("este es el unique ");

  //     var resp = await enviarNotifi.sendNotifiMethod(
  //         bodyAux, conductor["firebase_token"]);
  //     Navigator.pop(context);
  //     if (resp["succes"] == "true") {
  //       Navigator.pop(context);
  //       confirmarClienteProvider.deleteNotifiChanel(unique: this.widget.unique);
  //       floadMessage(
  //         mensaje:
  //             "Mensaje enviado al conductor con esta oferta: ${formatter.format(int.parse(precio.toString()))}",
  //         titulo: "Mensaje",
  //       );
  //     }
  //     if (resp["succes"] == "false") {
  //       Navigator.pop(context);
  //       alerta(context,
  //           titulo: "Alerta",
  //           code: false,
  //           contenido: "Ago ha salido mal, intentelo nuevamente.");
  //     }
  //   } catch (e) {
  //     // Navigator.pop(context);
  //     print("Este es el error : $e");
  //   }
  // }

  sendPeticion2(String precio, String tipo, {bool pop = true}) async {
    try {
      load(context);

      print("DATOS DEL REPARTIDOR: ${destino["direccion"]}");
      var resp = await enviarNotifi.sendNotifiMethod({
        "tipo": tipo,
        "fecha": dataLocal["fecha"],
        "origen": origen,
        "destino": destino,
        "distancia": dataLocal["distancia"],
        "oferta_cliente": precio ?? dataLocal['oferta_cliente'],
        "oferta_conductor": dataLocal["oferta_conductor"],
        "estado": "pendiente",
        "cliente": cliente,
        "conductor": conductor
      }, conductor["firebase_token"]);
      Navigator.pop(context);
      // Navigator.pop(context);
      if (resp["succes"] == "true") {
        if (pop) {
          Navigator.pop(context);
        }
        confirmarClienteProvider.deleteNotifiChanel(unique: this.widget.unique);
        floadMessage(
          mensaje: tipo == "accept"
              ? "EPERA A TU CONDUCTOR!."
              : tipo == "denegate"
                  ? "Conductor rechazado!"
                  : "Mensaje enviado al conductor con esta oferta: ${formatter.format(int.parse(precio.toString()))}",
          titulo: "Mensaje",
        );
        if (tipo == "accept") {
          Navigator.of(context).pushReplacementNamed(
            OrderClientePage.idRuta,
            arguments: {
              "data": {
                "tipo": tipo,
                "fecha": dataLocal["fecha"],
                "origen": origen,
                "destino": destino,
                "distancia": dataLocal["distancia"],
                "oferta_cliente": dataLocal["oferta_cliente"] ?? "",
                "oferta_conductor": dataLocal["oferta_conductor"],
                "estado": "pendiente",
                "cliente": cliente,
                "conductor": conductor,
              },
              "duration": this.widget.duration,
              "unique": this.widget.unique,
            },
          );
        }
      }
      if (resp["succes"] == "false") {
        if (pop) {
          Navigator.pop(context);
        }
        alerta(context,
            titulo: "Alerta",
            code: false,
            contenido: "Ago ha salido mal, intentelo nuevamente.");
      }
    } catch (e) {
      // Navigator.pop(context);
      print("Este es el error : $e");
    }
  }
}
