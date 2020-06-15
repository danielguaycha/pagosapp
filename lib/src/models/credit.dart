// To parse this JSON data, do
//
//     final credit = creditFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

import 'package:pagosapp/src/utils/validators.dart';

class Credit {
    double monto;
    double utilidad;
    String plazo;
    String cobro;
    int status;
    int personId;
    int guarantorId;
    int userId;
    int zoneId;
    DateTime fInicio;
    DateTime fFin;
    double totalUtilidad;
    double total;
    double pagosDe;
    double pagosDeLast;
    String description;
    int nPagos;
    int id;
    String prendaImg;
    String prendaDetail;
    File filePrenda;

    Credit({
        this.monto,
        this.utilidad,
        this.plazo,
        this.cobro,
        this.status,
        this.personId,
        this.guarantorId,
        this.userId,
        this.zoneId,        
        this.fInicio,
        this.fFin,
        this.totalUtilidad,
        this.total,
        this.pagosDe,
        this.pagosDeLast,
        this.description,
        this.nPagos=0,
        this.id,       
        this.prendaImg,
        this.prendaDetail,
        this.filePrenda 
    });

    factory Credit.fromJson(String str) => Credit.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Credit.fromMap(Map<String, dynamic> json) => Credit(
        monto: json["monto"],
        utilidad: json["utilidad"],
        plazo: json["plazo"],
        cobro: json["cobro"],
        status: json["status"],
        personId: json["person_id"],
        guarantorId: json["guarantor_id"],
        userId: json["user_id"],
        zoneId: json["zone_id"],        
        fInicio: DateTime.parse(json["f_inicio"]),
        fFin: DateTime.parse(json["f_fin"]),
        totalUtilidad: json["total_utilidad"],
        total: json["total"],
        pagosDe: json["pagos_de"].toDouble(),
        pagosDeLast: json["pagos_de_last"].toDouble(),
        description: json["description"],
        nPagos: parseInt(json["n_pagos"]),
        id: json["id"],
        prendaImg: json["prenda_img"],
        prendaDetail: json["prenda_detail"],     
    );

    Map<String, dynamic> toMap() => {
        "monto": monto,
        "utilidad": utilidad,
        "plazo": plazo,
        "cobro": cobro,
        "status": status,
        "person_id": personId,
        "guarantor_id": personId,
        "user_id": userId,
        "zone_id": zoneId,       
        "f_inicio": "${fInicio.year.toString().padLeft(4, '0')}-${fInicio.month.toString().padLeft(2, '0')}-${fInicio.day.toString().padLeft(2, '0')}",
        "f_fin": "${fFin.year.toString().padLeft(4, '0')}-${fFin.month.toString().padLeft(2, '0')}-${fFin.day.toString().padLeft(2, '0')}",
        "total_utilidad": totalUtilidad,
        "total": total,
        "pagos_de": pagosDe,
        "pagos_de_last": pagosDeLast,
        "description": description,
        "n_pagos": nPagos,
        "id": id,
        "prenda_img": prendaImg,
        "prenda_detail": prendaDetail,
    };
   
   diasPlazo() {
    if(plazo == null) return 0;
    int diasCobro = this.diasCobro();
    switch (plazo) {
      case 'SEMANAL':        
          return diasCobro == 1 ? 6 : 7;        
      case 'QUINCENAL':
        return 15;
      case 'MENSUAL':
        return 30;
      case 'MES_Y_MEDIO':
        return 45;
      case 'DOS_MESES':
        return 60;
    }

  }

  diasCobro() {
    if(cobro == null ) return 0;
    switch (cobro) {
      case 'DIARIO':
        return 1;
      case 'SEMANAL':
        return 7;
      case 'QUINCENAL' :
        return 15;
      case 'MENSUAL':
        return 30;
    }
  }

  calcular() {
    if(monto == null || utilidad == null)
      return;
    if(monto == 0)
      return;
      
    totalUtilidad = monto * (utilidad/100);
    total = monto + totalUtilidad;
    pagosDeLast = 0;

    if(plazo == null || cobro == null )
      return;
    //print("utl pago inicial: $pagosDeLast");
    nPagos = (diasPlazo() / diasCobro()).toInt();
    pagosDe = round((total / nPagos), 2);
    //print("#pagos $npagos | Cuotas: $pagosDe");
    double totalIdeal = pagosDe * nPagos;
    //print("total $total == $totalIdeal");
    if(totalIdeal != total) {
      if (totalIdeal < total) {
        double diferencia = total - totalIdeal;
        //print("$diferencia");
        pagosDeLast = pagosDe + diferencia;
      } else {
        double diferencia = totalIdeal - total;
        pagosDeLast = pagosDe - diferencia;
      }
    }
    dateEnd();
  }

