/*
 *  Aqui solo poner logica de widgets 
*/

import 'dart:io';
import 'package:easy_alert/easy_alert.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:pagosapp/src/plugins/image_net.dart';
import 'package:pagosapp/src/plugins/messages.dart';
import 'package:pagosapp/src/plugins/style.dart';
import 'package:pagosapp/src/utils/validators.dart';

// confirm
Future<bool> confirm(context,
    {String title: "Confirmar",
    String content: "¿Está seguro de realizar esta acción?"}) async {
  int isOk = await Alert.confirm(context, title: "$title", content: "$content");
  if (isOk == 1) {
    return false;
  }
  return true;
}

// input dialog
Future inputDialog(BuildContext context,
    {String title: "Ingresar el texto", String decoration: "Ingrese", bool onlyDecimal}) async {
  String reason = "";
  return showDialog(
    barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('$title'),
          content: TextField(
            keyboardType: onlyDecimal ? TextInputType.numberWithOptions(
              decimal: true,
              signed: false) : TextInputType.text,
            decoration: InputDecoration(hintText: "$decoration"),
            onChanged: (text) {
              reason = text;
            },
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
            FlatButton(
              child: Text('Confirmar'),
              onPressed: () {
                if(reason.length == 0){
                  toast("Ingrese un valor", type: 'default');
                }else{
                  if(onlyDecimal){
                    if(parseDouble(reason) > 0.0){
                      Navigator.of(context).pop(reason);
                    }else{
                      toast("Ingrese un valor mayor que 0", type: 'default');
                    }
                  }else{
                    Navigator.of(context).pop(reason);
                  }
                }
              },
            )
          ],
        );
      });
}

// Render Lists
List<DropdownMenuItem<dynamic>> listItems(Map<dynamic, String> map) {
  List<DropdownMenuItem<dynamic>> lista = new List();
  map.forEach((k, v) {
    lista
      ..add(DropdownMenuItem(
        child: Text('$v'),
        value: k,
      ));
  });
  return lista;
}

List<DropdownMenuItem<dynamic>> listItemsNormal(
    List<dynamic> map, String concat) {
  List<DropdownMenuItem<dynamic>> lista = new List();
  map.forEach((v) {
    lista
      ..add(DropdownMenuItem(
        child: Text('$v $concat'),
        value: v,
      ));
  });
  return lista;
}

//* Loader Component
Widget loader({String text = 'Cargando...'}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        CircularProgressIndicator(),
        SizedBox(height: 10),
        Text(text)
      ],
    ),
  );
}

//* custom snackbar
Widget customSnack(String message,
    {String type: 'ok', SnackBarAction action, int seconds = 4}) {
  SnackBar snack;
  switch (type.toLowerCase()) {
    case 'ok':
      snack = SnackBar(
          content: Text(message),
          action: action,
          backgroundColor: Colors.green,
          elevation: 12,
          duration: Duration(seconds: 3));
      break;
    case 'err':
      snack = SnackBar(
          content: Text(message),
          action: action,
          backgroundColor: Colors.red,
          elevation: 12,
          duration: Duration(seconds: seconds));
      break;
    default:
      snack = SnackBar(content: Text(message), action: action);
      break;
  }
  return snack;
}

//* miniloader
Widget miniLoader() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
            child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.black12)),
            height: 25,
            width: 25)
      ],
    ),
  );
}

//* Botones para cargar Imagenes
Widget buttonImage({Function onCamera, Function onGallery}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      FlatButton.icon(
        onPressed: onCamera,
        label: Text("Cámara", style: TextStyle(color: Style.primary[200])),
        icon: Icon(Icons.add_a_photo, color: Style.primary[200]),
      ),
      FlatButton.icon(
        onPressed: onGallery,
        label: Text("Galeria", style: TextStyle(color: Style.primary[200])),
        icon: Icon(Icons.add_photo_alternate, color: Style.primary[200]),
      ),
    ],
  );
}

Widget previewImageLoad({tag: '', Function onRemove, @required File img}) {
  return ListTile(
    contentPadding: EdgeInsets.all(0),
    trailing: IconButton(onPressed: onRemove, icon: Icon(Icons.delete)),
    leading: Image.file(img),
    title: Text("$tag cargada"),
    subtitle: Text("${(img.lengthSync() / 1024).roundToDouble()} kb"),
  );
}

Widget previewImageNet({tag: '', Function onRemove, String url}) {
  if(url == null) return Center();
  return ListTile(
    contentPadding: EdgeInsets.all(0),
    trailing: IconButton(onPressed: onRemove, icon: Icon(Icons.delete)),
    leading: imageNet(url),
    title: Text("$tag"),    
  );
}

//* Panel de expansión
Widget expandPanel(
    {Widget child,
    Widget collapChild,
    header: "",
    IconData iconHeader: Icons.place,
    double padding: 5.0}) {
  return ExpandableNotifier(
    child: ScrollOnExpand(
      child: ExpandablePanel(
        theme: ExpandableThemeData(
          alignment: Alignment.center,
          iconColor: Colors.grey,
          expandIcon: Icons.arrow_drop_up,
          collapseIcon: Icons.arrow_drop_down,
          iconSize: 25,
          bodyAlignment: ExpandablePanelBodyAlignment.center,
          headerAlignment: ExpandablePanelHeaderAlignment.center,
          iconPadding: EdgeInsets.symmetric(vertical: 15),
          animationDuration: const Duration(milliseconds: 600),
        ),
        header: swicthTitle(title: '$header', icon: iconHeader, swicthed: true),
        expanded: child == null
            ? SizedBox.shrink()
            : Padding(
                child: child,
                padding: EdgeInsets.symmetric(horizontal: padding)),
        collapsed: collapChild == null
            ? SizedBox.shrink()
            : Padding(
                child: collapChild,
                padding: EdgeInsets.symmetric(horizontal: padding)),
      ),
    ),
  );
}

//* Para los swicth
Widget swicthTitle({title: '', IconData icon, bool swicthed: false}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.max,
    children: <Widget>[
      Icon(icon, color: (swicthed ? Colors.orange : Colors.grey), size: 20),
      SizedBox(width: 15),
      Text("$title", style: TextStyle(color: Colors.grey[700], fontSize: 16))
    ],
  );
}

Widget swicthSubtitle({text: ''}) {
  return Row(
    children: <Widget>[Text("$text", style: TextStyle(fontSize: 12))],
  );
}
