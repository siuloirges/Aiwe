import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../global.dart';
import '../preferencias.dart';

class PeticionesHttpProvider {
  PreferenciasUsuario prefs = new PreferenciasUsuario();
  postMethod(
      {BuildContext context, String table, Map body, String token}) async {
    Map<String, String> head;

    if (token != null) {
      head = {'Accept': 'application/json', 'Authorization': 'Bearer $token'};
    } else {
      head = {'Accept': 'application/json'};
    }

    try {
      dynamic resp = await http
          .post(Uri.parse(ip + '/$table'), body: body, headers: head)
          .timeout(Duration(seconds: 20), onTimeout: () {
        throw {
          {
            "error":
                "Se acabo el tiempo de espera, verifica tu conexion a internet"
          }
        };
      });
      // print(resp/body);

      Map<String, dynamic> decodeResp = json.decode(resp.body);

      if (resp.statusCode != 200) {
        print(resp.body);
        if (decodeResp['message'] == 'Unauthenticated.') {
          return {'message': "expiro", 'data': decodeResp, 'resp': resp};
        } else {
          return {
            'message': "false",
            'errors': decodeResp['errors'],
            'resp': resp.body
          };
        }
      } else {
        print(resp.body);
        return {'message': "true", 'data': decodeResp};
      }
    } catch (e) {
      print(e);
      return {"error": "$e"};
    }
  }

  getMethod({BuildContext context, String table, String token}) async {
    Map<String, String> head;

    if (token != null) {
      head = {'Accept': 'application/json', 'Authorization': 'Bearer $token'};
    } else {
      head = {'Accept': 'application/json'};
    }

    try {
      dynamic resp = await http.get(
        Uri.parse(ip + '/$table'),
        headers: head,
      );

      Map<dynamic, dynamic> decodeResp = json.decode(resp.body);

      if (resp.statusCode != 200) {
        print(resp.body);
        // "message": "Unauthenticated."
        if (decodeResp['message'] == 'Unauthenticated.') {
          // Navigator.of(context).pushReplacementNamed('inicio${prefs.rol}');
          // Navigator.of(context).pushReplacementNamed('IniciarSesion');
          return {'message': "expiro", 'data': decodeResp, 'resp': resp};
        }
        return {'message': "false", 'data': decodeResp, 'resp': resp};
      } else {
        print(resp.body);
        return {
          'message': "true",
          'data': decodeResp['data'],
          'resp': resp.body
        };
      }
    } catch (e) {
      // Navigator.pop(context);
      return {"error": "$e"};
    }
  }

  putMethod(
      {BuildContext context,
      String table,
      Map<String, String> body,
      String token,
      int id}) async {
    Map<String, String> head;
    if (token != null) {
      head = {'Accept': 'application/json', 'Authorization': 'Bearer $token'};
    } else {
      head = {'Accept': 'application/json'};
    }
    try {
      dynamic resp = await http
          .put(Uri.parse(ip + '/$table/$id'), body: body, headers: head)
          .timeout(Duration(seconds: 10), onTimeout: () {
        throw {
          Navigator.pop(context),
          alerta(
            context,
            contenido: Text(
              "No hay conexion con el servidor.",
            ),
          ),
        };
      });
      Map<String, dynamic> decodeResp = json.decode(resp.body);
      print(resp.body);

      if (resp.statusCode != 200) {
        print(resp.body);
        if (decodeResp['message'] == 'Unauthenticated.') {
          // Navigator.of(context).pushReplacementNamed('IniciarSesion');
          return {'message': "expiro", 'data': decodeResp, 'resp': resp};
        }
        return {'message': "false", 'errors': decodeResp['errors']};
      } else {
        print(resp.body);
        return {'message': "true", 'data': decodeResp['data'], 'resp': resp};
      }
    } catch (e) {
      return {"error": "$e"};
    }
  }

  putArgumentMethod(
      {BuildContext context,
      String table,
      Map<String, String> body,
      String token}) async {
    Map<String, String> head;
    if (token != null) {
      head = {'Accept': 'application/json', 'Authorization': 'Bearer $token'};
    } else {
      head = {'Accept': 'application/json'};
    }
    try {
      dynamic resp = await http
          .put(Uri.parse(ip + '/$table'), body: body, headers: head)
          .timeout(Duration(seconds: 10), onTimeout: () {
        throw {
          Navigator.pop(context),
          alerta(
            context,
            contenido: Text(
              "No hay conexion con el servidor.",
            ),
          ),
        };
      });
      Map<String, dynamic> decodeResp = json.decode(resp.body);
      print(resp.body);

      if (resp.statusCode != 200) {
        print(resp.body);
        if (decodeResp['message'] == 'Unauthenticated.') {
          // Navigator.of(context).pushReplacementNamed('IniciarSesion');
          return {'message': "expiro", 'data': decodeResp, 'resp': resp};
        }
        return {'message': "false", 'errors': decodeResp['errors']};
      } else {
        print(resp.body);
        return {'message': "true", 'data': decodeResp['data'], 'resp': resp};
      }
    } catch (e) {
      return {"error": "$e"};
    }
  }

  showMethod(
      {BuildContext context, String table, String id, String token}) async {
    Map<String, String> head;

    if (token != null) {
      head = {'Accept': 'application/json', 'Authorization': 'Bearer $token'};
    } else {
      head = {'Accept': 'application/json'};
    }

    try {
      dynamic resp = await http
          .get(
        Uri.parse(ip + '/$table/$id'),
        headers: head,
      )
          .timeout(Duration(seconds: 10), onTimeout: () {
        throw {
          Navigator.pop(context),
          alerta(
            context,
            contenido: Text(
              "No hay conexion con el servidor.",
            ),
          ),
        };
      });

      Map<dynamic, dynamic> decodeResp = json.decode(resp.body);

      if (resp.statusCode != 200) {
        print(resp.body);
        if (decodeResp['message'] == 'Unauthenticated.') {
          // Navigator.of(context).pushReplacementNamed('IniciarSesion');
          return {'message': "expiro", 'data': decodeResp, 'resp': resp};
        }
        return {'message': "false", 'data': decodeResp, 'resp': resp};
      } else {
        return {'message': "true", 'data': decodeResp['data'], 'resp': resp};
      }
    } catch (e) {
      return {"error": "$e"};
    }
  }

  deleteMethod(
      {BuildContext context, String table, int id, String token}) async {
    Map<String, String> head;

    if (token != null) {
      head = {'Accept': 'application/json', 'Authorization': 'Bearer $token'};
    } else {
      head = {'Accept': 'application/json'};
    }
    try {
      dynamic resp = await http
          .delete(Uri.parse(ip + '/$table' + '/$id'), headers: head)
          .timeout(Duration(seconds: 10), onTimeout: () {
        throw {
          Navigator.pop(context),
          alerta(
            context,
            contenido: Text(
              "No hay conexion con el servidor.",
            ),
          ),
        };
      });
      Map<dynamic, dynamic> decodeResp = json.decode(resp.body);

      if (resp.statusCode != 200) {
        print(resp.body);

        if (decodeResp['message'] == 'Unauthenticated.') {
          // Navigator.of(context).pushReplacementNamed('IniciarSesion');
          return {'message': "expiro", 'data': decodeResp, 'resp': resp};
        }
        return {'message': "false", 'data': decodeResp, 'resp': resp};
      } else {
        return {'message': "true", 'data': decodeResp['data'], 'resp': resp};
      }
      // return resp.body;

    } catch (e) {
      return {"error": "$e"};
    }
  }
}
