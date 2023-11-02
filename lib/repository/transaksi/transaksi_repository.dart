import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smexpo2023/model/api_model.dart';
import 'package:smexpo2023/provider/api_provider.dart';
import 'package:smexpo2023/repository/api_repository.dart';

final providerApiTransaksi = Provider<TransaksiRepository>(
    (ref) => TransaksiRepository(init: ref.read(providerApi())));

class TransaksiRepository {
  ApiRepository init;
  TransaksiRepository({required this.init});

  Future<ApiModel> historyTransaksi(
      {required String start,
      required String from,
      required String until,
      required String search}) async {
    try {
      var res = await init.historyTransaksi(
          start: start, from: from, until: until, search: search);
      return res;
    } on DioException catch (e) {
      return ApiModel.fromJson(e.response?.data);
    }
  }

  Future<ApiModel> validasiVoucher(
      {required String voucher,
      required String phone,
      required String customer,
      required List<Map<String, dynamic>> item,
      required String date}) async {
    try {
      var res = await init.validasiVoucher(
          voucher: voucher,
          customer: customer,
          phone: phone,
          tanggal: date,
          item: item);
      return res;
    } on DioException catch (e) {
      return ApiModel.fromJson(e.response?.data);
    }
  }

  Future<ApiModel> simpanTransaksi(
      {required String voucher,
      required String customer,
      required String phone,
      required String tanggal,
      required List<Map<String, dynamic>> item,
      required double subtotal,
      required double grandTotal}) async {
    try {
      var res = await init.saveTransaksi(
          voucher: voucher,
          customer: customer,
          phone: phone,
          tanggal: tanggal,
          item: item,
          subtotal: subtotal,
          grandTotal: grandTotal);
      return res;
    } on DioException catch (e) {
      return ApiModel.fromJson(e.response?.data);
    }
  }

  Future<ApiModel> getPrint({required String noOrder}) async {
    try {
      var res = await init.notaPrint(noOrder: noOrder);
      return res;
    } on DioException catch (e) {
      return ApiModel.fromJson(e.response?.data);
    }
  }

  Future<ApiModel> getMerchant() async {
    try {
      var res = await init.listMerchant();
      return res;
    } on DioException catch (e) {
      return ApiModel.fromJson(e.response?.data);
    }
  }
}
