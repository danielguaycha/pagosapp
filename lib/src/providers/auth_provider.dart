import 'package:dio/dio.dart';
import 'package:pagosapp/src/models/responser.dart';
import 'package:pagosapp/src/plugins/http.dart';
import 'package:pagosapp/src/plugins/preferences.dart';
import 'package:pagosapp/src/utils/exepctions.dart';

class AuthProvider {
  final prefs = LocalPrefs();
  final _http = HttpClient().dio;

  Future<Responser> login(String email, String password) async {
    final authData = {
      'username': email,
      'password': password,
    };
    try {
      Response response = await _http.post('/login',  data: authData);
      prefs.token = response.data['access_token'].toString();
      return Responser.fromJson({'data': response.data});
    } on DioError catch (e) {
      return Responser.fromJson(processError(e));
    }
  }

}