import 'dart:convert';

import 'package:intl/intl.dart';

// import 'package:flutter/material.dart';
final formatter = new NumberFormat("###,###,###", "es-co");
String starageNotifiChanelCliente = "{\"lista\":[]}";
// bool activoConductor = true;

class ConfirmarClienteProvider {
  get notifiChanel {
    String lista = starageNotifiChanelCliente;

    var jsonData = json.decode(lista);
    // print(jsonData);
    return jsonData['lista'];
  }

  set notifiChanel(Map<String, dynamic> value) {
    String lista = starageNotifiChanelCliente;
    if (lista == null) {
      print(lista);
      String encodeData = json.encode({
        "lista": [value]
      });
      starageNotifiChanelCliente = encodeData;
    } else {
      print(lista);
      var jsonData = json.decode(lista);
      jsonData['lista'].add(value);
      var encodeData = json.encode(jsonData);
      starageNotifiChanelCliente = encodeData;
    }
    // notifyListeners();
  }

  deleteNotifiChanel({int unique}) {
    String lista = starageNotifiChanelCliente;
    dynamic jsonData = json.decode(lista);

    int index = 0;
    int indexdelete;
    jsonData['lista'].forEach(
      (element) {
        if (int.parse(element['unique'].toString()) == unique) {
          //
          indexdelete = index;
        }
        index++;
      },
    );

    if (indexdelete != null) {
      jsonData['lista'].removeAt(indexdelete);
      starageNotifiChanelCliente = json.encode(jsonData);
    }
  }

  deleteDelayNotifiChanel({int unique, int delay}) async {
    await Future.delayed(Duration(seconds: delay));
    String lista = starageNotifiChanelCliente;
    dynamic jsonData = json.decode(lista);

    int index = 0;
    jsonData['lista']?.forEach((element) {
      if (int.parse(element['unique'].toString()) == unique) {
        jsonData['lista'].removeAt(index);
        starageNotifiChanelCliente = json.encode(jsonData);
      }

      index++;
    });
  }

  deleteAllnotifiChanel() {
    starageNotifiChanelCliente = "{\"lista\":[]}";
    // notifyListeners();
  }
}
