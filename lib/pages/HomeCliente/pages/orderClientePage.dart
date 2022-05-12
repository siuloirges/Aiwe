import 'package:aiwe/providers/verificarAutorizacionConductor.dart';
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

class OrderClientePage extends StatefulWidget {
  static String idRuta = "OrderClientePage";
  OrderClientePage({Key key}) : super(key: key);

  @override
  _OrderClientPageState createState() => _OrderClientPageState();
}

class _OrderClientPageState extends State<OrderClientePage> {
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
      prefs.ultima_pagina = OrderClientePage.idRuta;
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
        title: Text("Recoger cliente"),
        centerTitle: true,
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
          // Divider(),
          bottom(),
        ],
      ),
    );
  }

  Widget bottom() {
    return Container(
        // color: Colors.teal,
        height: portrait ? size.height * 0.25 : size.width * 0.25,
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Divider(),
              Expanded(
                flex: 6,
                child: Container(
                  child: ListTile(
                    title: Text("rambo"),
                    subtitle: Text("3044155578"),
                    leading: CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(dataArguments['data']
                          ["conductor"]["url_foto_perfil"]),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  child: Text(
                    "Espera a tu repartidor",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor),
                  ),
                ),
              ),
            ],
          ),
        ));
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
          // autocorrect: true,
          
          onChanged: (value) {
            if (value != null) {
              olderOfferConductor = true;
              ofertaConductor = double.parse(value);
            }
          },
        ),
        done: true);
  }

  sendRegatear(int ofertaConductor) {
    Navigator.pop(context);
    floadMessage(
      mensaje:
          "Enviar mensaje al cliente con esta oferta  ${formatter.format(int.parse(ofertaConductor.toString()))}",
      titulo: "Mensaje",
    );
  }

  sendAiwe(int precio) {
    Navigator.pop(context);
    floadMessage(
      mensaje:
          "Enviar mensaje al cliente con esta oferta: ${formatter.format(int.parse(precio.toString()))}",
      titulo: "Mensaje",
    );
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
}
