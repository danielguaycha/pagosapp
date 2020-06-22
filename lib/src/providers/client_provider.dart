import 'package:dio/dio.dart';
import 'package:pagosapp/src/models/client.dart';
import 'package:pagosapp/src/models/responser.dart';
import 'package:pagosapp/src/plugins/http.dart';
import 'package:pagosapp/src/utils/exepctions.dart';

class ClientProvider {
   final _http = HttpClient().dio;
  
    
   Future<Responser> store(Client c) async {
      FormData formData = FormData.fromMap({
        "name": c.name,
        "fb": c.fb,
        "phone_a": c.phoneA,
        "phone_b": c.phoneB,
        "address_a": c.addressA,
        "city_a": c.cityA,
        "lat_a": c.latA,
        "lng_a": c.lngA,
        "ref_a" : c.refOne == null ? null : await MultipartFile.fromFile(c.refOne.path),
        "address_b": c.addressB,  
        "city_b": c.cityB,      
        "lat_b": c.latB,
        "lng_b": c.lngB,
        "ref_b" : c.refTwo == null ? null : await MultipartFile.fromFile(c.refTwo.path),        
      });

      try {
      Response res = await _http.post('/client', data: formData);
        return Responser.fromJson(res.data);
      } catch(e) {
        return Responser.fromJson(processError(e));
      }
   }

   Future<Responser> list() async {
     try {
      Response res = await _http.get("/client/list");
      return Responser.fromJson(res.data);
     } catch (e) {
       return Responser.fromJson(processError(e));
     }
   }

   Future<Responser> history() async {
     try {
      Response res = await _http.get("/client/history");
      return Responser.fromJson(res.data);
     } catch (e) {
       return Responser.fromJson(processError(e));
     }
   }
   
   Future<Responser> search(String data) async {
     try {
      Response res = await _http.get("/client/search?data=$data");
      return Responser.fromJson(res.data);
     } catch (e) {
       return Responser.fromJson(processError(e));
     }
   }

  Future<Responser> showClient(int id) async{
    try {
      Response res = await _http.get("/client/$id");
      return Responser.fromJson(res.data);
    } catch (e) {
       return Responser.fromJson(processError(e));
    }
  }

  Future<Responser> upDateClient(Client c) async{
          FormData formData = FormData.fromMap({
        "name": c.name,
        "fb": c.fb,
        "phone_a": c.phoneA,
        "phone_b": c.phoneB,
        "address_a": c.addressA,
        "city_a": c.cityA,
        "lat_a": c.latA,
        "lng_a": c.lngA,
        "ref_a" : c.refOne == null ? null : await MultipartFile.fromFile(c.refOne.path),
        "address_b": c.addressB,  
        "city_b": c.cityB,      
        "lat_b": c.latB,
        "lng_b": c.lngB,
        "ref_b" : c.refTwo == null ? null : await MultipartFile.fromFile(c.refTwo.path),        
      });

      try {
      Response res = await _http.post('/client/${c.id}', data: formData);
        return Responser.fromJson(res.data);
      } catch(e) {
        return Responser.fromJson(processError(e));
      }

  }
}