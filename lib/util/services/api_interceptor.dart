import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smexpo2023/model/user_model.dart';
import 'package:smexpo2023/util/storage_util.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print(options.data);
    String session = dotenv.get('SESSION');
    StorageUtil.getAsMap(session).then((value) {
      if (value["data"] == "kosong") {
      } else {
        UserModel sesiInfo = UserModel.fromJson(value);
        options.headers.addAll({"token": sesiInfo.token});
        options.headers.addAll({"uid": sesiInfo.id});
        options.headers.addAll({"username": sesiInfo.username});
        options.headers.addAll({"flag": sesiInfo.flag});
      }
    });
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(response.statusMessage);
    print(response.statusCode);
    // print(response.data);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print(err.message);
    print(err.error.toString());
    super.onError(err, handler);
  }
}
