import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:pagosapp/main.dart';
import 'package:pagosapp/src/config.dart';
import 'package:pagosapp/src/plugins/navigator.dart';
import 'package:pagosapp/src/plugins/preferences.dart';

class HttpClient {

  Dio dio;
  DioCacheManager _cacheManager;
  final NavigationService _navigationService = locator<NavigationService>();


  HttpClient() {
    _cacheManager = DioCacheManager(CacheConfig(baseUrl: urlApi, databaseName: 'paycenter.db'));
    dio = new Dio(new BaseOptions(
        baseUrl: urlApi,
        connectTimeout: 120000,
        receiveTimeout: 120000,
        headers: {
          "Accept": 'application/json'
        },
        responseType: ResponseType.json
    ));
    final prefs = LocalPrefs();
    dio.interceptors.add(InterceptorsWrapper(
        onRequest:(RequestOptions options) async {
          if( prefs.token != null ) {
            options.headers["Authorization"] = "Bearer ${prefs.token}";
          }
          return options; //continue
        },
        onResponse:(Response response) async {
          return response; // continue
        },
        onError: (DioError e) async {
          if (e.response!=null && e.response.statusCode == 401 && prefs.token != null) {
              prefs.token = null;
              _navigationService.navigateTo('login');
          }
          return e;//continue
        }
    ));
    dio.interceptors.add(_cacheManager.interceptor);
  }

  clearCachePrimary(path) {
    _cacheManager.deleteByPrimaryKey(urlApi+path);
  }

  clearAllCache() {
    if (_cacheManager != null)
      _cacheManager.clearAll();
  }

  clearExpired() {
    _cacheManager.clearExpired();
  }
}