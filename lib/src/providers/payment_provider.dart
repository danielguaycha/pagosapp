import 'package:dio/dio.dart';
import 'package:pagosapp/src/models/responser.dart';
import 'package:pagosapp/src/plugins/http.dart';
import 'package:pagosapp/src/utils/exepctions.dart';

class PaymentProvider {
  final _http = HttpClient().dio;

  //Listar historial de pagos 26-06-2020
  Future<dynamic> listsPays(id, {bool all: false}) async {
    var url = "/pays/$id";
    if (all) {
      url = url + "?all=true";
    }
    Response res = await _http.get(url);
    return Responser.fromJson(res.data);
  }

  //Pay
  Future<Responser> pay({creditId, payId}) async{
    try{
      Response res = await _http.post('/pay/$creditId', data: {"pay": payId});
      return Responser.fromJson(res.data);
    }catch(e) {
      return Responser.fromJson(processError(e));
    }
  }

  //Abono
  Future<Responser> abono(int idCredito, double value, {dynamic payId}) async {
      FormData formData = FormData.fromMap({
        "abono": value,
        "pay_id": payId
      });
      
      try {
      Response res = await _http.post('/abono/$idCredito', data: formData);
        return Responser.fromJson(res.data);
      } catch(e) {
        return Responser.fromJson(processError(e));
      }
   }

   //* OLD CODE
  //Listar pagos por dia
  Future<dynamic> listPaymentsForDay(String date) async {
    String url = "/payment?date=" + date;
    Response res = await _http.get(url);
    try {
      return Responser.fromJson(res.data);
    } catch (e) {
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
      Response res = await _http
          .delete("/payment/$id", data: {"description": description});
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
