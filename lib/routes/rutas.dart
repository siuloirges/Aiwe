import 'package:aiwe/pages/HomeCliente/HomeCliente.dart';
import 'package:aiwe/pages/HomeCliente/pages/confirmarPage.dart';
import 'package:aiwe/pages/HomeCliente/pages/orderClientePage.dart';
import 'package:aiwe/pages/HomeConductor/HomeConductor.dart';
import 'package:aiwe/pages/HomeConductor/Pages/InfoPageConductor.dart';
import 'package:aiwe/pages/HomeConductor/Pages/noAutorizadoPage.dart';
import 'package:aiwe/pages/HomeConductor/Pages/orderPage.dart';
import 'package:aiwe/pages/direcciones/mis_direcciones.dart';
import 'package:aiwe/pages/homePage/home_page.dart';
import 'package:aiwe/pages/HomeAdmin/HomeAdmin.dart';
import 'package:aiwe/pages/loginPage/login.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> rutas() {
  return <String, WidgetBuilder>{
    LoginPage.idRuta: (_) => LoginPage(),
    MisDirecciones.idRuta: (_) => MisDirecciones(),
    HomePage.idRuta: (_) => HomePage(),
    HomeCliente.idRuta: (_) => HomeCliente(),
    HomeConductor.idRuta: (_) => HomeConductor(),
    NoAutorizadoPage.idRuta: (_) => NoAutorizadoPage(),
    InfoPageConductor.idRuta: (_) => InfoPageConductor(),
    OrderPage.idRuta: (_) => OrderPage(),
    ConfirmarClientePage.idRuta: (_) => ConfirmarClientePage(),
    OrderClientePage.idRuta: (_) => OrderClientePage(),
    HomeAdmin.idRuta: (_) => HomeAdmin(),
    LoginPage.idRuta: (_) => LoginPage()
  };
}
