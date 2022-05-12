// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'dart:convert';

import 'dart:convert';
import 'dart:math';

import 'package:aiwe/main.dart';
import 'package:aiwe/pages/HomeCliente/utils/ConfirmarClienteProvider.dart';
import 'package:aiwe/pages/HomeConductor/Pages/orderPage.dart';
import 'package:aiwe/pages/HomeConductor/utils/Providers/InicioConductorProvider.dart';
import 'package:aiwe/utils/preferencias.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'global.dart';

// import 'package:oktoast/oktoast.dart';

// bool logout = false;

// PreferenciasUsuario incioConductorProvider = new PreferenciasUsuario();
FirebaseMessaging messaging = FirebaseMessaging.instance;
// MyApp main = new MyApp();
// IncioConductorProvider incioConductorProvider = IncioConductorProvider();

class PushNotificationsProviders extends ChangeNotifier {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String token;
  static StreamController<dynamic> _messageStream =
      new StreamController.broadcast();
  static Stream<dynamic> get messagesStream => _messageStream.stream;

  static Future _backgroundHandler(RemoteMessage message) async {
    print("Data: " + message.data.toString());
    _messageStream.add(message ?? 'No data');
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    print(message.data["nombre"]);
    _messageStream.add(message ?? 'No data');
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    print(message.data);
    _messageStream.add(message ?? 'No data');
  }

  static Future initializeApp() async {
    await Firebase.initializeApp();
    await requestPermission();
    token = await FirebaseMessaging.instance.getToken();
    print('Token: $token');
    FirebaseMessaging.onBackgroundMessage(
      (message) => _backgroundHandler(message),
    );
    FirebaseMessaging.onMessage.listen(
      (message) => _onMessageHandler(message),
    );
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) => _onMessageOpenApp(message),
    );
  }

  static requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);

    print('User push notification status ${settings.authorizationStatus}');
  }

  static closeStreams() {
    _messageStream.close();
  }
}

checkNotifications(
    {dynamic data,
    navigatorKey,
    messengerKey,
    IncioConductorProvider incioConductorProvider,
    ConfirmarClienteProvider confirmarClienteProvider}) {
  PreferenciasUsuario prefs = new PreferenciasUsuario();
  // String tipo = "accept";
  switch (prefs.role) {
    case "client":
      rolCLient(
          data: data,
          navigatorKey: navigatorKey,
          messengerKey: messengerKey,
          confirmarClienteProvider: confirmarClienteProvider);

      break;
    case "driver":
      rolDelivery(
          data: data,
          navigatorKey: navigatorKey,
          messengerKey: messengerKey,
          incioConductorProvider: incioConductorProvider);
      break;
  }
}

rolCLient(
    {dynamic data,
    navigatorKey,
    messengerKey,
    ConfirmarClienteProvider confirmarClienteProvider}) {
  switch (data.data['tipo']) {
    case 'info':
      {
        floadMessage(
          titulo: data["notification"]['title'],
          mensaje: data["notification"]['body'],
          duration: Duration(seconds: 3),
        );
      }
      break;
    case 'updateOrder':
      {
        Map<String, dynamic> origen = json.decode(data['origen']);
        Map<String, dynamic> destino = json.decode(data['destino']);
        Map<String, dynamic> conductor = json.decode(data['conductor']);
        Map<String, dynamic> cliente = json.decode(data['cliente']);
        navigatorKey.currentState?.pushReplacementNamed(
          OrderPage.idRuta,
          arguments: {
            "data": {
              "tipo": data["tipo"],
              "fecha": data['fecha'],
              "origen": origen,
              "destino": destino,
              "distancia": data['distancia'],
              "oferta_cliente": data['oferta_cliente'],
              "oferta_conductor": data['oferta_conductor'],
              "estado": data['estado'],
              "cliente": cliente,
              "conductor": conductor
            },
            "duration": "120",
            "unique": "876876",
          },
        );

        final snackBar = SnackBar(content: Text("Han aceptado tu pedido!"));
        messengerKey.currentState?.showSnackBar(snackBar);
      }
      break;
    case 'insert':
      {
        insertInChanelClient(
            confirmarClienteProvider: confirmarClienteProvider,
            data: data.data);
      }

      break;
    default:
      {}
      break;
  }
}

