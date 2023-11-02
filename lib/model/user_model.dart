class UserModel {
  dynamic id;
  dynamic nama;
  dynamic token;
  dynamic username;
  dynamic flag;

  UserModel(
      {required this.id,
      required this.username,
      required this.token,
      required this.nama,
      required this.flag});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      id: json["id"],
      username: json["username"],
      token: json["token"],
      nama: json["nama"],
      flag: json["flag"]);
}
