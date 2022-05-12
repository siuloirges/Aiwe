import 'package:aiwe/pages/loginPage/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia =
      new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // GET y SET de la última página
  get ultima_pagina {
    return _prefs.getString('ultima_pagina') ?? LoginPage.idRuta;
  }

  set ultima_pagina(String value) {
    _prefs.setString('ultima_pagina', value);
  }

  get user_id {
    return _prefs.getString('user_id') ?? '';
  }

  set user_id(String value) {
    _prefs.setString('user_id', value);
  }

  get token {
    return _prefs.getString('token') ?? '';
  }

  set token(String value) {
    _prefs.setString('token', value);
  }

  get refresh_token {
    return _prefs.getString('refresh_token') ?? '';
  }

  set refresh_token(String value) {
    _prefs.setString('refresh_token', value);
  }

  get fcm_token {
    return _prefs.getString('fcm_token') ?? '';
  }

  set fcm_token(String value) {
    _prefs.setString('fcm_token', value);
  }

  get role {
    return _prefs.getString('role') ?? '';
  }

  set role(String value) {
    _prefs.setString('role', value);
  }

  get authorized {
    return _prefs.getString('authorized') ?? '';
  }

  set authorized(String value) {
    _prefs.setString('authorized', value);
  }

  get nombre {
    return _prefs.getString('nombre') ?? '';
  }

  set nombre(String value) {
    _prefs.setString('nombre', value);
  }

  get profile_picutre {
    return _prefs.getString('profile_picutre') ?? '';
  }

  set profile_picutre(String value) {
    _prefs.setString('profile_picutre', value);
  }
  get identification_document_picture_1 {
    return _prefs.getString('identification_document_picture_1') ?? '';
  }

  set identification_document_picture_1(String value) {
    _prefs.setString('identification_document_picture_1', value);
  }
  get identification_document_picture_2 {
    return _prefs.getString('identification_document_picture_2') ?? '';
  }

  set identification_document_picture_2(String value) {
    _prefs.setString('url_foto_documento2', value);
  }
  get property_card_picture_1 {
    return _prefs.getString('property_card_picture_1') ?? '';
  }

  set property_card_picture_1(String value) {
    _prefs.setString('property_card_picture_1', value);
  }
  get property_card_picture_2 {
    return _prefs.getString('property_card_picture_2') ?? '';
  }

  set property_card_picture_2(String value) {
    _prefs.setString('url_foto_tarjeta_propiedad2', value);
  }

  get license_plate_picture {
    return _prefs.getString('license_plate_picture') ?? '';
  }

  set license_plate_picture(String value) {
    _prefs.setString('license_plate_picture', value);
  }

  get vehicle_picture_1 {
    return _prefs.getString('vehicle_picture_1') ?? '';
  }

  set vehicle_picture_1(String value) {
    _prefs.setString('vehicle_picture_1', value);
  }
  get vehicle_picture_2 {
    return _prefs.getString('vehicle_picture_2') ?? '';
  }

  set vehicle_picture_2(String value) {
    _prefs.setString('vehicle_picture_2', value);
  }

  get soat_picture_1 {
    return _prefs.getString('soat_picture_1') ?? '';
  }

  set soat_picture_1(String value) {
    _prefs.setString('soat_picture_1', value);
  }
  get soat_picture_2 {
    return _prefs.getString('soat_picture_2') ?? '';
  }

  set soat_picture_2(String value) {
    _prefs.setString('soat_picture_2', value);
  }

   updateByKey(String value,String key ) {
    _prefs.setString(key, value);
  }

  borrarPreferecias() {
    _prefs.clear();
  }
}
