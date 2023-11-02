import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smexpo2023/model/statemodel/api_general.dart';
import 'package:smexpo2023/repository/voucher/voucher_repository.dart';

final providerSimpanVoucher = StateNotifierProvider<SimpanVoucher, ApiGeneral>(
    (ref) => SimpanVoucher(init: ref.watch(providerApiVoucher)));

class SimpanVoucher extends StateNotifier<ApiGeneral> {
  final VoucherRepository init;
  SimpanVoucher({required this.init})
      : super(ApiGeneral(
          response: null,
          status: 0,
          message: "",
          loading: false,
        ));

  Future<void> simpanVoucher(
      {required String id,
      required String phone,
      required String customer,
      required String date,
      required String photo}) async {
    try {
      state.loading = true;
      await init
          .simpanVoucher(
              id: id,
              phone: phone,
              customer: customer,
              date: date,
              photo: photo)
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
