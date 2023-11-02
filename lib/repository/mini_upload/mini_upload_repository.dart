import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smexpo2023/model/api_model.dart';
import 'package:smexpo2023/provider/api_provider.dart';
import 'package:smexpo2023/repository/api_repository.dart';

final providerMinioRepo = Provider<MinioRepository>(
    (ref) => MinioRepository(init: ref.read(providerApiMinio())));

class MinioRepository {
  ApiRepository init;
  MinioRepository({required this.init});

  Future<ApiModel> uploadMinio({required FormData fileUpload}) async {
    try {
      var res = await init.uploadFile(fileUpload);
      return res;
    } on DioException catch (e) {
      return ApiModel.fromJson(e.response?.data);
    }
  }
}
