import 'package:dio/dio.dart';
import 'package:pagosapp/src/models/payments/payment_store.dart';
import 'package:pagosapp/src/models/responser.dart';
import 'package:pagosapp/src/plugins/http.dart';
import 'package:pagosapp/src/utils/exepctions.dart';

class PaymentProvider {
  final _http = HttpClient().dio;

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

  //Listar historial de pagos 26-06-2020
  Future<dynamic> listsPays(id) async {
    print("Pidiendo datos de pagos...");
    Response res = await _http.get("/pays/$id");
    return Responser.fromJson(res.data);
  }

  //Pago normal por Id de crédito 26-06-2020
  Future<Responser> payForCredit(int id, List<Pay> pay) async {

    PaymentStore ps = new PaymentStore(pays: pay);
    
    try {

      Response res = await _http.post('/pay/$id', data: ps.toJson());
      
      return Responser.fromJson(res.data);
    } catch (e) {
      return Responser.fromJson(processError(e));
    }
  }

     Future<Responser> abonoPorCredito(int idCredito, double value) async {     
      FormData formData = FormData.fromMap({
        "abono": value
      });

      try {
      Response res = await _http.post('/abono/$idCredito', data: formData);
        return Responser.fromJson(res.data);
      } catch(e) {
        return Responser.fromJson(processError(e));
      }
   }


}
