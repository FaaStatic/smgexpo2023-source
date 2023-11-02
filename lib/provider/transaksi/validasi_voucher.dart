import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smexpo2023/model/statemodel/api_general.dart';
import 'package:smexpo2023/repository/transaksi/transaksi_repository.dart';

final providerValidasiVoucher =
    StateNotifierProvider<ValidasiVoucher, ApiGeneral>(
        (ref) => ValidasiVoucher(init: ref.watch(providerApiTransaksi)));

class ValidasiVoucher extends StateNotifier<ApiGeneral> {
  final TransaksiRepository init;
  ValidasiVoucher({required this.init})
      : super(ApiGeneral(
          response: null,
          status: 0,
          message: "",
          loading: false,
        ));

  Future<void> validasiVoucher(
      {required String voucher,
      required String phone,
      required String customer,
      required String date,
      required List<Map<String, dynamic>> item}) async {
    try {
      state.loading = true;
      await init
          .validasiVoucher(
              voucher: voucher,
              phone: phone,
              customer: customer,
              item: item,
              date: date)
          .then((value) {
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
