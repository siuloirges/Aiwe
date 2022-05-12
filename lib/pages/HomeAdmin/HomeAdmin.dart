import 'package:aiwe/utils/global.dart';
import 'package:aiwe/utils/widget/drawer.dart';
import 'package:flutter/material.dart';

class HomeAdmin extends StatelessWidget {
  static String idRuta = "HomeAdmin";
  const HomeAdmin({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDesplegable(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: primaryColor),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.replay_outlined),
            onPressed: () {},
          )
        ],
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Administrador",
          style: TextStyle(color: primaryColor),
        ),
      ),
    );
  }
}
