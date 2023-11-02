import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smexpo2023/model/api_model.dart';
import 'package:smexpo2023/provider/api_provider.dart';
import 'package:smexpo2023/repository/api_repository.dart';

final providerApiVoucher = Provider<VoucherRepository>(
    (ref) => VoucherRepository(init: ref.read(providerApi())));

class VoucherRepository {
  ApiRepository init;
  VoucherRepository({required this.init});

  Future<ApiModel> listVoucher(
      {required String start, String search = ""}) async {
    try {
      var res = await init.listVoucher(start: start, search: search);

      return res;
    } on DioException catch (e) {
      return ApiModel.fromJson(e.response?.data);
    }
  }

  Future<ApiModel> historyVoucher(
      {required String start,
      required String from,
      required String until,
      required String search}) async {
    try {
      var res = await init.listHistoryVoucher(
          start: start, search: search, from: from, until: until);
      return res;
    } on DioException catch (e) {
      return ApiModel.fromJson(e.response?.data);
    }
  }

  Future<ApiModel> simpanVoucher(
      {required String id,
      required String phone,
      required String customer,
      required String photo,
      required String date}) async {
    try {
      var res = await init.simpanVoucher(
          idVoucher: id,
          phone: phone,
          customer: customer,
          date: date,
          photo: photo);
      return res;
    } on DioException catch (e) {
      return ApiModel.fromJson(e.response?.data);
    }
  }
}
