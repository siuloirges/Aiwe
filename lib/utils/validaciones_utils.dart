import 'package:flutter/material.dart';

class Validaciones {
  bool isNumeric(String s) {
    if (s.isEmpty) return false;

    final n = num.tryParse(s);

    return (n == null) ? false : true;
  }

  void mostrarCargando(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  void mostrarAlerta(BuildContext context, String mensaje) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text('Algo salio mal'),
            content: Text(mensaje),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              )
            ],
          );
        });
  }

  void mensajeValForm(BuildContext context, List<Widget> validacion) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text('Algo salio mal'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: validacion,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  void alertaInfo(BuildContext context, String mensaje, String estado) {
    // flutter defined function
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: new Text("Información"),
          content: new Text(mensaje.toString()),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Salir",
              ),
              onPressed: () {
                if (estado == 'false') {
                  Navigator.of(context).pop();
                } else {
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(context, estado);
                }
              },
            ),
          ],
        );
      },
    );
  }

  String validateEmail(String value) {
    if (value.isEmpty) {
      return 'El campo Email no puede estar vacío!';
    }
    // Regex para validación de email
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = new RegExp(p);
    if (regExp.hasMatch(value)) {
      return null;
    }

    return 'El Email suministrado no es válido. Intente otro correo electrónico';
  }

  String validatePassword(String value) {
    if (value.isEmpty) {
      return 'El campo Contraseña no puede estar vacío';
    }
    // Use cualquier tamaño de contraseña que usted quiera aquí
    if (value.length < 8) {
      return 'El tamaño de la contraseña debe ser más de 8 carácteres';
    }
    return null;
  }

  String validateRepetPassword(String value, String password) {
    //print("valorrr $value passsword ${passwordCtrl.text}");
    if (value != password) {
      return "Las contraseñas no coinciden";
    } else if (value.length < 8) {
      return 'El tamaño de la contraseña debe ser más de 8 carácteres';
    }
    return null;
  }

  String validateName(String value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "El campo es necesario";
    } else if (!regExp.hasMatch(value)) {
      return "El campo debe de ser a-z y A-Z";
    }
    return null;
  }

  String validateGenerico(String value) {
    if (value.length == 0) {
      return "El campo es necesario";
    }
    return null;
  }

  String validatePrecioSgerido(String value) {
    if (value.length == 0) {
      return "El campo es necesario";
    } else if (value.length <= 3) {
      return 'El tamaño del campo debe ser más de 3 carácteres';
    }
    return null;
  }

  String validateNumerico(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "El numero es necesario";
    } else if (!regExp.hasMatch(value)) {
      return "Debe de ser solo numeros";
    }
    return null;
  }

  String validateSmsCode(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length  !=6 ) {
      return "El codigo debe tener 6 digitos";
    } else if (!regExp.hasMatch(value)) {
      return "Debe de ser solo numeros";
    }
    return null;
  }

  String validateNumeroIdentidadYtelefono(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length !=10) {
      return "Debe tener 12 digitos";
    } else if (!regExp.hasMatch(value)) {
      return "La cedula debe de ser solo numeros";
    }
    return null;
  }

  String validarNit(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length < 9 || value.length > 11) {
      return "Debe tener entre 9 y 11 digitos";
    } else if (!regExp.hasMatch(value)) {
      return "La cedula debe de ser solo numeros";
    }
    return null;
  }
}
