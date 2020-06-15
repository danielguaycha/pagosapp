import 'package:flutter/material.dart';
import 'package:pagosapp/src/models/payments/payment_row.dart';
import 'package:pagosapp/src/models/responser.dart';
import 'package:pagosapp/src/plugins/messages.dart';
import 'package:pagosapp/src/providers/payment_provider.dart';
import 'package:pagosapp/src/utils/utils.dart' show confirm, inputDialog;

Future<bool> setMoraPay(context, {@required int payId}) async {
  if(!await confirm(context, title: "Poner pago en mora", content: "¿Está seguro que desea poner pago en Mora?")){
    return false;
  }
  Responser res = await PaymentProvider().updatePayment(payId, PaymentRow.MORA);
  if(res.ok) {  
    toast("Pago cambiado a: MORA");
    return true;
  } else {
    toast(res.message, type: 'err');
    return false;
  }
}

Future<bool> setPaySuccess(context, {@required int payId}) async {
  if(!await confirm(context, title: "Marcar como cobrado", content: "¿Está seguro que desea poner pago como COBRADO?")){
    return false;
  }
  Responser res = await PaymentProvider().updatePayment(payId, PaymentRow.COBRADO);
  if(res.ok) {  
    toast("Pago cambiado a: COBRADO");
    return true;
  } else {
    toast(res.message, type: 'err');
    return false;
  }
} 

Future<bool> cancelPay(context, {@required int payId}) async {
  String reason = await inputDialog(context, title: "Ingrese la razón de la anulación para confirmar", decoration: "¿Porque desea anular este cobro?");
  if(reason==null || reason == '') return false;

  Responser res = await PaymentProvider().deletePayments(payId, reason);
  if(res.ok) {  
    toast("Pago cambiado a: ANULADO");
    return true;
  } else {
    toast(res.message, type: 'err');
    return false;
  }
}