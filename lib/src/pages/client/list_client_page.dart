import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pagosapp/src/models/client/client_history.dart';
import 'package:pagosapp/src/models/responser.dart';
import 'package:pagosapp/src/pages/client/actions_client_page.dart';
import 'package:pagosapp/src/providers/client_provider.dart';
import 'package:pagosapp/src/utils/exepctions.dart';
import 'package:pagosapp/src/utils/utils.dart';
import 'package:pagosapp/src/utils/validators.dart';

class ListClientPage extends StatefulWidget {
  final bool returning;
  ListClientPage({Key key, @required this.returning}) : super(key: key);

  @override
  _ListClientPageState createState() => _ListClientPageState();
}

class _ListClientPageState extends State<ListClientPage> {
  bool isSearching = false;
  String valueTosearch = "null";
  List<ClientHistory> _clients;
  bool _loader;
  String _error;
  @override
  void initState() { 
    _clients = new List();
    _loader = false;
    _loadClients();
    super.initState();    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !isSearching
            ? Text('Clientes')
            : TextField(
                autofocus: true,
                onChanged: (value) {
                  valueTosearch = value;
                  setState(() { });
                  // _filterCountries(value);
                },
                onSubmitted: (v) {
                  this._loadClients(search: true, data: v);
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(                   
                    hintText: "Buscar cliente",
                    hintStyle: TextStyle(color: Colors.white60)),
              ),
        actions: <Widget>[
          isSearching
              ? IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      this.isSearching = false;
                      valueTosearch = "null";                      
                      this._loadClients();
                      //llenar los datos con la busqueda
                      // filteredCountries = countries;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      this.isSearching = true;
                    });
                  },
                )
        ],
      ),
      body: _listClient(),
    );
  }

  void _loadClients({search: false, String data: ''}) async {
    setState(() {
      _clients.clear();
      _loader = true;
    });
    Responser res;

    if(!search) res = await ClientProvider().history();
    else res = await ClientProvider().search(data);

    if(res.ok) {
      var results = res.data;
      for(var i=0; i<results.length; i++) {
         _clients.add(ClientHistory.fromJson(json.encode((results[i]))));   
      }
    } else {
      _error = res.message;
    }
    _loader = false;
    setState(() {});
  }

  Widget _listClient() {
    if(_loader) {
      return loader(text: "Cargando clientes...");
    }

    if(_error != null) {
      return renderError(_error, () {});
    }

    if (_clients.length <= 0) {
      return renderNotFoundData("No hay coincidencias para mostrar");
    }

    return _buildItems(context);   
  }

  Widget _buildItems(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) => Container(
              height: 0.0,
              width: 0.0,
            ),
            itemCount: _clients.length,
            itemBuilder: (BuildContext context, int index) {                        
              return _elements(context, _clients[index]);
            },
          ),
        ),        
      ],
    );
  }

  Widget _elements(BuildContext context, ClientHistory client) {
    return Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.20,
        child: ListTile(     
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),  
          title: Row(
            children: <Widget>[
              Icon(FontAwesomeIcons.dollarSign, size: 19, color: client.getColor()),
              SizedBox(width: 5),
              Text("${client.name}", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: client.getColor())),
            ],
          ),          
          subtitle: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Flexible(child: Text("${client.cityA} | ${client.addressA}")),
                ],
              ),
              Row(
                children: <Widget>[
                  (client.fInicio == null)? Text("Sin créditos") :Text("${dateForHumans2(client.fInicio)} - ${dateForHumans2(client.fFin)}")
                ],
              )              
            ],
          ),
          trailing: client.total > 0  ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("${money(client.total)}", style: TextStyle(color: Colors.black54)),
                  Text(" / "),
                  Text("${money(client.paid)}", style: TextStyle(color: Colors.black87)),
                ],
              ),
              Text("${client.cobro}", style: TextStyle(fontWeight: FontWeight.w400))
            ],
          ) : null,
          onTap: () { 
            if(widget.returning){
              Navigator.pop(context, client);
            }else{
              Navigator.push(context, MaterialPageRoute(builder: (context) => ActionsClient(clientData: client)));
            }
          },
        ),
        actions: <Widget>[          
        ],
        secondaryActions: <Widget>[
           IconSlideAction(
            caption: 'Editar',            
            icon: Icons.edit,
            color: Colors.blue,
            onTap: null,
          ),         
        ]);
  }
}