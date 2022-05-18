// import 'package:animate_do/animate_do.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

//config
// String ip = "http://128.199.3.176:85/api";
// String storage = 'http://128.199.3.176:85/storage/';

//local
String ip = "https://192.168.1.71/aiwe_database/public/api";
String storage = 'https://192.168.1.71/aiwe_database/storage/';
String numberPhoneBot = "573043707188";
String nombreApp = "Travel";
String linkAndroid = "";
String linkIos = "";

// Colores
Color primaryColor = Color.fromRGBO(84, 83, 83, 1);
Color activeColor = Colors.amber.withOpacity(0.6);
Color themeColor = Colors.white;

//estilos textos
TextStyle tituloStyle1 = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w300,
);
TextStyle tituloStylePrimaryColor =
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor);
TextStyle tituloStyle1Positive = TextStyle(
  color: Colors.green,
  fontSize: 20,
  fontWeight: FontWeight.w300,
);
TextStyle tituloStyleTachado1 = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w300,
  decoration: TextDecoration.lineThrough,
);
TextStyle normalTextLiteNegative = TextStyle(
  color: Colors.red,
  fontSize: 15,
  fontWeight: FontWeight.w300,
  decoration: TextDecoration.lineThrough,
);
TextStyle normalTextLitePositive = TextStyle(
  color: Colors.green,
  fontSize: 15,
  fontWeight: FontWeight.w300,
  decoration: TextDecoration.lineThrough,
);
TextStyle normalTextLite = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w300,
);
TextStyle normalTextLiteWhite =
    TextStyle(fontSize: 15, fontWeight: FontWeight.w300, color: Colors.white);
TextStyle normalTextLiteTachado = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w300,
  decoration: TextDecoration.lineThrough,
);
TextStyle normalTextBold = TextStyle(
  fontSize: 17,
  color: Colors.white,
  fontWeight: FontWeight.bold,
);

Widget horizontalRoundButton(String text,
    {bool active = false, Function onTap}) {
  return Padding(
    padding: const EdgeInsets.only(left: 8.0),
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: ShapeDecoration(
            color: active ? activeColor : themeColor,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: primaryColor),
                borderRadius: BorderRadius.circular(100))),
        height: 40,
        // width: 60,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Center(
              child: Text("$text",
                  style:
                      TextStyle(color: active ? primaryColor : Colors.black))),
        ),
      ),
    ),
  );
}

Widget horizontalScrollBox(
  Size size, {
  List<Widget> list,
  Function onTap,
}) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 65,
            width: size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 40,
                  width: size.width,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: list,
                    ),
                  ),
                ),
                Divider(
                  color: primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

//widgets
primaryButton(BuildContext context, Size size,
    {Function onpress, String texto}) {
  return Container(
    height: 65,
    width: size.width * 0.8,
    padding: EdgeInsets.only(
      top: 5,
      left: 5,
      bottom: 5,
    ),
    margin: EdgeInsets.only(bottom: 20),
    child: RaisedButton(
      elevation: 2,
      color: primaryColor,
      shape: StadiumBorder(),
      onPressed: onpress,
      child: Center(
        child: Text('$texto', style: normalTextBold),
      ),
    ),
  );
}

load(BuildContext context, {bool colorSuave = false}) {
  return showDialog(
      // barrierColor:
      // useSafeArea: tue,
      barrierColor: colorSuave == false
          ? Color.fromRGBO(64, 62, 65, 0.9)
          : Colors.transparent,
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: Center(
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 50,
              child: (CircleAvatar(
                backgroundColor: Colors.white,
                child: Container(
                  // width: 190,
                  // height: 190,
                  child: Center(
                      child: Stack(children: [
                    Center(
                      child: Image(
                          width: 20,
                          height: 20,
                          image: AssetImage(
                            'assets/Loading.png',
                          )),
                    ),
                    Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        // valueColor: Color(Colors.white),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ])),
                ),
              )),
            ),
          ),
        );
      });
}

thereIsNot({String texto, String imagen, bool color}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Center(
          child: Image.asset(
        '$imagen',
        width: 150,
        height: 150,
        fit: BoxFit.cover,
        color: color == true ? Colors.grey : null,
      )),
      Text(
        '$texto',
        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
      ),
      Flexible(
        child: Container(
          height: 250,
        ),
      )
    ],
  );
}

loading({double width = 2}) {
  return CircularProgressIndicator(
    // valueColor: ,
    backgroundColor: themeColor,
    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
    strokeWidth: width,
  );
}

linearLoading({double height = 2}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(100),
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
      minHeight: height,
    ),
  );
}

alerta(BuildContext context,
    {bool code = true,
    String titulo,
    dynamic contenido,
    Widget acciones,
    bool dismissible,
    bool done,
    Widget onpress,
    Color colorTitulo,
    Color colorContenido,
    bool weight = false}) {
  return showDialog(
      barrierDismissible: dismissible ?? true,
      barrierColor: Colors.black54,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Color.fromRGBO(246, 245, 250, 1),
          title: Container(
              decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text(
                  '${titulo ?? 'Alerta'}',
                  style: tituloStyle1,
                )),
              )),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6))),
                    child: Container(
                      width: double.infinity,
                      // height: size.width>450?200: size.height * 0.22,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            code == true
                                ? contenido ?? Container()
                                : Text('$contenido', style: normalTextLite)
                          ],
                        ),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: done == true
                            ? Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          child: Icon(Icons.arrow_back,
                                              color: Colors.white),
                                          width: 50,
                                          height: 50,
                                          decoration: ShapeDecoration(
                                              color: Colors.grey,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10))),
                                        )),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: onpress),
                                ],
                              )
                            : done == false
                                ? Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              child: Icon(Icons.arrow_back,
                                                  color: Colors.white),
                                              width: 50,
                                              height: 50,
                                              decoration: ShapeDecoration(
                                                  color: Colors.grey,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10))),
                                            )),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [acciones ?? Container()],
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

accionButtom(context, {Widget widget, Function onTap, Color backColor}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: GestureDetector(
        onTap: onTap ?? () {},
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0 - 8.0),
            child: Center(
                child: widget ?? Icon(Icons.arrow_back, color: themeColor)),
          ),
          // width: 50,
          height: 50,
          decoration: ShapeDecoration(
              color: backColor ?? Colors.grey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
        )),
  );
}

floadMessage(
    {String titulo,
    String mensaje,
    Duration duration,
    ToastPosition toastPosition,
    double bigHeight,
    int maxLine,
    double borderRadius}) {
  showToastWidget(
    FadeInUp(
      child: GestureDetector(
        child: Container(
          height: bigHeight ?? 65,
          margin: EdgeInsets.only(left: 20.0, right: 20.0),
          decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(borderRadius ?? 5)),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Center(
                    child: Text(
                      "${titulo ?? ''}",
                      // maxLines: big==null?1:maxLine??1,
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Center(
                    child: Text(
                      "${mensaje ?? ''}",
                      maxLines: bigHeight == null ? 1 : maxLine ?? 1,

                      //  overflow: TextOverflow.clip,

                      style: TextStyle(color: Colors.yellow),

                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
    position: toastPosition ?? ToastPosition.bottom,
    duration: duration ?? Duration(seconds: 3),
  );
}
