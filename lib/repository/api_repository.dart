import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smexpo2023/model/api_model.dart';

class ApiRepository {
  final Dio apiApp;

  ApiRepository({required this.apiApp});

  Future<ApiModel> loginAuth(
      {required String user, required String pass}) async {
    try {
      String path = dotenv.get("LOGIN");
      var data = {"username": user, "password": pass};
      var response = await apiApp.post(path, data: data);

      return ApiModel.fromJson(response.data);
    } on DioException catch (e) {
      return ApiModel.fromJson(e.response?.data);
    }
  }

  Future<ApiModel> historyTransaksi({
    required String start,
    required String from,
    required String until,
    required String search,
  }) async {
    try {
      String path = dotenv.get("LIST_TRANSAKSI_HISTORY");

      var data = {
        "start": start,
        "limit": 10,
        "dari": from,
        "sampai": until,
        "nominal": search
      };
      var response = await apiApp.post(path, data: data);
      return ApiModel.fromJson(response.data);
    } on DioException catch (e) {
      return ApiModel.fromJson(e.response?.data);
    }
  }

  Future<ApiModel> uploadFile(FormData fileUpload) async {
    try {
      String path = dotenv.get("URL_MINIO");
      var response = await apiApp.post(path, data: fileUpload);
      return ApiModel.fromJson(response.data);
    } on DioException catch (e) {
      return ApiModel.fromJson(e.response?.data);
    }
  }

  Future<ApiModel> listVoucher(
      {required String start, required String search}) async {
    try {
      String path = dotenv.get("LIST_VOCUHER");
      var data = {"start": start, "limit": "10", "nominal": search};
      var response = await apiApp.post(path, data: data);

      return ApiModel.fromJson(response.data);
    } on DioException catch (e) {
      return ApiModel.fromJson(e.response?.data);
    }
  }

  Future<ApiModel> listHistoryVoucher({
    required String start,
    required String from,
    required String until,
    required String search,
  }) async {
    try {
      String path = dotenv.get("LIST_VOCUHER_HISTORY");
      var data = {
        "nominal": search,
        "start": start,
        "limit": 10,
        "dari": from,
        "sampai": until,
      };
      var response = await apiApp.post(path, data: data);
      return ApiModel.fromJson(response.data);
    } on DioException catch (e) {
      return ApiModel.fromJson(e.response?.data);
    }
  }

  Future<ApiModel> simpanVoucher(
      {required String idVoucher,
      required String phone,
      required String customer,
      required String photo,
      required String date}) async {
    try {
      String path = dotenv.get("SIMPAN_VOUCHER");
      var data = {
        "id_voucher": idVoucher,
        "phone": phone,
        "customer": customer,
        "date": date,
        "foto": photo
      };
      var response = await apiApp.post(path, data: data);
      return ApiModel.fromJson(response.data);
    } on DioException catch (e) {
      return ApiModel.fromJson(e.response?.data);
    }
  }

  Future<ApiModel> saveTransaksi(
      {required String voucher,
      required String customer,
      required String phone,
      required String tanggal,
      required List<Map<String, dynamic>> item,
      required double subtotal,
      required double grandTotal}) async {
    try {
      String path = dotenv.get("SAVE_TRANSAKSI");
      var data = {
        "voucher": voucher,
        "customer": customer,
        "phone": phone,
        "tanggal": tanggal,
        "item": item,
        "grandtotal": grandTotal,
        "subtotal": subtotal
      };
      var response = await apiApp.post(path, data: data);
      return ApiModel.fromJson(response.data);
    } on DioException catch (e) {
      return ApiModel.fromJson(e.response?.data);
    }
  }

  Future<ApiModel> validasiVoucher({
    required String voucher,
    required String customer,
    required String phone,
    required String tanggal,
    required List<Map<String, dynamic>> item,
  }) async {
    try {
      String path = dotenv.get("VALIDASI_TRANSAKSI");
      var data = {
        "voucher": voucher,
        "customer": customer,
        "phone": phone,
        "tanggal": tanggal,
        "item": item,
      };
      var response = await apiApp.post(path, data: data);
      return ApiModel.fromJson(response.data);
    } on DioException catch (e) {
      return ApiModel.fromJson(e.response?.data);
    }
  }

  Future<ApiModel> notaPrint({
    required String noOrder,
  }) async {
    try {
      String path = dotenv.get("GET_PRINT_NOTA");
      var data = {"no_order": noOrder};
      var response = await apiApp.post(path, data: data);
      return ApiModel.fromJson(response.data);
    } on DioException catch (e) {
      return ApiModel.fromJson(e.response?.data);
    }
  }

  Future<ApiModel> listMerchant() async {
    try {
      String path = dotenv.get("LIST_TENANT");

      var response = await apiApp.get(path);
      return ApiModel.fromJson(response.data);
    } on DioException catch (e) {
      return ApiModel.fromJson(e.response?.data);
    }
  }
}
