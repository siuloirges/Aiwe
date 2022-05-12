import 'dart:convert';

import 'package:aiwe/utils/preferencias.dart';
import 'package:aiwe/utils/provider/sendNotifi.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:aiwe/pages/HomeConductor/utils/Providers/InicioConductorProvider.dart';
import 'package:aiwe/utils/provider/directionProvider.dart';
import 'package:aiwe/utils/global.dart';
import 'package:aiwe/utils/validaciones_utils.dart';

class InfoPageConductor extends StatefulWidget {
  static String idRuta = "InfoPageConductor";
  InfoPageConductor({Key key}) : super(key: key);

  @override
  _InfoPageConductorState createState() => _InfoPageConductorState();
}

class _InfoPageConductorState extends State<InfoPageConductor> {
  LatLng origen;
  LatLng destino;
  dynamic dataArguments;
  bool init = false;
  GoogleMapController _mapController;
  BitmapDescriptor iconOrigen;
  BitmapDescriptor iconDestino;
  DirectionProvider api;
  double ofertaConductor;
  bool olderOfferConductor = false;
  IncioConductorProvider incioConductorProvider = new IncioConductorProvider();
  PreferenciasUsuario prefs = new PreferenciasUsuario();
  EnviarNotifi enviarNotifi = new EnviarNotifi();
  @override
  void initState() {
    // TODO: implement initState
    getIcons();
  }

  Size size;
  bool portrait = false;
  Orientation orientacion;
  Validaciones validate = Validaciones();

