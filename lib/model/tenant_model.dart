class TenantModel {
  dynamic id;
  dynamic id_m;
  dynamic id_kategori;
  dynamic kode_qr;
  dynamic username;
  dynamic password;
  dynamic nama_tenant;
  dynamic alamat;
  dynamic latitude;
  dynamic longitude;
  dynamic host_gambar;
  dynamic path_gambar;
  dynamic id_kategori_kupon;
  dynamic insert_at;
  dynamic user_insert;
  dynamic update_at;
  dynamic user_update;
  dynamic status;
  dynamic flag_jual_tiket;
  dynamic flag_parade;

  TenantModel(
      {required this.id,
      required this.id_kategori,
      required this.host_gambar,
      required this.alamat,
      required this.flag_jual_tiket,
      required this.flag_parade,
      required this.id_kategori_kupon,
      required this.id_m,
      required this.insert_at,
      required this.kode_qr,
      required this.latitude,
      required this.longitude,
      required this.nama_tenant,
      required this.password,
      required this.path_gambar,
      required this.status,
      required this.update_at,
      required this.user_insert,
      required this.user_update,
      required this.username});

  factory TenantModel.fromJson(Map<String, dynamic> json) => TenantModel(
      id: json["id"],
      id_kategori: json["id_kategori"],
      host_gambar: json["host_gambar"],
      alamat: json["alamat"],
      flag_jual_tiket: json["flag_jual_tiket"],
      flag_parade: json["flag_parade"],
      id_kategori_kupon: json["id_kategori_kupon"],
      id_m: json["id_m"],
      insert_at: json["insert_at"],
      kode_qr: json["kode_qr"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      nama_tenant: json["nama_tenant"],
      password: json["password"],
      path_gambar: json["path_gambar"],
      status: json["status"],
      update_at: json["update_at"],
      user_insert: json["user_insert"],
      user_update: json["user_update"],
      username: json["username"]);
}
