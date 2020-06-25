import 'dart:io';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:easy_alert/easy_alert.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pagosapp/src/models/client.dart';
import 'package:pagosapp/src/models/client/client_history.dart';
import 'package:pagosapp/src/models/responser.dart';
import 'package:pagosapp/src/plugins/contacts.dart';
import 'package:pagosapp/src/plugins/file_manager.dart';
import 'package:pagosapp/src/plugins/messages.dart';
import 'package:pagosapp/src/plugins/perms.dart';
import 'package:pagosapp/src/plugins/progress_loader.dart';
import 'package:pagosapp/src/plugins/style.dart';
import 'package:pagosapp/src/providers/client_provider.dart';
import 'package:pagosapp/src/utils/utils.dart';
import 'package:pagosapp/src/utils/validators.dart';
import 'package:permission_handler/permission_handler.dart';

class NewClientPage extends StatefulWidget {
  NewClientPage({Key key}) : super(key: key);

  @override
  _NewClientPageState createState() => _NewClientPageState();
}

class _NewClientPageState extends State<NewClientPage> {

  bool _loadRefOne = false;
  bool _loadRefTwo = false;
  bool _geoloc = false;
  bool _geolocB = false;  
  Client _client;
  ContactManager _cm;

  ProgressLoader _loader;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<AutoCompleteTextFieldState<String>> _key = new GlobalKey();  
  GlobalKey<AutoCompleteTextFieldState<String>> _key2 = new GlobalKey();  
  
  final List<String> _cities = ['Machala', 'Manta', 'Huaquillas', 'El Guabo', 'Sta. Rosa', 'Pasaje', 'El Cambio'];  

