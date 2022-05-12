import 'dart:convert';

import 'package:intl/intl.dart';

// import 'package:flutter/material.dart';
final formatter = new NumberFormat("###,###,###", "es-co");
String starageNotifiChanelConductor = "{\"lista\":[]}";
bool activoConductor = true;

class IncioConductorProvider {
  get notifiChanel {
    String lista = starageNotifiChanelConductor;

    var jsonData = json.decode(lista);
    // print(jsonData);
    return jsonData['lista'];
  }

  set notifiChanel(Map<String, dynamic> value) {
    String lista = starageNotifiChanelConductor;
    if (lista == null) {
      print(lista);
      String encodeData = json.encode({
        "lista": [value]
      });
      starageNotifiChanelConductor = encodeData;
    } else {
      print(lista);
      var jsonData = json.decode(lista);
      jsonData['lista'].add(value);
      var encodeData = json.encode(jsonData);
      starageNotifiChanelConductor = encodeData;
    }
    // notifyListeners();
  }

  // set deletenotifiChanel(int index) {
  //   String lista = starageNotifiChanelConductor;
  //   print(lista);
  //   var jsonData = json.decode(lista);
  //   var deleteJsonData = jsonData['lista'].removeAt(index);
  //   print(deleteJsonData);
  //   var encodeData = json.encode(jsonData);
  //   print(jsonData);
  //   starageNotifiChanelConductor = encodeData;
  //   // notifyListeners();
  // }

  deleteNotifiChanel({int unique}) {
    // await Future.delayed(Duration(seconds: delay));
    String lista = starageNotifiChanelConductor;
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
      starageNotifiChanelConductor = json.encode(jsonData);
    }
  }

  deleteDelayNotifiChanel({int unique, int delay}) async {
    await Future.delayed(Duration(seconds: delay));
    String lista = starageNotifiChanelConductor;
    dynamic jsonData = json.decode(lista);

    int index = 0;
    jsonData['lista']?.forEach((element) {
      if (int.parse(element['unique'].toString()) == unique) {
        jsonData['lista'].removeAt(index);
        starageNotifiChanelConductor = json.encode(jsonData);
      }

      index++;
    });
  }

  // searchItemNotifiChanel({int unique}) {
  //   String lista = starageNotifiChanelConductor;
  //   Map<String, dynamic> jsonData = json.decode(lista);
  //   int unique;
  //   int index = 0;

  //   var var1 = jsonData['lista'].containsValue("unique");
  //   print(var1);

  //   // jsonData['lista']?.forEach((element) {
  //   //   if (int.parse(element['unique'].toString()) == unique) {
  //   //     unique = element['unique'];

  //   //   }

  //   //   index++;
  //   // });
  //   return unique;
  // }

  deleteAllnotifiChanel() {
    starageNotifiChanelConductor = "{\"lista\":[]}";
    // notifyListeners();
  }
}
