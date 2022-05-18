import 'dart:convert';
import 'dart:io';
import 'package:aiwe/utils/global.dart';
import 'package:aiwe/utils/preferencias.dart';
import 'package:aiwe/utils/provider/PeticionesHttp.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime_type/mime_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

enum TiposDocumentos {
  profile_picutre,
  license_plate_picture,
  identification_document_picture_1,
  identification_document_picture_2,
  property_card_picture_1,
  property_card_picture_2,
  soat_picture_1,
  soat_picture_2,
  vehicle_picture_1,
  vehicle_picture_2
}

class NoAutorizadoPage extends StatefulWidget {
  static String idRuta = "NoAutorizadoPage";
  @override
  _NoAutorizadoPageState createState() => _NoAutorizadoPageState();
}

class _NoAutorizadoPageState extends State<NoAutorizadoPage> {
  ImagePicker picker = ImagePicker();
  PeticionesHttpProvider _peticionesHttpProvider = new PeticionesHttpProvider();
  PreferenciasUsuario _pref = new PreferenciasUsuario();
  TextEditingController nombreController = new TextEditingController();
  TextEditingController documentoController = new TextEditingController();
  XFile profile_picutre = null;
  XFile identification_document_picture_1 = null;
  XFile identification_document_picture_2 = null;
  XFile license_plate_picture = null;
  XFile property_card_picture_1 = null;
  XFile property_card_picture_2 = null;
  XFile soat_picture_1 = null;
  XFile soat_picture_2 = null;
  XFile vehicle_picture_1 = null;
  XFile vehicle_picture_2 = null;
  Size size;
  SharedPreferences _prefs;
  Widget body = Container();
  Widget boton = Container();
  // Widget campos = Container();
  int idSelector = 0;
  Map<String, String> bodyPostDocuments = {};
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    if (validarRegistros()) {
      body = bodyRellenarDatos(context);
      setState(
        () {},
      );
      boton = Container();
    } else {
      boton = _botonGuardar(context);
      body = Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            inputNombre(),
            SizedBox(height: 10),
            inputDocumento(),
          ],
        ),
      );
      setState(() {});
      // body = bodyEsperarVerificacion();
      // setState(
      //   () {},
      // );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Rellenar datos',
          style: TextStyle(color: primaryColor),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 0.0,
          left: 8,
          right: 8,
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Conductor, su usuario no esta autorizado\nrellene todos los datos acontinuacion\npara enviar la solicitud de aprobacion",
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                    body //aqui
                  ],
                ),
              ),
            ),
            boton // _botonGuardar(context)
          ],
        ),
      ),
    );
  }

  Widget bodyRellenarDatos(BuildContext context) {
    return Column(
      children: [
        Container(
          height: size.height / 4 + 60,
          // color: Colors.grey[200],
          child: PageView(
            children: [
              addImage(
                context,
                nombreCampo: 'Foto de perfil',
                fotoCampo: File(profile_picutre?.path ?? ''),
                idTipoDocumento: TiposDocumentos.profile_picutre,
                urlFoto: _pref.profile_picutre,
              ),
              addImage(
                context,
                nombreCampo: 'Foto cedula parte delantera',
                fotoCampo: File(identification_document_picture_1?.path ?? ''),
                idTipoDocumento:
                    TiposDocumentos.identification_document_picture_1,
                urlFoto: _pref.identification_document_picture_1,
              ),
              addImage(
                context,
                nombreCampo: 'Foto cedula parte trasera',
                fotoCampo: File(identification_document_picture_2?.path ?? ''),
                idTipoDocumento:
                    TiposDocumentos.identification_document_picture_2,
                urlFoto: _pref.identification_document_picture_2,
              ),
              addImage(
                context,
                nombreCampo: 'Foto vehiculo parte lateral',
                fotoCampo: File(vehicle_picture_1?.path ?? ''),
                idTipoDocumento: TiposDocumentos.vehicle_picture_1,
                urlFoto: _pref.vehicle_picture_1,
              ),
              addImage(
                context,
                nombreCampo: 'Foto vehiculo parte frontal',
                fotoCampo: File(vehicle_picture_2?.path ?? ''),
                idTipoDocumento: TiposDocumentos.vehicle_picture_2,
                urlFoto: _pref.vehicle_picture_2,
              ),
              addImage(
                context,
                nombreCampo: 'Foto placa del vehiculo',
                fotoCampo: File(license_plate_picture?.path ?? ''),
                idTipoDocumento: TiposDocumentos.license_plate_picture,
                urlFoto: _pref.license_plate_picture,
              ),
              addImage(
                context,
                nombreCampo: 'Foto tarjeta de propiedad parte frontal',
                fotoCampo: File(property_card_picture_1?.path ?? ''),
                idTipoDocumento: TiposDocumentos.property_card_picture_1,
                urlFoto: _pref.property_card_picture_1,
              ),
              addImage(
                context,
                nombreCampo: 'Foto tarjeta de propiedad parte trasera',
                fotoCampo: File(property_card_picture_2?.path ?? ''),
                idTipoDocumento: TiposDocumentos.property_card_picture_2,
                urlFoto: _pref.property_card_picture_2,
              ),
              addImage(
                context,
                nombreCampo: 'Soat parte frontal',
                fotoCampo: File(soat_picture_1?.path ?? ''),
                idTipoDocumento: TiposDocumentos.soat_picture_1,
                urlFoto: _pref.soat_picture_1,
              ),
              addImage(
                context,
                nombreCampo: 'Soat parte trasera',
                fotoCampo: File(soat_picture_2?.path ?? ''),
                idTipoDocumento: TiposDocumentos.soat_picture_2,
                urlFoto: _pref.soat_picture_2,
              ),
            ],
            onPageChanged: (id) {
              idSelector = id;
              setState(() {});
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50.0, right: 50.0),
          child: Container(
            height: 19,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                selector(0),
                selector(1),
                selector(2),
                selector(3),
                selector(4),
                selector(5),
                selector(6),
                selector(7),
                selector(8),
                selector(9),
              ],
            ),
          ),
        ),
        // SizedBox(height: 15),
        // Padding(
        //   padding: const EdgeInsets.all(20.0),
        //   child: Column(
        //     children: [inputNombre(), SizedBox(height: 10), inputDocumento()],
        //   ),
        // ),
      ],
    );
  }

  Widget bodyEsperarVerificacion() {
    return Center(
      child: Text("data"),
    );
  }

  bool validarRegistros() {
    if (_pref.profile_picutre == "" ||
        _pref.identification_document_picture_1 == "" ||
        _pref.identification_document_picture_2 == "" ||
        _pref.vehicle_picture_1 == "" ||
        _pref.vehicle_picture_2 == "" ||
        _pref.license_plate_picture == "" ||
        _pref.property_card_picture_1 == "" ||
        _pref.property_card_picture_2 == "" ||
        _pref.soat_picture_1 == "" ||
        _pref.soat_picture_2 == "" ||
        _pref.nombre == "") {
      return true;
    } else {
      return false;
    }
  }

  Widget inputNombre() {
    return TextFormField(
      controller: nombreController,
      keyboardType: TextInputType.number,
      // validator: (value) => validar.validateGenerico(value),
      decoration: InputDecoration(
        // icon: Icon(Icons.phone , color:primaryColor),
        prefixIcon: Icon(Icons.person, color: primaryColor),
        hintText: 'juan perez perez',
        labelText: 'Nombre completo',
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onChanged: (value) {
        // altura = double.parse(value.toString());
      },
    );
  }

  Widget inputDocumento() {
    return TextFormField(
      controller: documentoController,
      keyboardType: TextInputType.number,
      // validator: (value) => validar.validateGenerico(value),
      decoration: InputDecoration(
        // icon: Icon(Icons.phone , color:primaryColor),
        prefixIcon: Icon(Icons.credit_card, color: primaryColor),
        hintText: '1002525236',
        labelText: 'Numero de cedula',
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onChanged: (value) {
        // altura = double.parse(value.toString());
      },
    );
  }

  Widget selector(int id) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      height: id == idSelector ? 14 : 5,
      width: id == idSelector ? 14 : 5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: id == idSelector ? primaryColor : Colors.red[400],
      ),
    );
  }

  Widget addImage(BuildContext context,
      {String urlFoto,
      String nombreCampo,
      File fotoCampo,
      TiposDocumentos idTipoDocumento}) {
    Orientation orientation = MediaQuery.of(context).orientation;

    final tamano = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        return cargarAndUbicarImagen(
          context,
          idTipoDocumento: idTipoDocumento,
          camara: true,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(232, 232, 232, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              height: size.height / 4,
              width: double.infinity,
              child: urlFoto == ''
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo,
                          size: orientation == Orientation.portrait
                              ? size.width * 0.07
                              : size.width * 0.03,
                          color: primaryColor,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Tap para tomar foto',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        )
                      ],
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      child: Image.network(
                        storage + urlFoto,
                        fit: BoxFit.cover,
                        height: tamano.height / 4,
                      ),
                    ),
            ),
            // : ClipRRect(
            //     //  decoration:BoxDecoration(color: gris, borderRadius: BorderRadius.only(topLeft:Radius.circular(20),topRight: Radius.circular(20) ),),
            //     borderRadius: BorderRadius.only(
            //         topLeft: Radius.circular(20),
            //         topRight: Radius.circular(20)),
            //     child: Image.file(
            //       fotoCampo,
            //       width: size.width,
            //       fit: BoxFit.cover,
            //       height: tamano.height / 4,
            //     ),
            //   ),
            Container(
              child: Center(
                  child: Text('$nombreCampo',
                      style: TextStyle(color: Colors.white))),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              height: 20,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  cargarAndUbicarImagen(BuildContext context,
      {TiposDocumentos idTipoDocumento, bool camara = false}) async {
    // var imagen = await ImagePicker.pickImage(
    //   maxHeight: 720,
    //   maxWidth: 1280,
    //   source: camara == true ? ImageSource.camera : ImageSource.gallery,
    // );

    var imagen = await picker.pickImage(source: ImageSource.camera);

    switch (idTipoDocumento) {
      case TiposDocumentos.profile_picutre:
        setState(() {});
        profile_picutre = imagen;
        subirImagen(File(imagen?.path ?? ''), "profile_picutre");
        break;
      case TiposDocumentos.identification_document_picture_1:
        setState(() {});
        identification_document_picture_1 = imagen;
        subirImagen(
            File(imagen?.path ?? ''), "identification_document_picture_1");
        break;
      case TiposDocumentos.identification_document_picture_2:
        setState(() {});
        identification_document_picture_1 = imagen;
        break;
      case TiposDocumentos.vehicle_picture_1:
        setState(() {});
        vehicle_picture_1 = imagen;
        break;
      case TiposDocumentos.vehicle_picture_2:
        setState(() {});
        vehicle_picture_2 = imagen;
        break;
      case TiposDocumentos.license_plate_picture:
        setState(() {});
        license_plate_picture = imagen;
        break;
      case TiposDocumentos.property_card_picture_1:
        setState(() {});
        property_card_picture_1 = imagen;
        break;
      case TiposDocumentos.property_card_picture_2:
        setState(() {});
        property_card_picture_2 = imagen;
        break;
      case TiposDocumentos.soat_picture_1:
        setState(() {});
        soat_picture_1 = imagen;
        subirImagen(File(imagen?.path ?? ''), "soat_picture_1");
        break;
      case TiposDocumentos.soat_picture_2:
        setState(() {});
        soat_picture_2 = imagen;
        subirImagen(File(imagen?.path ?? ''), "soat_picture_2");
        break;
    }
  }

  // void selectModoCargarImagen(BuildContext context,
  //     {File foto, String texto, TiposDocumentos idTipoDocumento}) {
  //   final tamano = MediaQuery.of(context).size;
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             Text(
  //               'Seleccione',
  //               style: TextStyle(
  //                   fontSize: tamano.width * 0.038, color: primaryColor),
  //             ),
  //           ],
  //         ),
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //         content: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             Container(
  //               child: RaisedButton(
  //                 color: Colors.white,
  //                 shape: RoundedRectangleBorder(
  //                     side: BorderSide(color: primaryColor, width: 1),
  //                     borderRadius: BorderRadius.circular(20)),
  //                 child: Row(
  //                   children: <Widget>[
  //                     Icon(
  //                       Icons.center_focus_strong,
  //                       color: primaryColor,
  //                       size: tamano.width * 0.05,
  //                     ),
  //                     Text(
  //                       'tomar',
  //                       style: TextStyle(
  //                           fontSize: tamano.width * 0.038,
  //                           color: primaryColor),
  //                     ),
  //                   ],
  //                 ),
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                   cargarAndUbicarImagen(
  //                       idTipoDocumento: idTipoDocumento, camara: true);
  //                 },
  //               ),
  //             ),
  //             SizedBox(
  //               width: tamano.height * 0.025,
  //             ),
  //             Container(
  //               child: RaisedButton(
  //                 color: Colors.white,
  //                 shape: RoundedRectangleBorder(
  //                     side: BorderSide(color: primaryColor, width: 1),
  //                     borderRadius: BorderRadius.circular(50)),
  //                 child: Row(
  //                   children: <Widget>[
  //                     Icon(
  //                       Icons.add_a_photo,
  //                       color: primaryColor,
  //                       size: tamano.width * 0.040,
  //                     ),
  //                     Text(
  //                       'galería',
  //                       style: TextStyle(color: primaryColor),
  //                     ),
  //                   ],
  //                 ),
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                   cargarAndUbicarImagen(
  //                     idTipoDocumento: idTipoDocumento,
  //                   );
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  _botonGuardar(context) {
    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      height: 75,
      child: RaisedButton(
        elevation: 0,
        highlightElevation: 0,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        // onPressed: () {
        //   subirImagen(profile_picutre);
        // },
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Guardar',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.cloud_upload_sharp,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }

  // put(BuildContext context) async {
  //   try {
  //     // rellenarBodyMethod();
  //     load(context);
  //     Map _resp = await _peticionesHttpProvider.postMethod(
  //       table: 'users',
  //       token: _pref.token,
  //       body: {
  //         "profile_picture": "${Image.file(profile_picutre)}",
  //       },
  //     );

  //     Navigator.pop(context);
  //     if (_resp['message'] == 'expiro') {}

  //     if (_resp['message'] == 'true') {
  //       profile_picutre = null;
  //       identification_document_picture_1 = null;
  //       identification_document_picture_2 = null;
  //       vehicle_picture_1 = null;
  //       vehicle_picture_2 = null;
  //       license_plate_picture = null;
  //       property_card_picture_1 = null;
  //       property_card_picture_2 = null;
  //       soat_picture_1 = null;
  //       soat_picture_2 = null;
  //       Navigator.pop(context);
  //       Navigator.pop(context);

  //       return alerta(context,
  //           titulo: 'Exito',
  //           code: false,
  //           contenido: 'sus datos fueron guardados exitosamente');
  //     }

  //     if (_resp['message'] == 'false') {
  //       Navigator.pop(context);
  //       return alerta(context,
  //           titulo: 'Error',
  //           code: false,
  //           contenido: 'Fallo al Actualizar usuario');
  //     } else {
  //       Navigator.pop(context);
  //       return alerta(
  //         context,
  //         titulo: 'Error',
  //       );
  //     }
  //   } catch (e) {}
  // }

  // rellenarBodyMethod() {
  //   try {
  //     validarRellenado(
  //       profile_picutre != null,
  //       "profile_picture",
  //       "${base64Encode(profile_picutre.readAsBytesSync()) ?? ""}",
  //     );
  //     validarRellenado(
  //       identification_document_picture_1 != null,
  //       "identification_document_picture_1",
  //       "${base64Encode(identification_document_picture_1.readAsBytesSync()) ?? ""}",
  //     );
  //     validarRellenado(
  //       identification_document_picture_2 != null,
  //       "identification_document_picture_2",
  //       "${base64Encode(identification_document_picture_2.readAsBytesSync()) ?? ""}",
  //     );
  //     validarRellenado(
  //       vehicle_picture_1 != null,
  //       "vehicle_picture_1",
  //       "${base64Encode(vehicle_picture_1.readAsBytesSync()) ?? ""}",
  //     );
  //     validarRellenado(
  //       vehicle_picture_2 != null,
  //       "vehicle_picture_2",
  //       "${base64Encode(vehicle_picture_2.readAsBytesSync()) ?? ""}",
  //     );
  //     validarRellenado(
  //       license_plate_picture != null,
  //       "license_plate_picture",
  //       "${base64Encode(license_plate_picture.readAsBytesSync()) ?? ""}",
  //     );
  //     validarRellenado(
  //       property_card_picture_1 != null,
  //       "property_card_picture_1",
  //       "${base64Encode(property_card_picture_1.readAsBytesSync()) ?? ""}",
  //     );
  //     validarRellenado(
  //       property_card_picture_2 != null,
  //       "property_card_picture_2",
  //       "${base64Encode(property_card_picture_2.readAsBytesSync()) ?? ""}",
  //     );
  //     validarRellenado(
  //       soat_picture_1 != null,
  //       "soat_picture_1",
  //       "${base64Encode(soat_picture_1.readAsBytesSync()) ?? ""}",
  //     );
  //     validarRellenado(
  //       soat_picture_2 != null,
  //       "soat_picture_2",
  //       "${base64Encode(soat_picture_2.readAsBytesSync()) ?? ""}",
  //     );

  //     print(bodyPostDocuments["profile_picture"]);
  //     print(bodyPostDocuments["identification_document_picture_1"]);
  //   } catch (e) {}
  // }

  // validarRellenado(bool validacion, String clave, String valor) {
  //   if (validacion) {
  //     bodyPostDocuments[clave] = valor;
  //   }
  // }

  Future<Map<String, dynamic>> subirImagen(File imagen, String key) async {
    final url = Uri.parse('$ip/users');
    print(mime(imagen?.path ?? ''));
    final mimeType = mime(imagen?.path ?? '').split('/');
    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url,
    );
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_pref.token}'
    };

    final file = await http.MultipartFile.fromPath(
      '$key',
      imagen?.path ?? '',
      contentType: MediaType(
        mimeType[0],
        mimeType[1],
      ),
    );

    imageUploadRequest.files.add(file);
    imageUploadRequest.fields["role"] = _pref.role;
    imageUploadRequest.headers.addAll(headers);
    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);
    if (resp.statusCode == 200) {
      final respData = json.decode(resp.body);
      // _prefs.setString(key, respData["$key"]);
      _pref.updateByKey(respData["$key"], key);
      print(_pref.soat_picture_1);
      setState(() {});
      // return respData['key'];
    } else {
      return {"success": false, "message": 'Algo Salio mal'};
    }
  }
}
