import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smexpo2023/model/statemodel/api_general.dart';
import 'package:smexpo2023/repository/mini_upload/mini_upload_repository.dart';

final providerUploadMinioUp = StateNotifierProvider<ProviderUpload, ApiGeneral>(
    (ref) => ProviderUpload(init: ref.watch(providerMinioRepo)));

class ProviderUpload extends StateNotifier<ApiGeneral> {
  final MinioRepository init;
  ProviderUpload({required this.init})
      : super(
            ApiGeneral(response: null, status: 0, message: "", loading: false));

  Future<void> uploadFile({required FormData fileUpload}) async {
    try {
      state.loading = true;
      await init.uploadMinio(fileUpload: fileUpload).then((value) {
        if (value.status == 200) {
          state = state.copyWith(
              value.response, value.status, value.message, false);
        } else {
          state = state.copyWith(
              value.response, value.status, value.message, false);
        }
      });
    } on DioException catch (e) {
      state.copyWith(
          e.response, e.response?.statusCode, e.response?.statusMessage, false);
    }
  }
}