  @override
  Widget build(BuildContext context) {
    api = Provider.of<DirectionProvider>(context);

    if (!init) {
      size = MediaQuery.of(context).size;
      orientacion = MediaQuery.of(context).orientation;

      dataArguments = ModalRoute.of(context).settings.arguments;
      origen = LatLng(
        double.parse(
          dataArguments['data']['origen']['latitude'].toString(),
        ),
        double.parse(
          dataArguments['data']['origen']['longitude'].toString(),
        ),
      );
      destino = LatLng(
        double.parse(
          dataArguments['data']['destino']['latitude'].toString(),
        ),
        double.parse(
          dataArguments['data']['destino']['longitude'].toString(),
        ),
      );
      prefs.ultima_pagina = InfoPageConductor.idRuta;
      init = true;
    }

    if (orientacion == Orientation.portrait) {
      portrait = true;
    } else {
      portrait = false;
    }
    // var googleMap =

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          _centerView();
        },
        child: Icon(
          Icons.filter_center_focus_outlined,
          color: primaryColor,
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        title: Text("Home Repartidor"),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              markers: _crearMarker(),
              initialCameraPosition: CameraPosition(target: origen, zoom: 24),
              polylines: api.currentRoute,
              onMapCreated: _onMapCreated,
            ),
          ),
          bottom(),
        ],
      ),
    );
  }

  Widget bottom() {
    int precio = int.parse(dataArguments['data']['oferta_cliente'].toString());
    List<Widget> rangeOfOffers = [];

    // double modificador = 0.1;
    for (double i = 0.4; i >= -0.4; i = i - 0.1) {
      double modifiedPrice = precio + precio * i;
      if (i == 2.7755575615628914e-17) {
        rangeOfOffers.add(horizontalRoundButton("Precio Original",
            active: ofertaConductor == null, onTap: () {
          ofertaConductor = null;
          olderOfferConductor = false;
          setState(() {});
        }));
      } else {
        rangeOfOffers.add(
          horizontalRoundButton("${formatter.format(modifiedPrice)}",
              onTap: () {
            ofertaConductor = modifiedPrice;
            olderOfferConductor = false;
            setState(() {});
          }, active: ofertaConductor == modifiedPrice),
        );
      }

      // i += 0.1;
    }
    return Container(
      // color: Colors.teal,
      height: portrait ? size.height * 0.35 : size.width * 0.35,
      width: size.width,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            horizontalScrollBox(
              size,
              list: rangeOfOffers
                ..add(horizontalRoundButton("otro",
                    active: olderOfferConductor == true, onTap: () {
                  setOlderOffer();
                })),
            ),
            precios(precio),
            primaryButton(context, size,
                texto: ofertaConductor != null ? "Regatear" : "Aiwe!",
                // onpress: ofertaConductor != null
                //     ? () {
                //         sendRegatear(ofertaConductor.toInt());
                //       }
                //     : () {
                //         sendAiwe(precio);
                //       },
                onpress: () {
              ofertaConductor != null
                  ? sendPeticion(ofertaConductor.toInt())
                  : sendPeticion(precio);
            }),
          ],
        ),
      ),
    );
  }

  Widget precios(int precio) {
    return ofertaConductor != null
        ? Column(
            children: [
              FadeInUp(
                from: 20,
                child: Text(
                  "Oferta: ${formatter.format(int.parse(precio.toString()))}",
                  style: normalTextLiteNegative,
                ),
              ),
              FadeInUp(
                from: 10,
                child: Text(
                  "Oferta: ${formatter.format(int.parse(ofertaConductor.toInt().toString()))}",
                  style: tituloStyle1Positive,
                ),
              ),
            ],
          )
        : FadeInUp(
            from: 10,
            child: Text(
                "Oferta: ${formatter.format(int.parse(precio.toString()))}",
                style: tituloStyle1Positive),
          );
  }

  setOlderOffer() {
    return alerta(context,
        titulo: "Digite el valor",
        code: true,
        contenido: TextFormField(
          inputFormatters: [
            ThousandsFormatter(formatter: NumberFormat("###,###,###", "es-co"))
          ],
          decoration: InputDecoration(hintText: "Precio"),
          keyboardType: TextInputType.number,
          validator: (value) => validate.validateNumerico(value),
          // autovalidate: true,
          onChanged: (value) {
            if (value != null) {
              olderOfferConductor = true;
              ofertaConductor = double.parse(value);
            }
          },
        ),
        done: true);
  }

  getIcons() async {
    var iconOrigen = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 1.0, size: Size(5, 5)),
        "assets/IconOrigen.png");
    setState(() {
      this.iconOrigen = iconOrigen;
    });

    var iconDestino = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 1.0, size: Size(5, 5)),
      "assets/IconDestino.png",
      mipmaps: true,
    );
    setState(() {
      this.iconDestino = iconDestino;
    });
  }

  Set<Marker> _crearMarker() {
    var tmp = Set<Marker>();
    tmp.add(Marker(
        markerId: MarkerId("Origen"),
        position: origen,
        icon: iconOrigen,
        // visible: false,
        infoWindow: InfoWindow(title: "Origen")));

    tmp.add(Marker(
        markerId: MarkerId("destino"),
        position: destino,
        icon: iconDestino,
        // visible: true,
        infoWindow: InfoWindow(title: "Destino")));
    return tmp;
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    _centerView();
  }

  _centerView() async {
    await _mapController.getVisibleRegion();

    var left = min(origen.latitude, destino.latitude);
    var right = max(origen.latitude, destino.latitude);
    var top = max(origen.longitude, destino.longitude);
    var bottom = min(origen.longitude, destino.longitude);
    var bounds = LatLngBounds(
        southwest: LatLng(left, bottom), northeast: LatLng(right, top));

    var cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 50);
    _mapController.animateCamera(cameraUpdate);

    api.findDirectionr(origen, destino);
  }

  sendPeticion(int precio) async {
    try {
      load(context);

      print("este es el unique ");
      print(
          "LA DATA DEL CLIENTE ES: -------------- ${dataArguments["data"]["origen"]}");
      var resp = await enviarNotifi.sendNotifiMethod({
        "tipo": dataArguments["data"]["tipo"],
        "fecha": dataArguments["data"]["fecha"],
        "origen": dataArguments["data"]["origen"],
        "destino": dataArguments["data"]["destino"],
        "distancia": dataArguments["data"]["distancia"],
        "oferta_cliente": dataArguments["data"]["oferta_cliente"],
        "oferta_conductor": precio.toString() ?? "0",
        "estado": "pendiente",
        "cliente": dataArguments["data"]["cliente"],
        "conductor": {
          "id": prefs.user_id ?? "0",
          "nombre": "Sergio vega ",
          "url_foto_perfil":
              "https://ep01.epimg.net/elpais/imagenes/2018/12/13/buenavida/1544715127_368245_1544786854_noticia_normal.jpg",
          "url_foto_placa":
              "https://www.asset.lion.com.co/images/productos/R3_11_2.JPG",
          "url_foto_vehicle":
              "https://i.ytimg.com/vi/KC_paKRDmiE/maxresdefault.jpg",
          "firebase_token": prefs.fcm_token
        },
      }, dataArguments["data"]["cliente"]["firebase_token"]);
      Navigator.pop(context);
      if (resp["succes"] == "true") {
        incioConductorProvider.deleteNotifiChanel(
          unique: dataArguments["unique"],
        );
        floadMessage(
          mensaje:
              "Enviar mensaje al cliente con esta oferta: ${formatter.format(int.parse(precio.toString()))}",
          titulo: "Mensaje",
        );

        Navigator.pop(context);
      }
      if (resp["succes"] == "false") {
        Navigator.pop(context);
        alerta(context,
            titulo: "Alerta",
            code: false,
            contenido: "Ago ha salido mal, intentelo nuevamente.");
      }
    } catch (e) {
      Navigator.pop(context);
      print("Este es el error : $e");
    }
  }
}
