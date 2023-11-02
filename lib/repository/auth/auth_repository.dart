import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smexpo2023/model/api_model.dart';
import 'package:smexpo2023/provider/api_provider.dart';
import 'package:smexpo2023/repository/api_repository.dart';

final providerApiAuth = Provider<AuthRepository>(
    (ref) => AuthRepository(init: ref.read(providerApi())));

class AuthRepository {
  ApiRepository init;
  AuthRepository({required this.init});

  Future<ApiModel> loginAuth(
      {required String user, required String pass}) async {
    try {
      var res = await init.loginAuth(user: user, pass: pass);
      return res;
    } on DioException catch (e) {
      return ApiModel.fromJson(e.response?.data);
    }
  }
}
