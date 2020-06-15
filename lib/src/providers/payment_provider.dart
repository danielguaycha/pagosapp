import 'package:dio/dio.dart';
import 'package:pagosapp/src/models/responser.dart';
import 'package:pagosapp/src/plugins/http.dart';
import 'package:pagosapp/src/utils/exepctions.dart';

class PaymentProvider {
   final _http = HttpClient().dio;

   //Listar pagos por dia
  Future<dynamic> listPaymentsForDay(String date) async {   
    String url = "/payment?date="+date;
    Response res = await _http.get(url);
    try {      
      return Responser.fromJson(res.data);
    } catch(e) {      
      return Responser.fromJson(processError(e));
    }
  }

  Future<Responser> updatePayment(int id, int status) async {
    // status = -1 -> mora
    // status = 2 -> pagado    
    try {
      Response res = await _http.put('/payment/$id', data: {"status": status});
      return Responser.fromJson(res.data);
    } catch (e) {
      return Responser.fromJson(processError(e));
    }
  }

  Future<dynamic> deletePayments(id, description) async {
    try {
    Response res = await _http.delete("/payment/$id", data: {"description": description});
    return Responser.fromJson(res.data);
    } catch (e) {
      return Responser.fromJson(processError(e));
    }
  }

  //Listar el historial de pagos
  Future<dynamic> listPayments(id) async {
    Response res = await _http.get("/payment/$id");
    return Responser.fromJson(res.data);
  }

}