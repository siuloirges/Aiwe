// import 'package:aiwe/pages/HomeConductor/Pages/orderPage.dart';
import 'dart:io';
import 'package:aiwe/pages/HomeCliente/HomeCliente.dart';
import 'package:aiwe/pages/HomeConductor/HomeConductor.dart';
import 'package:aiwe/pages/loginPage/login.dart';
import 'package:aiwe/providers/verificarAutorizacionConductor.dart';
import 'package:aiwe/utils/PuhsNotifi.dart';
// import 'package:aiwe/utils/global.dart';
import 'package:aiwe/utils/preferencias.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'pages/HomeCliente/utils/ConfirmarClienteProvider.dart';
// import 'pages/HomeConductor/HomeConductor.dart';
import 'pages/HomeConductor/Pages/orderPage.dart';
import 'pages/HomeConductor/utils/Providers/InicioConductorProvider.dart';
import 'utils/provider/directionProvider.dart';

// import 'package:aiwe/pages/HomeAdmin/HomeAdmin.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;
VerificarAutorizacionConductor verificar = new VerificarAutorizacionConductor();

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationsProviders.initializeApp();
  HttpOverrides.global = new MyHttpOverrides();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}

getToken() async {
  var token = await messaging.getToken();
  PreferenciasUsuario prefs = new PreferenciasUsuario();
  print("====| token |===");
  print(token);
  prefs.fcm_token = token;
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> messengerKey =
      new GlobalKey<ScaffoldMessengerState>();
  IncioConductorProvider incioConductorProvider = IncioConductorProvider();
  ConfirmarClienteProvider confirmarClienteProvider =
      new ConfirmarClienteProvider();
  VerificarAutorizacionConductor verificarAuthConductor =
      new VerificarAutorizacionConductor();
  String auth;
  @override
  void initState() {
    PushNotificationsProviders.messagesStream.listen(
      (message) {
        print('MyApp: $message');
        checkNotifications(
          data: message,
          incioConductorProvider: incioConductorProvider,
          confirmarClienteProvider: confirmarClienteProvider,
          navigatorKey: navigatorKey,
          messengerKey: messengerKey,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    getToken();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DirectionProvider(),
        ),
      ],
      child: OKToast(
        child: MaterialApp(
          navigatorKey: navigatorKey, // Navegar
          scaffoldMessengerKey: messengerKey,
          // theme: ThemeData(primaryColor: primaryColor),
          debugShowCheckedModeBanner: false,
          title: 'Aiwe',
          home: HomeCliente(),
        ),
      ),
    );
  }

  dynamic navigator() {
    navigatorKey.currentState.pushReplacementNamed(OrderPage.idRuta);
  }

  dynamic logoutByNotify() async {
    navigatorKey.currentState.pushReplacementNamed(OrderPage.idRuta);
  }
}
