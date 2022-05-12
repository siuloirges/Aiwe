// import 'dart:ui';

// import 'package:aiwe/pages/HomeConductor/utils/Providers/InicioConductorProvider.dart';
import 'dart:convert';

import 'package:aiwe/pages/HomeConductor/Pages/InfoPageConductor.dart';
import 'package:aiwe/pages/HomeConductor/utils/Providers/InicioConductorProvider.dart';
import 'package:aiwe/utils/global.dart';
import 'package:aiwe/utils/preferencias.dart';
import 'package:aiwe/utils/widget/drawer.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

IncioConductorProvider incioConductorProvider = new IncioConductorProvider();

class HomeConductor extends StatefulWidget {
  static String idRuta = "HomeConductor";
  HomeConductor({Key key}) : super(key: key);
  @override
  HomeConductorState createState() => HomeConductorState();
}
class HomeConductorState extends State<HomeConductor> {
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
  File imagenPerfil;
  PreferenciasUsuario prefs = new PreferenciasUsuario();

  Size size;
  @override
  Widget build(BuildContext context) {
    if (!init) {
      prefs.ultima_pagina = HomeConductor.idRuta;
      init = true;
      size = MediaQuery.of(context).size;
    }

    listData = incioConductorProvider.notifiChanel;

    print(listData.toString() + "|===== Page");
    
    return Scaffold(
      drawer: MenuDesplegable(),
      backgroundColor: Color.fromRGBO(243, 247, 243, 1),
      appBar: AppBar(
        iconTheme: IconThemeData(color: primaryColor),
        backgroundColor: Colors.transparent,
        actions: actions(),
        elevation: 0,
        centerTitle: true,
        title: active(),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 2,
                child: tapBar(),
              ),
              Expanded(
                flex: 20,
                child: body(),
              ),
              Divider(
                height: 0,
                color: primaryColor.withOpacity(0.5),
              ),
              Expanded(
                flex: 3,
                child: control(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Future<Map<String, dynamic>> subirImagen(File imagen) async {
  //   final url = Uri.parse('$ip/subirImagen');
  //   print(mime(imagen.path));
  //   final mimeType = mime(imagen.path).split('/');
  //   final imageUploadRequest = http.MultipartRequest(
  //     'POST',
  //     url,
  //   );

  //   final file = await http.MultipartFile.fromPath('file', imagen.path,
  //       contentType: MediaType(mimeType[0], mimeType[1]));

  //   imageUploadRequest.files.add(file);
  //   final streamResponse = await imageUploadRequest.send();
  //   final resp = await http.Response.fromStream(streamResponse);
  //   //print(resp.body);
  //   if (resp.statusCode == 200) {
  //     final respData = json.decode(resp.body);
  //     // print(respData);
  //     return respData;
  //   } else {
  //     return {"success": false, "message": 'Algo Salio mal'};
  //   }
  // }

  // Future cargarImageCamera() async {
  //   print("ABCDEFG");
  //   var tempImageCamera = await ImagePicker.pickImage(
  //       maxHeight: 480, maxWidth: 640, source: ImageSource.camera);

  //   setState(() {
  //     imagenPerfil = tempImageCamera;
  //   });
  // }

  Widget active() {
    return GestureDetector(
      onTap: () {
        activoConductor = !activoConductor;
        incioConductorProvider.deleteAllnotifiChanel();
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                activoConductor ? 'activo' : 'Inactivo',
                style: TextStyle(
                    color: activoConductor ? primaryColor : Colors.black45),
              ),
              Switch(
                activeColor: primaryColor,
                onChanged: (value) {
                  activoConductor = value;
                  incioConductorProvider.deleteAllnotifiChanel();
                  setState(() {});
                },
                value: activoConductor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> actions() {
    return [
      IconButton(icon: Icon(Icons.delivery_dining), onPressed: () {}),
      IconButton(
        icon: Icon(Icons.close_rounded),
        onPressed: () {
          incioConductorProvider.deleteAllnotifiChanel();
          setState(() {});
        },
      ),
    ];
  }

  body() {
    return PageView(
      onPageChanged: (value) {
        // print(pageController.);
        page = !page;
        setState(() {});
      },
      controller: pageController,
      children: [
        estadoPagina('inicial', 'Esperando solicitudes cercanas.'),
        estadoPagina('pendiente', 'Esperando respuesta de pocibles clientes.'),
      ],
    );
  }

  tapBar() {
    return Container(
      // color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          itemEstado('Inicial', page == false),
          SizedBox(
            width: 10,
          ),
          itemEstado('En proceso', page == true),
        ],
      ),
    );
  }

  Widget control() {
    return Container(
      // color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              // page = !page;
              pageController.previousPage(
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
              setState(() {});
            },
            child: Container(
              width: size.width / 2,
              height: size.height,
              color: Colors.transparent,
              // width: size.width / 2,
              child: Icon(
                Icons.arrow_back_ios_rounded,
                color: primaryColor,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // page = !page;
              pageController.nextPage(
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
              setState(() {});
            },
            child: Container(
              width: size.width / 2,
              height: size.height,
              color: Colors.transparent,
              // width: size.width / 2,
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: primaryColor,
              ),
              // height: 200,
            ),
          ),
        ],
      ),
    );
  }

  itemEstado(String estado, bool active) {
    return GestureDetector(
      onTap: () {
        if (active == false && estado == "Inicial") {
          pageController.previousPage(
              duration: Duration(milliseconds: 500), curve: Curves.ease);
        } else if (active == false && estado == "En proceso") {
          pageController.nextPage(
              duration: Duration(milliseconds: 500), curve: Curves.ease);
        }
        setState(() {});
      },
      child: Container(
        color: Colors.transparent,
        child: Container(
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('$estado',
                  style: TextStyle(
                      color: active ? primaryColor : Colors.grey,
                      fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                child: Container(
                  color: active ? primaryColor : Colors.grey,
                  height: 2,
                  width: size.width / 2 - 20,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  estadoPagina(String estado, String subTitle) {
    List<dynamic> filtroList = [];
    listData.forEach((element) {
      if (element['data']['estado'] == estado) {
        filtroList.add(element);
      }
    });

    return Container(
      // color: page ? primaryColor.withOpacity(0.1) : null,
      child: activoConductor
          ? filtroList.length != 0
              ? ListView.builder(
                  itemCount: filtroList.length,
                  // reverse: true,
                  itemBuilder: (BuildContext context, int i) {
                    // int invert = listData.length - i - 1;
                    try {
                      return Item(
                        estado: filtroList[i]['data']['estado'],
                        dataGlobal: filtroList[i]['data'],
                        duration: int.parse(filtroList[i]['duration']),
                        unique: int.parse(filtroList[i]['unique'].toString()),
                      );
                    } catch (e) {}
                    // return Icon(Icons.ac_unit);
                  })
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/radar3.gif',
                        // color: Colors.grey,
                        width: 200,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "$subTitle",
                        style: TextStyle(
                            fontWeight: FontWeight.w300, color: Colors.black),
                      ),
                    ],
                  ),
                )
          : Center(
              child: Text(
                "Activa tu puesto para empezar",
                style:
                    TextStyle(fontWeight: FontWeight.w300, color: Colors.black),
              ),
            ),
    );
  }

  activoRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    if (activoConductor &&
        incioConductorProvider.notifiChanel.length == listData.length) {
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
    if (activoConductor &&
        incioConductorProvider.notifiChanel.length == listData.length) {
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

    this.widget.estado == "inicial"
        ? incioConductorProvider.deleteDelayNotifiChanel(
            unique: this.widget.unique, delay: this.widget.duration)
        : null;

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
  @override
  Widget build(BuildContext context) {
    if (!init) {
      dataLocal = this.widget.dataGlobal;
      origen = json.decode(dataLocal['origen']);
      destino = json.decode(dataLocal['destino']);
      conductor = json.decode(dataLocal['conductor']);
      cliente = json.decode(dataLocal['cliente']);
      print("DATA LOCAL ==========" + dataLocal['cliente']);
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
              incioConductorProvider.deleteNotifiChanel(
                  unique: this.widget.unique);
            },
            key: Key(this.widget.unique.toString()),
            child: GestureDetector(
              onTap: () {
                print(
                    "CLIENTE DESDE HOME CONDUCTOR: ${cliente["firebase_token"]}");
                Navigator.of(context).pushNamed(
                  InfoPageConductor.idRuta,
                  arguments: {
                    "data": {
                      "tipo": dataLocal["tipo"],
                      "fecha": dataLocal['fecha'],
                      "origen": origen,
                      "destino": destino,
                      "distancia": dataLocal['distancia'],
                      "oferta_cliente": dataLocal['oferta_cliente'],
                      "oferta_conductor": dataLocal['oferta_conductor'],
                      "estado": dataLocal['estado'],
                      "cliente": cliente,
                      "conductor": conductor
                    },
                    "unique": this.widget.unique,
                  },
                );
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
                  Container(
                    height: 75,
                    decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.3),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20))),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.only(left: 20, right: 20),
                          trailing: CircleAvatar(
                            backgroundColor: Color.fromRGBO(
                                212, 323, this.widget.unique, 0.4),
                            child:
                                Icon(Icons.remove_red_eye, color: Colors.white),
                          ),
                          leading: cliente['url_foto_perfil'] == null
                              ? Container(
                                  width: 0,
                                )
                              : CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      cliente['url_foto_perfil'],
                                      scale: 8)),
                          title: cliente['nombre'] == null
                              ? Container()
                              : Text(cliente['nombre']),
                          subtitle: dataLocal['oferta_cliente'] == null
                              ? Container()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text("Oferta: "),
                                        Text(
                                            " ${formatter.format(int.parse(dataLocal['oferta_cliente'].toString()))}"),
                                      ],
                                    ),
                                    Text('Fecha: ${dataLocal['fecha'] ?? ''}'),
                                  ],
                                ),
                        ),
                        // Container(
                        //   child:
                        //   height: 20,
                        //   width: 60,
                        //   decoration: BoxDecoration(
                        //       color:
                        //           Color.fromRGBO(111, 111, this.widget.unique, 1),
                        //       borderRadius: BorderRadius.only(
                        //           bottomLeft: Radius.circular(10),
                        //           bottomRight: Radius.circular(10))),
                        // )
                        // Container(
                        //   width: size.width - 40,
                        //   // width: 50,
                        //   height: 2,
                        //   color: Colors.amber,
                        //   child: SlideInLeft(
                        //     // key: Key(this.widget.unique.toString()),
                        //     from: size.width,
                        //     duration: Duration(
                        //       seconds: this.widget.duration,
                        //     ),
                        //     child: Container(
                        //       width: size.width,
                        //       color: Colors.white,
                        //       height: 2,
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
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
}
