import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pagosapp/src/models/client/client_history.dart';
import 'package:pagosapp/src/pages/client/edit_client_page.dart';
import 'package:pagosapp/src/pages/payments/lists_payments.dart';

class ActionsClient extends StatefulWidget {
  final ClientHistory clientData;
  ActionsClient({Key key, @required this.clientData}) : super(key: key);
  @override
  _ActionsClientState createState() => _ActionsClientState();
}

class _ActionsClientState extends State<ActionsClient> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${widget.clientData.name}"),
        ),
        body: Center(
          child: GridView.count(
            primary: true,
            crossAxisCount: 1,
            physics: ScrollPhysics(),
            padding: EdgeInsets.only(left: 60, right: 60, top: 10, bottom: 10),
            childAspectRatio: 1.9,
            mainAxisSpacing: 15.0,
            crossAxisSpacing: 10.0,
            shrinkWrap: true,
            children: <Widget>[
              _btn(context,
                  icon: FontAwesomeIcons.pencilAlt,
                  color: Colors.blue,
                  text: 'Editar', click: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditClientPage(
                              clientId: widget.clientData.id,
                              status: 1,
                            )));
              }),
              _btn(context,
                  icon: FontAwesomeIcons.dollarSign,
                  subtitle: widget.clientData.credit == null ? "Aún no tiene créditos" : "",
                  color: widget.clientData.credit == null ? Colors.grey[500] : Colors.green,                  
                  text: 'Recaudación', click: widget.clientData.credit == null ? null : () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ListsPaymentsPage(
                              client: widget.clientData,
                            )));
              }),
              _btn(context,
                  icon: FontAwesomeIcons.history,
                  color: Colors.indigo,
                  text: 'Historial de Crédito', click: () {
                Navigator.pushNamed(context, 'client_list');
              }),
            ],
          ),
        ));
  }

  RaisedButton _btn(BuildContext context,
      {String text: '', String subtitle,
      IconData icon: FontAwesomeIcons.icons,
      Color color: Colors.orange,
      @required void Function() click}) {
    return RaisedButton(
      elevation: 1,
      color: Colors.white,
      splashColor: color,
      disabledColor: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            color: color,
            size: 30,
          ),
          SizedBox(height: 10),
          Text(
            "$text",
            style: TextStyle(
                color: Colors.black45,
                fontWeight: FontWeight.w600,
                fontSize: 16),
          ),
          (subtitle == null || subtitle == '') ? Center() : Text("$subtitle") 
        ],
      ),
      onPressed: click,
    );
  }
}
