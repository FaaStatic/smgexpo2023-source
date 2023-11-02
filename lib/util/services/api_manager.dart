import 'package:dio/dio.dart';
import 'package:smexpo2023/util/services/api_interceptor.dart';

class ApiManager {
  static final ApiManager _api = ApiManager._internal();

  factory ApiManager() {
    return _api;
  }
  ApiManager._internal();

  Dio init({required String baseUrl, required bool usingForm}) {
    var options = BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(milliseconds: 15000),
        receiveTimeout: const Duration(milliseconds: 30000),
        validateStatus: (status) => status! < 500,
        headers: {
          "Auth-Key": "gmedia_semargress",
          "Client-Service": "frontend-client"
        },
        contentType: usingForm
            ? Headers.multipartFormDataContentType
            : Headers.jsonContentType);
    return Dio(options)..interceptors.add(ApiInterceptor());
  }
}
