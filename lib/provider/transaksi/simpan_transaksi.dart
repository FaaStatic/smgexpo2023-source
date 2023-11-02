import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smexpo2023/model/statemodel/api_general.dart';
import 'package:smexpo2023/repository/transaksi/transaksi_repository.dart';

final providerSimpanTransaksi =
    StateNotifierProvider<SimpanTransaksi, ApiGeneral>(
        (ref) => SimpanTransaksi(init: ref.watch(providerApiTransaksi)));

class SimpanTransaksi extends StateNotifier<ApiGeneral> {
  final TransaksiRepository init;
  SimpanTransaksi({required this.init})
      : super(ApiGeneral(
          response: null,
          status: 0,
          message: "",
          loading: false,
        ));

  Future<void> simpanTransaksi(
      {required String voucher,
      required String phone,
      required String customer,
      required String date,
      required List<Map<String, dynamic>> item,
      required double subtotal,
      required double grandTotal}) async {
    try {
      state.loading = true;
      await init
          .simpanTransaksi(
              voucher: voucher,
              customer: customer,
              phone: phone,
              tanggal: date,
              item: item,
              subtotal: subtotal,
              grandTotal: grandTotal)
          .then((value) {
        print(value);
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
