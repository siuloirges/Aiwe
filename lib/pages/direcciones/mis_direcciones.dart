import 'package:aiwe/pages/direcciones/models/GetDireccionModel.dart';
import 'package:aiwe/utils/global.dart';
import 'package:aiwe/utils/preferencias.dart';
import 'package:aiwe/utils/provider/PeticionesHttp.dart';
import 'package:aiwe/utils/provider/funciones.dart';
import 'package:flutter/material.dart';

class MisDirecciones extends StatelessWidget {
  // DireccionesProvider direccionesProvider;
  static String idRuta= "MisDirecciones";
  PeticionesHttpProvider http = new PeticionesHttpProvider();
  PreferenciasUsuario pref = new PreferenciasUsuario();
  Funciones funciones = new Funciones();
  Size size;
  dynamic element;
  @override
  Widget build(BuildContext context) {
    element = ModalRoute.of(context).settings.arguments;
    size = MediaQuery.of(context).size;
    
    int variable = 0;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Color.fromRGBO(19, 166, 7, 1)),
        backgroundColor: Color.fromRGBO(255, 241, 1, 1),
        title: Text(
          "Mis Direcciones",
          style: TextStyle(
            color: Color.fromRGBO(19, 166, 7, 1),
            fontSize: 15.0,
          ),
        ),
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          Container(
            child: Padding(
                padding: const EdgeInsets.only(top: 90.0),
                child: element['data'] == 'vacio'
                    ? thereIsNot(
                        imagen: 'assets/no_hay.png',
                        texto: 'No hay Direcciones')
                    : element['data'].length != 0
                        ? ListView.builder(
                            itemCount: element['data'].length,
                            itemBuilder: (c, i) {
                              return GestureDetector(
                                onTap: () {
                                  mostrar(
                                      context: context,
                                      i: i,
                                      direccion: element['data'][i].direccion,
                                      titulo: element['data'][i].nombre,
                                      id: element['data'][i].id,
                                      obgeto: element['data'][i]);
                                },
                                child: direcciones(
                                    context: context,
                                    icono: Icon(
                                      Icons.location_on,
                                      color: Colors.green,
                                    ),
                                    titulo: '${element['data'][i].nombre}',
                                    subtitulo:
                                        '${element['data'][i].direccion}'),
                              );
                            },
                          )
                        : thereIsNot(
                            imagen: 'assets/no_hay.png',
                            texto: 'No hay Direcciones')),
          ),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                botonDireccion(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget botonDireccion(
    BuildContext context,
  ) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              height: 50,
              width: size.width > 450 ? 300 : size.width * 0.60,
              child: RaisedButton(
                  elevation: 0.0,
                  color: Color.fromRGBO(19, 166, 7, 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            size.width > 350
                                ? 'Añadir una Dirección'
                                : size.width > 250
                                    ? 'Añadir Direccion'
                                    : 'Añadir',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: size.width > 450 ? 12 : 12,
                                color: Colors.white)),
                      ),
                      Icon(
                        Icons.add_location_alt,
                        color: Color.fromRGBO(255, 241, 1, 1),
                      )
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('NuevaDireccionPage',
                        arguments: {'data': null});
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget direcciones(
      {BuildContext context,
      Widget icono,
      String titulo,
      String subtitulo,
      int id}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0, top: 6.0),
      child: Container(
        height: 90,
        child: Card(
          elevation: 3,
          shadowColor: Color.fromRGBO(39, 40, 34, 0.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          child: ListTile(
            leading: icono,
            title: Text(titulo),
            subtitle: Text(
              subtitulo,
              style: TextStyle(
                  fontSize: subtitulo.length > 140
                      ? size.width * 0.023
                      : size.width * 0.03),
            ),
          ),
        ),
      ),
    );
  }

  mostrar(
      {BuildContext context,
      int i,
      String titulo,
      String direccion,
      int id,
      dynamic obgeto}) {
    print(obgeto.nombre);
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Color.fromRGBO(246, 245, 250, 1),
            title: Container(
                decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.transparent,
                          ),
                          onPressed: () {},
                        ),
                      ),
                      Center(
                          child: Text(
                        '${titulo ?? "???"}',
                        style: TextStyle(color: Colors.grey),
                      )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.black26,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.of(context).pushNamed(
                                'NuevaDireccionPage',
                                arguments: {"data": obgeto});
                          },
                        ),
                      )
                    ],
                  ),
                )),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: Container(
                        // height: size.width>450?200: size.height * 0.3,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Center(
                                    child: Text(
                                  '${direccion ?? "???"}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black38,
                                      fontWeight: FontWeight.w500),
                                )),
                              ),
                            ],
                          ),
                        ),
                      )),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0, right: 5),
                          child: Container(
                            width: 57,
                            height: 57,
                            child: RaisedButton(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: Colors.black26,
                              child: Center(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.arrow_back_rounded,
                                    color: Colors.white,
                                  ),
                                ],
                              )),
                              onPressed: () {
                                Navigator.pop(context);
                                //  direccionesProvider.deleteDireccion(direccionesProvider.getDirecciones[i].id);
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0, left: 5),
                          child: Container(
                            width: 57,
                            height: 57,
                            child: RaisedButton(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: Colors.redAccent,
                              child: Center(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.restore_from_trash_rounded,
                                    color: Colors.white,
                                  ),
                                ],
                              )),
                              onPressed: () async {
                                dynamic resp = await http.deleteMethod(
                                  context: context,
                                  id: id,
                                  table: 'direcciones',
                                  token: pref.token,
                                );
                                if (resp['message'] == "expiro") {
                                  // Navigator.of(context).pop();
                                  // Navigator.of(context).pop();
                                  // Navigator.of(context)
                                  //     .pushReplacementNamed('IniciarSesion');
                                  alerta(context,
                                      titulo: 'alerta',
                                      code: false,
                                      contenido:
                                          'Tiempo de conexion agotado, inicie sesion nuevamente.');
                                  await funciones.closeSection(context);
                                }
                                if (resp['message'] == 'true') {
                                  load(context);
                                  try {
                                    Map _respuesta = await http.getMethod(
                                        context: context,
                                        table: 'direcciones',
                                        token: pref.token);
                                    if (_respuesta['message'] == "expiro") {
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              'IniciarSesion');
                                      alerta(context,
                                          titulo: 'alerta',
                                          code: false,
                                          contenido:
                                              'Tiempo de conexion agotado, inicie sesion nuevamente.');
                                      await funciones.closeSection(context);
                                    }

                                    if (_respuesta['message'] == 'true') {
                                      // print(_respuesta);
                                      final respModel =
                                          getDireccionesModelFromJson(
                                              _respuesta['resp']);
                                      print(respModel.data.data);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      // Scaffold.of(context).openEndDrawer();
                                      Navigator.of(context).pushNamed(
                                          'MisDirecciones',
                                          arguments: {
                                            "data": respModel.data.data
                                          });
                                    }
                                  } catch (e) {
                                    Navigator.pop(context);
                                    Scaffold.of(context).openEndDrawer();
                                    return alerta(context,
                                        contenido: Text(e),
                                        acciones: Container());
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
