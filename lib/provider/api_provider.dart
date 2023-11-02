import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smexpo2023/repository/api_repository.dart';
import 'package:smexpo2023/util/services/api_manager.dart';

Provider<ApiRepository> providerApi({bool isFromdata = false}) {
  String uriApi = dotenv.get("BASE_URL");

  return Provider<ApiRepository>((ref) => ApiRepository(
      apiApp: ApiManager().init(baseUrl: uriApi, usingForm: isFromdata)));
}

Provider<ApiRepository> providerApiMinio() {
  String uriApi = dotenv.get("BASE_URL_MINIO");

  return Provider<ApiRepository>((ref) => ApiRepository(
      apiApp: ApiManager().init(baseUrl: uriApi, usingForm: true)));
}
