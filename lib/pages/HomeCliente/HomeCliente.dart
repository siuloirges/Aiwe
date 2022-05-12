import 'dart:convert';
import 'dart:math';
import 'dart:ui';
// import 'package:address_search_text_field/address_search_text_field.dart';
import 'package:aiwe/utils/global.dart';
import 'package:aiwe/utils/preferencias.dart';
import 'package:aiwe/utils/provider/directionProvider.dart';
import 'package:aiwe/utils/validaciones_utils.dart';
import 'package:aiwe/utils/widget/drawer.dart';
import 'package:flutter/material.dart';
import 'package:geodesy/geodesy.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pattern_formatter/numeric_formatter.dart';

import 'dart:async';

import 'package:provider/provider.dart';

import 'pages/confirmarPage.dart';

// import 'package:google_maps_webservice/places.dart';

// import 'package:flutter/foundation.dart';

class HomeCliente extends StatefulWidget {
  static String idRuta = "HomeCliente";
  HomeCliente({Key key}) : super(key: key);

  @override
  HomeClienteState createState() => HomeClienteState();
}

class HomeClienteState extends State<HomeCliente> {
  Completer<GoogleMapController> _googleMapController = Completer();
  geo.Geodesy _geodesy = new geo.Geodesy();
  GoogleMapController _mapController;
  Position currentPositionCenterView;
  Map<String, String> nameCurrentPositionCenterView;
  bool loadintCurrentPositionCenterView = true;
  int countCurrentPositionCenter = 0;
  String typeCurrentPositionCenterView = "none";
  BitmapDescriptor iconOrigen;
  BitmapDescriptor iconDestino;

  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(10.399015, -75.504599),
    zoom: 20,
  );

  bool init = false;
  Size size;
  bool portrait = false;
  bool maximumExtensionBottomMenu = false;
  var listMarker = Set<Marker>();
  List<Map> dataListMarker = [];
  Orientation orientacion;
  bool loadOrigenDireccion = false;
  bool loaddestidoDireccion = false;
  DirectionProvider api;
  Validaciones validate = Validaciones();
  TextEditingController precioController = new TextEditingController();
  PreferenciasUsuario prefs = new PreferenciasUsuario();
  @override
  void initState() {
    getIcons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    api = Provider.of<DirectionProvider>(context);
    size = MediaQuery.of(context).size;
    orientacion = MediaQuery.of(context).orientation;

    if (init == false) {
      prefs.ultima_pagina = HomeCliente.idRuta;
      init = true;
    }

    if (orientacion == Orientation.portrait) {
      portrait = true;
    } else {
      portrait = false;
    }

    return Scaffold(
      drawer: MenuDesplegable(),
      body: Stack(
        children: [
          mapa(),
          centerPointer(),
          accions(),
          bottomMenu(),
        ],
      ),
    );
  }

  Widget accions() {
    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Builder(
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        FloatingActionButton(
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          backgroundColor: Colors.white,
                          child: Icon(Icons.menu, color: primaryColor),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Container(
                height: size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: FloatingActionButton(
                        backgroundColor: themeColor,
                        onPressed: () {
                          // _centerView();
                        },
                        child: Icon(
                          Icons.center_focus_strong,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: FloatingActionButton(
                        backgroundColor: themeColor,
                        onPressed: () {
                          _getCurrentLocation();
                        },
                        child: Icon(
                          Icons.my_location_outlined,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: FloatingActionButton(
                        backgroundColor: themeColor,
                        onPressed: () {},
                        child: Icon(
                          Icons.search_rounded,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  mapa() {
    return GoogleMap(
      polylines: api.currentRoute,
      markers: listMarker,
      onCameraMoveStarted: () {
        maximumExtensionBottomMenu = false;
        setState(() {});
      },
      onCameraMove: _onCameraMove,
      // polylines: ,
      zoomControlsEnabled: false,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      initialCameraPosition: _kGooglePlex,
      onMapCreated: _onMapCreated,
    );
  }

  void _onCameraMove(CameraPosition position) async {
    if (currentPositionCenterView != null) {
      double distance = _geodesy.distanceBetweenTwoGeoPoints(
          geo.LatLng(position.target.latitude, position.target.longitude),
          geo.LatLng(currentPositionCenterView.latitude,
              currentPositionCenterView.longitude));

      if (distance > 10) {
        try {
          countCurrentPositionCenter++;
        } catch (e) {
          print(e);
          countCurrentPositionCenter = 0;
          countCurrentPositionCenter++;
        }
        // print("distancia: " + distance.toString());
        currentPositionCenterView = Position(
            latitude: position.target.latitude,
            longitude: position.target.longitude);
        print(
            "Current posicion: -->> | " + currentPositionCenterView.toString());
        loadintCurrentPositionCenterView = true;
        getNameCurrentPosition(position, countCurrentPositionCenter);
      }
    }
  }

  Widget bottomMenu() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: BackdropFilter(
        filter: maximumExtensionBottomMenu
            ? ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0)
            : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
        child: GestureDetector(
            onTapUp: typeCurrentPositionCenterView == "none"
                ? (w) async {
                    setState(() {
                      maximumExtensionBottomMenu = !maximumExtensionBottomMenu;
                    });
                  }
                : (w) async {
                    addMarkers(
                        currentPositionCenterView.latitude,
                        currentPositionCenterView.longitude,
                        typeCurrentPositionCenterView);
                    setState(() {
                      maximumExtensionBottomMenu = !maximumExtensionBottomMenu;
                    });

                    typeCurrentPositionCenterView = 'none';
                  },
            child: ClipRRect(
              child: AnimatedContainer(
                decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black.withOpacity(.1)),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                    )),
                alignment: Alignment.bottomCenter,
                width: size.width / 1.1,
                // alignment: Alignment.bottomCenter,
                height: maximumExtensionBottomMenu
                    ? size.height * 0.6
                    : size.height * 0.08,
                child: maximumExtensionBottomMenu
                    ? bodyBottomMenu()
                    : Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                typeCurrentPositionCenterView == "none"
                                    ? "Abrir"
                                    : "Listo",
                                style: tituloStyle1,
                              ),
                              Icon(
                                  typeCurrentPositionCenterView == "none"
                                      ? Icons.arrow_upward_sharp
                                      : Icons.done,
                                  color: Colors.black),
                            ],
                          ),
                        ),
                      ),
                duration: Duration(milliseconds: 300),
                curve: Curves.ease,
              ),
            )),
      ),
    );
  }

  Widget bodyBottomMenu() {
    try {
      return Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("¿Donde vas?", style: tituloStyle1),
                      Icon(
                        Icons.arrow_downward_rounded,
                        color: Colors.black,
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  itemUbication("origen", loadOrigenDireccion),
                  itemUbication("destino", loaddestidoDireccion),
                  campoTexto(),
                  SizedBox(height: 20),
                  primaryButton(context, size,
                      texto: "Buscar Moto",
                      onpress: loadOrigenDireccion == false &&
                              loaddestidoDireccion == false &&
                              dataListMarker.length >= 2 &&
                              precioController.text.length != 0
                          ? () {
                              Navigator.of(context)
                                  .pushNamed(ConfirmarClientePage.idRuta);
                            }
                          : null),
                ],
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      return Center(child: Text("$e"));
    }
  }

  Widget campoTexto() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: TextFormField(
        controller: precioController,
        inputFormatters: [
          ThousandsFormatter(formatter: NumberFormat("###,###,###", "es-co"))
        ],
        decoration: InputDecoration(
          hintText: "Precio",
          labelText: "Tarifa sugerida",
          // labelStyle: TextStyle(),

          border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
        ),

        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(color: primaryColor),

        validator: (value) => validate.validateNumerico(value),
        // autovalidate: true,
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  _centerView() async {
    if (dataListMarker.length >= 2) {
      await _mapController.getVisibleRegion();
      LatLng origen;
      LatLng destino;

      dataListMarker?.forEach((element) {
        if (element["markerId"] == "origen") {
          origen = LatLng(double.parse(element['latitude'].toString()),
              double.parse(element['longitude'].toString()));
        }
        if (element["markerId"] == "destino") {
          destino = LatLng(double.parse(element['latitude'].toString()),
              double.parse(element['longitude'].toString()));
        }
      });
      var left = min(origen.latitude, destino.latitude);
      var right = max(origen.latitude, destino.latitude);
      var top = max(origen.longitude, destino.longitude);
      var bottom = min(origen.longitude, destino.longitude);
      var bounds = LatLngBounds(
          southwest: LatLng(left, bottom), northeast: LatLng(right, top));

      var cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 100);
      _mapController.animateCamera(cameraUpdate);
    }
    // api.findDirectionr(origen, destino);
  }

  itemUbication(String markerId, bool load) {
    dynamic data = {"direccion": "Marcar $markerId"};

    dataListMarker?.forEach((element) {
      if (element["markerId"] == markerId) {
        data = element;
      }
    });
    print(dataListMarker.length.toString() + "largo de lista");

    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.all(0),
          onTap: () {
            if (markerId == "origen") {
              loadOrigenDireccion = true;
            } else {
              loaddestidoDireccion = true;
            }
            typeCurrentPositionCenterView = "$markerId";
            setState(() {
              maximumExtensionBottomMenu = !maximumExtensionBottomMenu;
            });
          },
          leading: Icon(
            Icons.location_on,
            color: primaryColor,
          ),
          trailing: Icon(
            Icons.edit,
            color: primaryColor,
          ),
          title: Text(
            "$markerId",
            style: tituloStyle1,
            // maxLines: ,
          ),
          subtitle: load
              ? linearLoading()
              : Text(
                  data['direccion'],
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
        ),
        Divider(),
      ],
    );
  }

  getIcons() async {
    var iconOrigen = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 1.0, size: Size(5, 5)),
        "assets/IconOrigen.png");
    this.iconOrigen = iconOrigen;
    // setState(() {
    // });

    var iconDestino = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 1.0, size: Size(5, 5)),
      "assets/IconDestino.png",
      mipmaps: true,
    );
    this.iconDestino = iconDestino;
    // setState(() {
    // });
  }

  addMarkers(double latitude, double longitude, String tipo) {
    listMarker.add(Marker(
        markerId: MarkerId("$tipo"),
        position: LatLng(latitude, longitude),
        icon: tipo == "origen" ? iconOrigen : iconDestino,

        // visible: false,
        infoWindow: InfoWindow(title: "$tipo")));

    buscarDireccion(
      "$tipo",
      latitude,
      longitude,
    );

    // setState(() {});
  }

  buscarDireccion(
    String markerId,
    double latitude,
    double longitude,
  ) async {
    final _ip = 'https://nominatim.openstreetmap.org/reverse/?format=json' +
        '&lat=$latitude&lon=$longitude';

    var url = Uri.parse(_ip);
    // var response = await http.post(url);

    final resp = await http.get(url).catchError((onError) {
      print('Provider: ' + onError);
    });

    final respJson = json.decode(resp.body);

    bool buscar = false;
    int index = 0;

    dataListMarker?.forEach((element) {
      if (element["markerId"] == markerId) {
        print("===| update");
        buscar = true;
        dataListMarker[index] = {
          "markerId": markerId,
          // "direccion": 'hola',
          "direccion": respJson['display_name'],
          "latitude": latitude,
          "longitude": longitude
        };
        if (markerId == "origen") {
          loadOrigenDireccion = false;
        } else {
          loaddestidoDireccion = false;
        }
      }
      index++;
    });

    if (buscar == false) {
      print("===| Create");
      dataListMarker.add({
        "markerId": markerId,
        // "direccion": 'asd',
        "direccion": respJson['display_name'],
        "latitude": latitude,
        "longitude": longitude
      });
      if (markerId == "origen") {
        loadOrigenDireccion = false;
      } else {
        loaddestidoDireccion = false;
      }
      // setState(() {});
    }
    calcularRuta();
    setState(() {});
  }

  calcularRuta() {
    if (dataListMarker.length >= 2) {
      LatLng origen;
      LatLng destino;

      dataListMarker?.forEach((element) {
        if (element["markerId"] == "origen") {
          origen = LatLng(double.parse(element['latitude'].toString()),
              double.parse(element['longitude'].toString()));
        }
        if (element["markerId"] == "destino") {
          destino = LatLng(double.parse(element['latitude'].toString()),
              double.parse(element['longitude'].toString()));
        }
      });
      api.findDirectionr(origen, destino);
    }
  }

  Widget centerPointer() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              // width: 120,
              decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(100)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: loadintCurrentPositionCenterView
                    ? Container(
                        width: 50,
                        height: 18,
                        child: Center(
                          child: Container(
                            height: 2,
                            child: linearLoading(),
                          ),
                        ))
                    : Text(
                        "${nameCurrentPositionCenterView['name'] == "Unnamed Road" ? "Sin nombre" : nameCurrentPositionCenterView['name']}",
                        style: TextStyle(color: Colors.white),
                      ),
              )),
          SizedBox(
            height: 20,
          ),
          Image(
            image: AssetImage(
              "assets/IconLocation.png",
            ),
            width: 30,
          ),
          CircleAvatar(
              radius: 59,
              child: Align(
                alignment: Alignment.topCenter,
                child: CircleAvatar(
                  radius: 6,
                  backgroundColor: Colors.blue.withOpacity(0.5),
                  child: CircleAvatar(
                    radius: 3,
                    backgroundColor: Colors.blue.withOpacity(0.5),
                  ),
                ),
              ),
              backgroundColor: Colors.transparent)
        ],
      ),
    );
  }

  getNameCurrentPosition(CameraPosition position, int index) async {
    // setState(() {});
    await Future.delayed(Duration(seconds: 1));

    if (countCurrentPositionCenter == index) {
      print(index);
      setState(() {
        loadintCurrentPositionCenterView = true;
      });

      var value = await Geolocator().placemarkFromCoordinates(
          position.target.latitude, position.target.longitude);

      nameCurrentPositionCenterView = {
        "name": value[0].name,
        "subAdministrativeArea": value[0].subAdministrativeArea
      };

      print("Actual");
      setState(() {
        loadintCurrentPositionCenterView = false;
      });
    } else {
      print("-- No actual");
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _googleMapController.complete(controller);
    _mapController = controller;

    _getCurrentLocation();
  }

  _getCurrentLocation() async {
    await _mapController.getVisibleRegion();

    //00110011

    // final geolocator = Geolocator().forceAndroidLocationManager;

    // print(geolocator);

    // bool status = geolocator;
    // if (!status) return _showDialogGps(geolocator);

    Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) async {
      final GoogleMapController controller = await _googleMapController.future;
      currentPositionCenterView = position;
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          new CameraPosition(
              zoom: 17, target: LatLng(position.latitude, position.longitude)),
        ),
      );

      //  Future.delayed(Duration(seconds: 2));
      // if (init == false) {
      addMarkers(currentPositionCenterView.latitude,
          currentPositionCenterView.longitude, "origen");

      await Future.delayed(Duration(milliseconds: 250));
      loadOrigenDireccion = true;
      maximumExtensionBottomMenu = true;
      setState(() {});
      // }
    }).catchError(
      (e) {
        print(e);
      },
    );
  }

  _showDialogGps(bool geolocator) async {
    alerta(
      context,
      titulo: "Obligatorio",
      contenido: "Activa el GPS para continuar",
      code: false,
      acciones: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Container(
            child: RaisedButton(
              color: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: new Text("Listo!", style: TextStyle(color: Colors.white)),
              onPressed: () async {
                bool status = geolocator;
                if (status) {
                  Navigator.pop(context);
                  _getCurrentLocation();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
