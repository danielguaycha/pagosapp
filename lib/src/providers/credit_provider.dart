import 'package:dio/dio.dart';
import 'package:pagosapp/src/models/credit.dart';
import 'package:pagosapp/src/models/responser.dart';
import 'package:pagosapp/src/plugins/http.dart';
import 'package:pagosapp/src/utils/exepctions.dart';

class CreditProvider {
   final _http = HttpClient().dio;

  Future<Responser> store(Credit c) async {
    
    FormData formData = FormData.fromMap({
      "monto": c.monto,
      "utilidad": c.utilidad,
      "plazo": c.plazo,
      "cobro": c.cobro,
      "person_id": c.personId,          
      "prenda_detail": c.prendaDetail,
      "prenda_img": c.filePrenda == null ? null : await MultipartFile.fromFile(c.filePrenda.path),
      'guarantor_id': c.guarantorId
    });
    try {
      Response res = await _http.post('/credit', data: formData);
      return Responser.fromJson(res.data);
    } catch(e) {
      return Responser.fromJson(processError(e));
    }
  }

}