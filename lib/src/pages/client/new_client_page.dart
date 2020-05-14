import 'dart:io';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pagosapp/src/plugins/file_manager.dart';
import 'package:pagosapp/src/plugins/style.dart';
import 'package:pagosapp/src/utils/utils.dart';
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
  File _refOne;
  File _refTwo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         title: Text("Nuevo cliente")         
       ),
       floatingActionButton: FloatingActionButton(onPressed: null, child: Icon(FontAwesomeIcons.solidSave, color: Style.primary[800],)),
       body: SingleChildScrollView(
         child: Padding(
           padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
           child: Form(
             child: Column(
               children: <Widget>[
                 TextFormField(
                   textCapitalization: TextCapitalization.words,
                   decoration: InputDecoration(
                     labelText: 'Nombre:',                   
                   ),                 
                 ),
                 TextFormField(
                   keyboardType: TextInputType.phone,
                   decoration: InputDecoration(
                     labelText: 'Telefono Personal',                   
                   ),                 
                 ),
                 TextFormField(
                   keyboardType: TextInputType.phone,
                   decoration: InputDecoration(
                     labelText: 'Telefono Trabajo:',                   
                   ),                 
                 ),
                 TextFormField(
                   decoration: InputDecoration(
                     labelText: 'Facebook:',                   
                   ),                 
                 ),
                 SizedBox(height: 10,),
                 _expandPanel(
                   header: "Dirección de domicilio",
                   iconHeader: FontAwesomeIcons.addressBook,
                   collapChild: Column(
                     children: <Widget>[
                       TextFormField(
                         textCapitalization: TextCapitalization.sentences,
                         decoration: InputDecoration(
                            hintText: 'Ingrese dirección de domicilio',                   
                         ),
                       ),
                       _showReferenceOne(context),
                      SizedBox(height: 10),
                      _switchGeoLoc()
                     ],
                   )
                 ),
                 
                 Divider(),
                 _expandPanel(
                   header: "Dirección Trabajo",
                   iconHeader: FontAwesomeIcons.addressCard,
                   child: Column(
                     children: <Widget>[
                       TextFormField(
                         textCapitalization: TextCapitalization.sentences,
                         decoration: InputDecoration(
                            hintText: 'Ingrese dirección de trabajo',                   
                         ),
                       ),
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

  //* Funciones
  // Referencias
  _loadReferenceOne({ @required ImageSource source }) async {
    setState(() {_loadRefOne = true;});
    File img = await ImagePicker.pickImage(source: source);
    if(img != null)
      _refOne = await compressImg(img);    
    setState(() {_loadRefOne = false;});
  }

  _loadReferenceTwo({ @required ImageSource source }) async {
    setState(() {_loadRefTwo = true;});
    File img = await ImagePicker.pickImage(source: source);
    if(img != null)
      _refTwo = await compressImg(img);    
    setState(() {_loadRefTwo = false;});
  }

  //* Wigets

  Widget _showReferenceOne(context) {
    
    if (_refOne == null && !_loadRefOne) { //? si no esta cargado nada
      return _showButtons(
        onCamera: (){
          _loadReferenceOne(source: ImageSource.camera);
        },
        onGallery: (){
          _loadReferenceOne(source: ImageSource.gallery);
        }
      );
    } 
    else if(_refOne == null && _loadRefOne ) { //? Si la imagen esta cargando
      return miniLoader();
    }
    else { //? Si ya esta cargada
      return _showTumbnail(
        tag: "Referencia",
        img: _refOne,
        onRemove: () {          
          setState(() {
            _refOne = null;
          });          
      });
    } 
  }

  Widget _showReferenceTwo(context) {
    
    if (_refTwo == null && !_loadRefTwo) { //? si no esta cargado nada
      return _showButtons(
        onCamera: (){
          _loadReferenceTwo(source: ImageSource.camera);
        },
        onGallery: (){
          _loadReferenceTwo(source: ImageSource.gallery);
        }
      );
    } 
    else if(_refTwo == null && _loadRefTwo ) { //? Si la imagen esta cargando
      return miniLoader();
    }
    else { //? Si ya esta cargada
      return _showTumbnail(
        tag: "Referencia",
        img: _refTwo,
        onRemove: () {          
          setState(() {
            _refTwo = null;
          });          
      });
    } 
  }

  Widget _switchGeoLoc() {
      return SwitchListTile(
        value: _geoloc, 
        contentPadding: EdgeInsets.symmetric(vertical: 2),
        title: _swicthTitle(
          title: "Usar la ubicación del domicilio",        
          icon: FontAwesomeIcons.mapMarkerAlt,
          swicthed: _geoloc
        ),
        subtitle: _subtitle(text: "¿En esta ubicación se harán los cobros?"),
        onChanged: (value) {
          setState(() {
            _geoloc = value;                
          });
        },
      );
  }

  Widget _switchGeoLocB() {
      return SwitchListTile(
        value: _geolocB, 
        contentPadding: EdgeInsets.symmetric(vertical: 2),
        title: _swicthTitle(
          title: "Usar ubicación del Trabajo",        
          icon: FontAwesomeIcons.mapMarkerAlt,
          swicthed: _geolocB
        ),
        subtitle: _subtitle(text: "¿En esta ubicación se harán los cobros?"),
        onChanged: (value) {
          setState(() {       
            _geolocB = value;           
          });
        },
      );
  }
  //* Extra widgets

  _showButtons({Function onCamera, Function onGallery}) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton.icon(
            onPressed: onCamera,           
            label: Text("Cámara"),
            icon: Icon(Icons.camera),
          ),
          FlatButton.icon(
            onPressed: onGallery,           
            label: Text("Galeria"),
            icon: Icon(Icons.image),
          ),
        ],
      );
  }

  _showTumbnail({tag: '', Function onRemove, @required File img}) {
    return ListTile(
        contentPadding: EdgeInsets.all(0),        
        trailing: IconButton(
          onPressed: onRemove, 
          icon: Icon(Icons.delete)
        ),
        leading: Image.file(img),
        title: Text("$tag cargada"),
        subtitle: Text("${(img.lengthSync() / 1024).roundToDouble()} kb"),
      );
  }
  
  Widget _expandPanel({Widget child, Widget collapChild, header: "", IconData iconHeader: Icons.place }) {
    return ExpandablePanel(          
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
          header: _swicthTitle(title: '$header', icon: iconHeader, swicthed: true),
          expanded: child == null ? SizedBox.shrink(): child,                    
          collapsed: collapChild == null ? SizedBox.shrink(): collapChild,                    
        );
  }
   
  Widget _swicthTitle({title: '', IconData icon, bool swicthed : false}) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          //Icon(icon, color: (swicthed ? Colors.orange: Colors.grey) ),
          //SizedBox(width: 15),
          Text("$title", style: TextStyle(color: Colors.black87, fontSize: 16))
        ],
      );
  }

  Widget _subtitle ({text: ''}) {
    return Row(
      children: <Widget>[        
        Text("$text", style: TextStyle(fontSize: 12))
      ],
    );
  }
}