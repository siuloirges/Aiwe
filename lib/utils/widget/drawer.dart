import 'package:aiwe/pages/HomeCliente/HomeCliente.dart';
import 'package:aiwe/pages/loginPage/login.dart';
import 'package:aiwe/utils/global.dart';
import 'package:flutter/material.dart';
import '../preferencias.dart';
import '../provider/PeticionesHttp.dart';

class MenuDesplegable extends StatelessWidget {
  PreferenciasUsuario pref = new PreferenciasUsuario();
  PeticionesHttpProvider http = PeticionesHttpProvider();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return Drawer(
      elevation: 20.0,
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: orientation == Orientation.portrait
                    ? size.height * 0.06
                    : size.height * 0.106,
              ),
              Image(
                image: AssetImage('assets/Loading.png'),
                // color: verde,
                width: 130,
              ),
              SizedBox(
                height: 15,
              ),
              Divider(),
              Container(
                child: pref.role == "client"
                    ? Column(
                        children: [
                          SizedBox(
                            height: orientation == Orientation.portrait
                                ? size.height * 0.1
                                : size.height * 0.176,
                          ),
                          ListTile(
                              onTap: () {
                                Scaffold.of(context).openEndDrawer();
                                Navigator.of(context).pushNamed('Perfil');
                              },
                              title: Text('Perfil Cliente'),
                              leading: Icon(Icons.person)),

                              
                        ],
                      )
                    : Container(),
              ),
              Container(
                child: pref.role == "client"
                    ? Column(
                        children: [
                          ListTile(
                              onTap: () {
                                Scaffold.of(context).openEndDrawer();
                                Navigator.of(context)
                                    .pushNamed(HomeCliente.idRuta);
                              },
                              title: Text('Home'),
                              leading: Icon(Icons.home)),
                        ],
                      )
                    : Container(),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Scaffold.of(context).openEndDrawer();
                  Navigator.of(context).pushReplacementNamed(LoginPage.idRuta);
                },
                title: Text('Cerrar Sesion Global'),
                leading: Image(
                  image: AssetImage(
                    'assets/logout.png',
                  ),
                  color: primaryColor,
                  width: orientation == Orientation.portrait
                      ? size.width * 0.1
                      : size.width * 0.056,
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
