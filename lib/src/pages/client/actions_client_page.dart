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
        body: GridView.count(
          primary: true,
          crossAxisCount: 1,
          padding: EdgeInsets.only(left: 60, right: 60, top: 20, bottom: 20),
          childAspectRatio: 1.7,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          shrinkWrap: true,
          children: <Widget>[
            _btn(context,
                icon: FontAwesomeIcons.edit,
                color: Colors.blue[300],
                text: 'Editar usuario', click: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditClientPage(
                            clientId: widget.clientData.id,
                            status: 1,
                          )));
            }),
            _btn(context,
                icon: FontAwesomeIcons.moneyBillWave,
                color: Colors.red,
                text: 'Recaudación', click: () {

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ListsPaymentsPage(
                            clientId: widget.clientData.id,
                          )));

            }),
            _btn(context,
                icon: FontAwesomeIcons.history,
                color: Colors.indigo,
                text: 'Historia de Clientes', click: () {
              Navigator.pushNamed(context, 'client_list');
            }),
          ],
        ));
  }

  RaisedButton _btn(BuildContext context,
      {String text: '',
      IconData icon: FontAwesomeIcons.icons,
      Color color: Colors.orange,
      @required void Function() click}) {
    return RaisedButton(
      elevation: 1,
      color: Colors.white,
      splashColor: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, color: color),
          SizedBox(height: 10),
          Text(
            "$text",
            style:
                TextStyle(color: Colors.black45, fontWeight: FontWeight.w400),
          )
        ],
      ),
      onPressed: click,
    );
  }
}