  @override
  void initState() {
    this._client = new Client();  
    this._cm = new ContactManager();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _loader = new ProgressLoader(context);
    return Scaffold(      
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Nuevo cliente"),
        centerTitle: true,    
      ),
      floatingActionButton: FloatingActionButton(onPressed:(){ _submit(context);}, child: Icon(FontAwesomeIcons.solidSave, color: Style.primary[800],)),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(          
           padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 70),
           child: Form(
             key: _formKey,
             child: Column(
               children: <Widget>[
                 TextFormField(                   
                   textCapitalization: TextCapitalization.words,
                   decoration: InputDecoration(
                     labelText: 'Nombre',                   
                   ),
                   onSaved: (v) { this._client.name = v; },
                   validator: (v) {
                    if (v.trim() == '') {
                      return 'Ingrese su nombre';
                    }
                    return null;
                   },
                 ),
                 TextFormField(
                   keyboardType: TextInputType.phone,
                   decoration: InputDecoration(
                     labelText: 'Telefono Personal',                   
                   ),     
                   onSaved: (v) { this._client.phoneA = v; },      
                   onChanged: (v) { this._client.phoneA = v; },      
                   validator: (v) {
                     if(_client.phoneA == null && _client.phoneB == null) {
                       return "Ingrese al menos un teléfono personal";
                     }
                     return null;
                   },      
                 ),
                 TextFormField(
                   keyboardType: TextInputType.phone,
                   decoration: InputDecoration(
                     labelText: 'Telefono Trabajo',                   
                   ),                 
                   onSaved: (v) { this._client.phoneB = v; },
                   onChanged: (v) { this._client.phoneB = v; },
                 ),
                 TextFormField(
                   decoration: InputDecoration(
                     labelText: 'Facebook',                   
                   ),                 
                   onSaved: (v) { this._client.fb = v; },                   
                 ),
                 SizedBox(height: 10,),
                 Divider(),
                 expandPanel(
                   header: "Dirección de domicilio",
                   iconHeader: FontAwesomeIcons.addressBook,
                   child: Column(
                     children: <Widget>[
                       _comboCityA(),
                       SizedBox(height: 15),
                       TextFormField(
                         textCapitalization: TextCapitalization.sentences,
                         decoration: InputDecoration(
                            hintText: 'Ingrese dirección de domicilio',                   
                         ),
                         onSaved: (v) { this._client.addressA = v; },
                         onChanged: (v) { this._client.addressA = v; },
                         validator: (v) {
                          if(_client.addressA == null && _client.addressB == null) {
                            return "Ingrese una dirección";
                          }
                          return null;
                         },
                       ),
                       SizedBox(height: 15),
                      _switchGeoLoc(),
                      SizedBox(height: 15),
                       _showReferenceOne(context),
                     ],
                   )
                 ),                 
                 Divider(),
                 expandPanel(
                   header: "Dirección Trabajo",
                   iconHeader: FontAwesomeIcons.addressCard,
                   child: Column(
                     children: <Widget>[
                       _comboCityB(),
                       SizedBox(height: 10),
                       TextFormField(
                         textCapitalization: TextCapitalization.sentences,
                         decoration: InputDecoration(
                            hintText: 'Ingrese dirección de trabajo',                   
                         ),
                         onSaved: (v) { this._client.addressB = v; },
                       ),
                       SizedBox(height: 10),
                        _showReferenceTwo(context),
                        SizedBox(height: 10),
                        _switchGeoLocB()
                     ],
                   )
                 ),                                  
               ],
             )
           ),
         ),
      ),
    );
  }

  //* Guardar el formulario
  void _submit(context) async {          
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();

    if(!await contactPerms()) {
      toast("El permiso es requerido");
      return;
    }
        
    if (!await confirm(context, title: "¿Desea guardar el cliente?", content: "Nombre: ${_client.name}\nTelf.: ${_client.phoneA}-${_client.phoneB}")) {    
      return;
    }

    _loader.show(msg: "Procesando cliente, espere");
    // geolocalización
    if(_geoloc || _geolocB) {
      final loc = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      if(_geoloc) {
        _client.latA = loc.latitude;
        _client.lngA = loc.longitude;
      }
      if(_geolocB) {
        _client.latB = loc.latitude;
        _client.lngB = loc.longitude;
      }
    }

    Responser res = await ClientProvider().store(_client);
    if (res.ok) {      
      _cm.addContact(name: _client.name, phoneA: _client.phoneA, phoneB: _client.phoneB);
      _loader.hide();
      int id = parseInt(res.data['id']);
      Navigator.pop(context,  ClientHistory(name: _client.name.toUpperCase(), id: id));      
    } else {
      _scaffoldKey.currentState
          .showSnackBar(customSnack(res.message, type: 'err'));
      _loader.hide();
    }    
  }

  //* Funciones
  // Referencias
  void _loadReferenceOne({ @required ImageSource source }) async {
    setState(() {_loadRefOne = true;});
    File img = await ImagePicker.pickImage(source: source);
    if(img != null)
      _client.refOne = await compressImg(img);    
    setState(() {_loadRefOne = false;});
  }

  void _loadReferenceTwo({ @required ImageSource source }) async {
    setState(() {_loadRefTwo = true;});
    File img = await ImagePicker.pickImage(source: source);
    if(img != null)
      _client.refTwo = await compressImg(img);    
    setState(() {_loadRefTwo = false;});
  }

  //* Wigets
  Widget _showReferenceOne(context) {
    
    if (_client.refOne == null && !_loadRefOne) { //? si no esta cargado nada
      return buttonImage(
        onCamera: (){
          _loadReferenceOne(source: ImageSource.camera);
        },
        onGallery: (){
          _loadReferenceOne(source: ImageSource.gallery);
        }
      );
    } 
    else if(_client.refOne == null && _loadRefOne ) { //? Si la imagen esta cargando
      return miniLoader();
    }
    else { //? Si ya esta cargada
      return previewImageLoad(
        tag: "Referencia",
        img: _client.refOne,
        onRemove: () {          
          setState(() {
            _client.refOne = null;
          });          
      });
    } 
  }

  Widget _showReferenceTwo(context) {    
    if (_client.refTwo == null && !_loadRefTwo) { //? si no esta cargado nada
      return buttonImage(
        onCamera: (){
          _loadReferenceTwo(source: ImageSource.camera);
        },
        onGallery: (){
          _loadReferenceTwo(source: ImageSource.gallery);
        }
      );
    } 
    else if(_client.refTwo == null && _loadRefTwo ) { //? Si la imagen esta cargando
      return miniLoader();
    }
    else { //? Si ya esta cargada
      return previewImageLoad(
        tag: "Referencia",
        img: _client.refTwo,
        onRemove: () {          
          setState(() {
            _client.refTwo = null;
          });          
      });
    } 
  }

  Widget _switchGeoLoc() {
      return SwitchListTile(
        value: _geoloc, 
        contentPadding: EdgeInsets.symmetric(vertical: 2),
        title: swicthTitle(
          title: "Usar la ubicación del domicilio",        
          icon: FontAwesomeIcons.mapMarkerAlt,
          swicthed: _geoloc
        ),
        subtitle: swicthSubtitle(text: "¿En esta ubicación se harán los cobros?"),
        onChanged: (value) async {
          if(!await locationPerms()) {
            _geoloc = false;
          } else _geoloc = value;                
          setState(() { });
        },
      );
  }

  Widget _switchGeoLocB() {
      return SwitchListTile(
        value: _geolocB, 
        contentPadding: EdgeInsets.symmetric(vertical: 2),
        title: swicthTitle(
          title: "Usar ubicación del Trabajo",        
          icon: FontAwesomeIcons.mapMarkerAlt,
          swicthed: _geolocB
        ),
        subtitle: swicthSubtitle(text: "¿En esta ubicación se harán los cobros?"),
        onChanged: (value) async{
          if(!await locationPerms()) { 
            _geolocB = false;
          } else _geolocB = value;           
          setState(() { });
        },
      );
  }  


  //* Combo ciudad de domicilio
  Widget _comboCityA() {
    return AutoCompleteTextField<String>(
      key: _key,
      controller: TextEditingController(text: _client.cityA),
      decoration: InputDecoration(
        labelText: "Ciudad de docimicilio",
      ),
      suggestions: _cities,   
      clearOnSubmit: false,      
      suggestionsAmount: 3,
      itemBuilder: (context, suggestion) => new Padding(
          child: new ListTile(
            title: new Text(suggestion),
          ),
          padding: EdgeInsets.all(4.0)),
      itemSubmitted: (text)  {
        setState(() {
          _client.cityA = text;          
        });
      },
      itemFilter: (suggestion, input) =>
      suggestion.toLowerCase().startsWith(input.toLowerCase()), 
      itemSorter: (String a, String b) {return -1;},      
    );   
  }

  Widget _comboCityB(){
    return AutoCompleteTextField<String>(
      key: _key2,
      controller: TextEditingController(text: _client.cityB),
      decoration: InputDecoration(
        labelText: "Ciudad de trabajo",
      ),
      suggestions: _cities,
      clearOnSubmit: false,      
      suggestionsAmount: 3,
      itemBuilder: (context, suggestion) => new Padding(
          child: new ListTile(
            title: new Text(suggestion),
          ),
          padding: EdgeInsets.all(4.0)),
      itemSubmitted: (text)  {
        setState(() {
          _client.cityB = text;          
        });
      },
      itemFilter: (suggestion, input) =>
      suggestion.toLowerCase().startsWith(input.toLowerCase()), 
      itemSorter: (String a, String b) {return -1;},      
    ); 
  }
}