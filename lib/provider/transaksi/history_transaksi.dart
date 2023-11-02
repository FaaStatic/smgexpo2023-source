import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smexpo2023/model/statemodel/api_list.dart';
import 'package:smexpo2023/repository/transaksi/transaksi_repository.dart';

final providerHistoryTransaksi =
    StateNotifierProvider<HistoryTransaksi, ApiList>(
        (ref) => HistoryTransaksi(init: ref.watch(providerApiTransaksi)));

class HistoryTransaksi extends StateNotifier<ApiList> {
  final TransaksiRepository init;
  HistoryTransaksi({required this.init})
      : super(ApiList(
            response: [],
            status: 0,
            message: "",
            loading: false,
            hasNextPage: true));

  Future<void> getListHistory(
      {required String from,
      required String start,
      required String until,
      required String search}) async {
    try {
      state.loading = true;
      await init
          .historyTransaksi(
              start: start, from: from, until: until, search: search)
          .then((value) {
        var responseData = value.response ?? [];
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
      {required String from,
      required String start,
      required String until,
      required String search}) async {
    try {
      state.loading = true;
      await init
          .historyTransaksi(
              start: start, from: from, until: until, search: search)
          .then((value) {
        var responseData = value.response ?? [];
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
