class ApiModel {
  dynamic response;
  dynamic status;
  dynamic message;

  ApiModel(
      {required this.response, required this.status, required this.message});

  factory ApiModel.fromJson(Map<String, dynamic> json) => ApiModel(
      response: json["response"],
      status: json["metadata"]["status"],
      message: json["metadata"]["message"]);
}
