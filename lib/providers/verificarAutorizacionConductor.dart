import 'package:aiwe/pages/HomeConductor/HomeConductor.dart';
import 'package:aiwe/utils/preferencias.dart';
import 'package:aiwe/utils/provider/PeticionesHttp.dart';

PeticionesHttpProvider http = new PeticionesHttpProvider();
PreferenciasUsuario prefs = new PreferenciasUsuario();

class VerificarAutorizacionConductor {
  obtenerRepartidorMethod() async {
    try {
      dynamic resp = await http.postMethod(
        table: "refresh",
        body: {
          "refresh_token": "${prefs.refresh_token}",
          "user_id": "${int.parse(prefs.user_id)}"
        },
      );

      if (resp["message"] == "true") {
        if (resp["data"]["user"]["role"] == "driver") {
          if (prefs.authorized == "0" &&
              resp["data"]["user"]["authorized"].toString() == "1") {
            prefs.ultima_pagina = HomeConductor.idRuta;
          }
          prefs.authorized = resp["data"]["user"]["authorized"].to;
        }
        prefs.token = prefs.authorized = resp["data"]["auth"]["access_token"];
        prefs.refresh_token = resp["data"]["auth"]["refresh_token"];
      }
    } catch (e) {}
  }
}
