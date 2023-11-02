class ApiList {
  List<dynamic> response;
  dynamic status;
  dynamic message;
  bool loading;
  bool hasNextPage;

  ApiList(
      {required this.response,
      required this.status,
      required this.message,
      required this.hasNextPage,
      required this.loading});

  ApiList copyWith(dynamic response2, dynamic status2, dynamic message2,
      bool loading2, bool hasNextPage2) {
    return ApiList(
        response: response2,
        status: status2,
        message: message2,
        hasNextPage: hasNextPage2,
        loading: loading2);
  }
}
