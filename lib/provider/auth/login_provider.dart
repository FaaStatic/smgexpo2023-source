import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smexpo2023/model/statemodel/api_general.dart';
import 'package:smexpo2023/repository/auth/auth_repository.dart';
import 'package:smexpo2023/util/storage_util.dart';

final providerLogin = StateNotifierProvider<LoginProvider, ApiGeneral>(
    (ref) => LoginProvider(init: ref.watch(providerApiAuth)));

class LoginProvider extends StateNotifier<ApiGeneral> {
  final AuthRepository init;
  LoginProvider({required this.init})
      : super(
            ApiGeneral(response: null, status: 0, message: "", loading: false));

  Future<void> loginProcess(
      {required String username, required String pass}) async {
    try {
      state.loading = true;
      await init.loginAuth(user: username, pass: pass).then((value) {
        if (value.status == 200) {
          var key = dotenv.get("SESSION");
          StorageUtil.storeAsString(key, jsonEncode(value.response))
              .whenComplete(() {
            print(value.message);
          }).onError((error, stackTrace) {
            print(error.toString());
          });

          state = state.copyWith(
              value.response, value.status, value.message, false);
        } else {
          state = state.copyWith(
              value.response, value.status, value.message, false);
        }
      });
    } on DioException catch (e) {
      state.copyWith(e.response?.data, e.response?.statusCode,
          e.response?.statusMessage, false);
    }
  }
}
