import 'dart:io';
import 'package:dio/dio.dart';
import 'package:pagosapp/src/models/responser.dart';
import 'package:pagosapp/src/plugins/http.dart';
import 'package:pagosapp/src/utils/utils.dart' show processError;

class ExpenseProvider{
  
  final _http = HttpClient().dio;



  Future<Responser> store(double monto, String category, String description, String date, File image) async {

     FormData formData = FormData.fromMap({
        "monto"       : monto,
        "category"    : category,
        "description" : description,
        "date"        : date == null ? null : date,
        "image"       : image == null ? null : await MultipartFile.fromFile(image.path),
     });
    try {

      Response res = await _http.post('/expense', data: formData);
      return Responser.fromJson(res.data);
    } catch (e) {
      return Responser.fromJson(processError(e));
    }
  }

  Future<Responser> list({int page = 1, String dateFrom = "null", String dateTo = "null"}) async {

    String url = "/expense?page=$page";
    
    url = (dateFrom !="null") ? url + "&from=$dateFrom" : url;
    url = (dateTo !="null") ? url + "&to=$dateTo" : url;
    
    Response res = await _http.get(url);
    return Responser.fromJson(res.data);
  }

    Future<Responser> invalidate(int id, String reason) async {
      try {
        Response res = await _http.delete('/expense/$id', data: {"description" : reason });
        return Responser.fromJson(res.data);
      } catch (e) {
        return Responser.fromJson(processError(e));
      }
  }
}