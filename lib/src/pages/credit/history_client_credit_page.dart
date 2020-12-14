import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pagosapp/src/models/client/client_history.dart';
import 'package:pagosapp/src/models/credit/credit_history.dart';
import 'package:pagosapp/src/providers/credit_provider.dart';
import 'package:pagosapp/src/utils/exepctions.dart';
import 'package:pagosapp/src/utils/utils.dart';
import 'package:pagosapp/src/utils/validators.dart';

class HistoryClientCreditPage extends StatelessWidget {
  final ClientHistory client;

  HistoryClientCreditPage(this.client);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${this.client.name}"),
      ),
      body: FutureBuilder(
        future: CreditProvider().showForClient(this.client.id),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return renderError(snapshot.error, (){});
          }

          if (!snapshot.hasData) return loader(text: "Cargando créditos...");

          var results = snapshot.data.data;

          if (results != null && results.length <= 0) {
            return renderNotFoundData("No hay coincidencias para mostrar");
          }

          return ListView.separated(
            separatorBuilder: (context, index) => Divider(height: 1,),
            itemCount: results.length,
            itemBuilder: (BuildContext context, int index) {
              var credit = CreditHistory.fromJson(json.encode(results[index]));
              Color c = _color(credit);
              String estado ="";
              if(credit.status == CreditHistory.STATUS_ACTIVO) {
                estado = " | Activo";
              } else {
                estado = " | Finalizado";
              }
              return ListTile(
                leading: Icon(Icons.monetization_on,
                    size: 30, color: c),
                title: Text(
                  "${money(credit.total)}",
                  style: TextStyle(
                      color: c,
                      fontWeight: FontWeight.w500),
                ),
                trailing: Text("Atraso\n${credit.mora} dias", style: TextStyle(color: c, fontWeight: FontWeight.w500),),
                subtitle: Text("${dateForHumans2(credit.fInicio)} - ${dateForHumans2(credit.fFin)} $estado"),
              );
            },
          );
        }),
    );
  }

  Color _color(CreditHistory c){
    if(c.status == CreditHistory.STATUS_ACTIVO && isBefore(c.fFin)) {
      return Colors.green;
    } else {
      if (c.mora > 30) {
        return Colors.red;
      }
      else if (c.mora >= 15 && c.mora <30) {
        return Colors.orange;
      }
      else
        return Colors.green;
    }    
  }
}
