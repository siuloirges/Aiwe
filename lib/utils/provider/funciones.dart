import 'package:aiwe/utils/global.dart';
import '../preferencias.dart';
import 'package:http/http.dart' as http;

class Funciones {
  // PeticionesHttpProvider http = PeticionesHttpProvider();
  PreferenciasUsuario _pref = new PreferenciasUsuario();
  closeSection(context) async {
    try {
      Map<String, String> head = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_pref.token}'
      };

      dynamic resp = await http.get(Uri.parse('$ip'), headers: head);
      print(resp.body);
      prefDelete();
    } catch (e) {
      prefDelete();
      print(e);
    }
  }

  prefDelete() {
    //TODO  BORRAR TODAS LAS PREFERENCIAS
    _pref.token = null;
    _pref.refresh_token = null;
    _pref.ultima_pagina = null;
    _pref.user_id = null;
    print('PREF DELETE');
  }
}