  dateEnd() {        
    if(cobro == null || plazo == null ) {
      fFin = null;
      return;
    }

    print("");
    print("=====================================================");

    int diasCobro = this.diasCobro();
    int diasPlazo = this.diasPlazo();

    print("Cobro: $cobro[$diasCobro] - Plazo: $plazo [$diasPlazo]");
    print("Pagos: $nPagos");
    print("Fechas: ");
   
    if(cobro=='DIARIO') {
      fInicio = DateTime.now().add(new Duration(days: 1));
      print("\t-${dateForHumans2(fInicio)}");
      diasPlazo = diasPlazo-1;
      fFin = fInicio;
      for(var i=0; i<diasPlazo; i++) {
        var newD = _remplaceWeekend(fFin.add(new Duration(days: 1)));  
        fFin = newD;        
        print("\t-${dateForHumans2(fFin)}");
      }
    } else {
      fInicio = DateTime.now();
      fFin = fInicio;
      for(var i=0; i<nPagos; i++) {
        var newD;
        switch(cobro) {
          case 'SEMANAL':
            newD = _remplaceWeekend(fFin.add(new Duration(days: 7)));
          break;
          case 'QUINCENAL':
            newD = _remplaceWeekend(fFin.add(new Duration(days: 14)));
          break;
          case 'MENSUAL':
            newD = _remplaceWeekend(DateTime(fFin.year, fFin.month + 1, fFin.day));
          break;
        }
        
        fFin = newD;
        print("\t-${dateForHumans2(fFin)}");
      }   
    }

/*     if(cobro == 'SEMANAL'){
      fInicio = DateTime.now();
      fFin = fInicio;
      for(var i=0; i<nPagos; i++) {
        var newD = _remplaceWeekend(fFin.add(new Duration(days: 7)));
        fFin = newD;
        print("\t-${dateForHumans2(fFin)}");
      }       
    }

    if(cobro == 'QUINCENAL') {
      fInicio = DateTime.now();
      fFin = fInicio;
      for(var i=0; i<nPagos; i++) {
        var newD = _remplaceWeekend(fFin.add(new Duration(days: 14)));
        fFin = newD;
        print("\t-${dateForHumans2(fFin)}");
      }  
    }

    if(cobro == 'MENSUAL') {
      fInicio = DateTime.now();
      fFin = fInicio;
      for(var i=0; i<nPagos; i++) {
        var newD = _remplaceWeekend(DateTime(fFin.year, fFin.month + 1, fFin.day));
        fFin = newD;
        print("\t-${dateForHumans2(fFin)}");
      }
    } */

    /*DateTime fechaFin = fInicio;
    DateTime init = _remplaceWeekend(fInicio);        
    
    print("Fecha de inicio ${dateForHumans2(init)}");
    print("Pagos: $nPagos");
    print("Dias a agregar $diasPlazo");
    if(diasCobro == 1) {
      for(var i=0; i<diasPlazo; i++) {
        fechaFin = _remplaceWeekend(init.add(new Duration(days: 1)));  
        init = fechaFin;        
      }
    } else {      
      
        fechaFin = init.add(new Duration(days: diasPlazo));
      
    }
            */
    fFin = _remplaceWeekend(fFin);
    //print("${dateForHumans2(fFin)}");

    /* if (diasCobro == 1){           
          if (fInicio.weekday == DateTime.saturday) {
            fechaFin = fechaFin.add(new Duration(days: 2));
          }
          if (fInicio.weekday == DateTime.sunday) {
            fechaFin = fechaFin.add(new Duration(days: 1));
          }
          if(fInicio.weekday != DateTime.saturday && fInicio.weekday != DateTime.sunday) {
            fechaFin = fechaFin.add(new Duration(days: 1));
          }
    } else {*/
  }

  _remplaceWeekend(DateTime date) {    
    if(date==null) {
      return null;
    }
    if(date.weekday == DateTime.sunday) {
      date = date.add(new Duration(days: 1));
    }
    return date;
  }
}
