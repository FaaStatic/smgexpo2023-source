import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smexpo2023/model/statemodel/api_list.dart';
import 'package:smexpo2023/repository/transaksi/transaksi_repository.dart';

final providerMerchantTransaksi =
    StateNotifierProvider<ListMerchantProvider, ApiList>(
        (ref) => ListMerchantProvider(init: ref.watch(providerApiTransaksi)));

class ListMerchantProvider extends StateNotifier<ApiList> {
  final TransaksiRepository init;
  ListMerchantProvider({required this.init})
      : super(ApiList(
            response: [],
            status: 0,
            message: "",
            loading: false,
            hasNextPage: true));

  Future<void> getListMerchant() async {
    try {
      state.loading = true;
      await init.getMerchant().then((value) {
        print(value.response["Tenant"]);
        var responseData = value.response["Tenant"] as List<dynamic> ?? [];
        if (value.status == 200) {
          if (responseData.length == 10) {
            state = state.copyWith(
                responseData, value.status, value.message, false, true);
          } else if (responseData.isNotEmpty && responseData.length < 10) {
            state = state.copyWith(
                responseData, value.status, value.message, false, false);
          } else {
            state = state.copyWith(
                responseData, value.status, value.message, false, false);
          }
        } else {
          state = state.copyWith([], value.status, value.message, false, false);
        }
      });
    } on DioException catch (e) {
      state.copyWith(
          [], e.response?.statusCode, e.response?.statusMessage, false, false);
    }
  }
}
