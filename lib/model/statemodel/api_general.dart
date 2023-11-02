class ApiGeneral {
  dynamic response;
  dynamic status;
  dynamic message;
  bool loading;

  ApiGeneral(
      {required this.response,
      required this.status,
      required this.message,
      required this.loading});

  ApiGeneral copyWith(
      dynamic response2, dynamic status2, dynamic message2, bool loading2) {
    return ApiGeneral(
        response: response2,
        status: status2,
        message: message2,
        loading: loading2);
  }
}
