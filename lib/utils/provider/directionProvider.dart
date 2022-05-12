import 'package:aiwe/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as map;

class DirectionProvider extends ChangeNotifier {
  GoogleMapsDirections directionsApi =
      GoogleMapsDirections(apiKey: "AIzaSyAdT07qTlGV8vdF7Lna33Xnmx7VnRimyY4");

  Set<map.Polyline> _route = Set();

  Set<map.Polyline> get currentRoute => _route;

  findDirectionr(map.LatLng from, map.LatLng to) async {
    // _route = null;
    // notifyListeners();
    // var origin = Location(lng: from.latitude, lat: from.longitude);
    // var destination = Location(lng: to.latitude, lat: to.longitude);
    // var result =
    //     await directionsApi.directionsWithLocation(origin, destination);
    // Set<map.Polyline> newRoute = Set();

    // // if (result.isOkay) {
    // print(
    //     "===================================================%%%%%%%%%%%%%%%%");
    // print(result.errorMessage);
    // var route = result.routes[0];
    // var leg = route.legs[0];
    // List<map.LatLng> puntos = [];

    // leg.steps.forEach((element) {
    //   puntos.add(
    //       map.LatLng(element.startLocation.lat, element.startLocation.lng));
    //   puntos.add(map.LatLng(element.endLocation.lat, element.endLocation.lng));
    // });

    // var linea = map.Polyline(
    //     points: puntos,
    //     polylineId: map.PolylineId("mejor ruta"),
    //     color: primaryColor,
    //     width: 4);

    // newRoute.add(linea);
    // _route = newRoute;
    // notifyListeners();
    // // } else {
    // //   print("error");
    // // }
  }
}
