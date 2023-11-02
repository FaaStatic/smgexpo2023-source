import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smexpo2023/model/statemodel/api_list.dart';
import 'package:smexpo2023/repository/voucher/voucher_repository.dart';

final providerHistoryVoucher =
    StateNotifierProvider<ListHistoryVoucher, ApiList>(
        (ref) => ListHistoryVoucher(init: ref.watch(providerApiVoucher)));

class ListHistoryVoucher extends StateNotifier<ApiList> {
  final VoucherRepository init;
  ListHistoryVoucher({required this.init})
      : super(ApiList(
            response: [],
            status: 0,
            message: "",
            loading: false,
            hasNextPage: true));

  Future<void> getListHistory(
      {required String start,
      required String from,
      required String until,
      required String search}) async {
    try {
      state.loading = true;
      await init
          .historyVoucher(
              start: start, search: search, from: from, until: until)
          .then((value) {
        var responseData = value.response["vouchers"] ?? [];
        print(responseData);
        if (value.status == 200) {
          if (responseData.length == 10) {
            state = state.copyWith(
                responseData, value.status, value.message, false, true);
          } else if (responseData.length > 0 && responseData.length < 0) {
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

  Future<void> getMoreHistory(
      {required String start,
      required String from,
      required String until,
      required String search}) async {
    try {
      state.loading = true;
      await init
          .historyVoucher(
              start: start, search: search, from: from, until: until)
          .then((value) {
        var responseData = value.response["vouchers"] ?? [];
        var oldData = state.response;
        if (value.status == 200) {
          if (responseData.length == 10) {
            state = state.copyWith([...oldData, ...responseData], value.status,
                value.message, false, true);
          } else if (responseData.length > 0 && responseData.length < 10) {
            state = state.copyWith([...oldData, ...responseData], value.status,
                value.message, false, false);
          } else {
            state = state.copyWith(
                oldData, value.status, value.message, false, false);
          }
        } else {
          state =
              state.copyWith(oldData, value.status, value.message, false, true);
        }
      });
    } on DioException catch (e) {
      state.copyWith(
          [], e.response?.statusCode, e.response?.statusMessage, false, false);
    }
  }
}
