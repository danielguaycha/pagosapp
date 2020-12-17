import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IndexPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text('Home')),
        body: GridView.count(
          primary: true,
          crossAxisCount: 2,
          padding: EdgeInsets.all(10),
          childAspectRatio: 1.7,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          shrinkWrap: true,
          children: <Widget>[         
            _btn(
                context,
                icon: FontAwesomeIcons.moneyBill,
                color: Colors.blue[300],
                text: 'Crédito',
                click: (){
                  Navigator.pushNamed(context, 'credit_add');
                }
            ),
            _btn(
                context,
                icon: FontAwesomeIcons.users,
                color: Colors.indigo,
                text: 'Historia de Clientes',
                click: (){
                  Navigator.pushNamed(context, 'client_list');
                }
            ),
            _btn(
                context,
                icon: FontAwesomeIcons.moneyBillWave,
                color: Colors.red,
                text: 'Recaudación',
                click: (){
                  Navigator.pushNamed(context, 'payment');
                }
            ),            _btn(
                context,
                icon: FontAwesomeIcons.moneyCheckAlt,
                color: Colors.orange,
                text: 'Gastos',
                click: (){
                  Navigator.pushNamed(context, 'expense');
                }
            ),
          ],
        ),
    );
  }

  RaisedButton _btn(BuildContext context, {
        String text: '', IconData icon: FontAwesomeIcons.icons ,
        Color color: Colors.orange, @required void Function() click
    }) {
    return RaisedButton(
          elevation: 1,
          color: Colors.white,
          splashColor: color,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, color: color),
              SizedBox(height: 10),
              Text("$text",              
                style: TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.w400                  
                ),
              )
            ],
          ),
          onPressed: click,
    );
  }
}