rolDelivery(
    {dynamic data,
    navigatorKey,
    messengerKey,
    IncioConductorProvider incioConductorProvider}) {
  switch (data.data['tipo']) {
    case 'info':
      {
        floadMessage(
          titulo: data["notification"]['title'],
          mensaje: data["notification"]['body'],
          duration: Duration(seconds: 3),
        );
      }
      break;
    case 'accept':
      {
        navigatorKey.currentState?.pushReplacementNamed(
          OrderPage.idRuta,
          arguments: {
            "data": {
              "fecha":
                  "Dia: ${DateTime.now().day} - Hora: ${DateTime.now().hour}:${DateTime.now().minute}",
              "origen": {
                "direccion": "La Iglesia Catolica",
                "latitude": "10.385587761031147",
                "longitude": "-75.45755271775994"
              },
              "destino": {
                "direccion": "La Iglesia Catolica",
                "latitude": "10.38585377390966",
                "longitude": "-75.45587896790576"
              },
              "distancia": "5.0",
              "oferta_cliente": "5000",
              "oferta_conductor": "",
              "estado": "inicial",
              "cliente": {
                "id": "1",
                "nombre": "Pepe Luis",
                "url_foto_perfil":
                    "https://ep01.epimg.net/elpais/imagenes/2018/12/13/buenavida/1544715127_368245_1544786854_noticia_normal.jpg",
                "firebase_token": "",
              },
              "conductor": {
                "id": "1",
                "nombre": "Pepe Luis",
                "url_foto_perfil":
                    "https://ep01.epimg.net/elpais/imagenes/2018/12/13/buenavida/1544715127_368245_1544786854_noticia_normal.jpg",
                "firebase_token": "",
              },
            },
            "duration": "15",
            "unique": "876876",
          },
        );

        final snackBar = SnackBar(content: Text("Han aceptado tu pedido!"));
        messengerKey.currentState?.showSnackBar(snackBar);
      }
      break;
    case 'insert':
      {
        insertInChanelConductor(
            incioConductorProvider: incioConductorProvider, data: data.data);
      }

      break;
    case 'denegate':
      {
        Map<String, dynamic> cliente = json.decode(data.data['cliente']);
        // insertInChanelConductor(
        //     incioConductorProvider: incioConductorProvider, data: data.data);
        incioConductorProvider.deleteNotifiChanel(unique: data.data['unique']);
        floadMessage(
          mensaje: "El cliente ${cliente['nombre']}, Rechazó tu pedido",
          titulo: "Mensaje",
        );
      }

      break;
    default:
      {}
      break;
  }
}

insertInChanelConductor({data, IncioConductorProvider incioConductorProvider}) {
  int unique = DateTime.now().microsecond +
      DateTime.now().millisecond +
      DateTime.now().second +
      DateTime.now().minute +
      DateTime.now().day +
      DateTime.now().month +
      DateTime.now().year;
  // TODO Introducir data real
  activoConductor
      ? incioConductorProvider.notifiChanel = {
          "data": data,
          "duration": "15",
          "unique": unique,
        }
      : null;
}

insertInChanelClient(
    {data, ConfirmarClienteProvider confirmarClienteProvider}) {
  int unique = DateTime.now().microsecond +
      DateTime.now().millisecond +
      DateTime.now().second +
      DateTime.now().minute +
      DateTime.now().day +
      DateTime.now().month +
      DateTime.now().year;

  int min = 0;
  int max = 3;
  Random estado = new Random();
  var rd = min + estado.nextInt(max - min);

  // TODO Introducir data real
  confirmarClienteProvider.notifiChanel = {
    "data": data,
    "duration": "1000",
    "unique": unique,
  };
}
