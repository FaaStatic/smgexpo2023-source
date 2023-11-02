import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smexpo2023/model/statemodel/api_general.dart';
import 'package:smexpo2023/repository/transaksi/transaksi_repository.dart';

final providerNotaTransaksi = StateNotifierProvider<NotaPrint, ApiGeneral>(
    (ref) => NotaPrint(init: ref.watch(providerApiTransaksi)));

class NotaPrint extends StateNotifier<ApiGeneral> {
  final TransaksiRepository init;
  NotaPrint({required this.init})
      : super(ApiGeneral(
          response: null,
          status: 0,
          message: "",
          loading: false,
        ));

  Future<void> getNotaTransaksi({
    required String noOrder,
  }) async {
    try {
      state.loading = true;
      await init.getPrint(noOrder: noOrder).then((value) {
        if (value.status == 200) {
          print(value.response);
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
