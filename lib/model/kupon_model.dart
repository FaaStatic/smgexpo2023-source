class KuponModel {
  dynamic id;
  dynamic unique;
  dynamic id_m;
  dynamic kategori;
  dynamic nama_voucher;
  dynamic valid_start;
  dynamic valid_end;
  dynamic flag_nilai;
  dynamic nominal;
  dynamic uid_user;
  dynamic use_at;
  dynamic snk;
  dynamic created_at;
  dynamic user_create;
  dynamic updated_at;
  dynamic user_update;
  dynamic deleted_at;
  dynamic user_delete;
  dynamic customer;

  KuponModel(
      {required this.id,
      required this.customer,
      required this.created_at,
      required this.deleted_at,
      required this.flag_nilai,
      required this.id_m,
      required this.kategori,
      required this.nama_voucher,
      required this.nominal,
      required this.snk,
      required this.uid_user,
      required this.unique,
      required this.updated_at,
      required this.use_at,
      required this.user_create,
      required this.user_delete,
      required this.user_update,
      required this.valid_end,
      required this.valid_start});

  factory KuponModel.fromJson(Map<String, dynamic> json) => KuponModel(
      id: json["id"],
      customer: json["customer"],
      created_at: json["created_at"],
      deleted_at: json["deleted_at"],
      flag_nilai: json["flag_nilai"],
      id_m: json["id_m"],
      kategori: json["kategori"],
      nama_voucher: json["nama_voucher"],
      nominal: json["nominal"],
      snk: json["snk"],
      uid_user: json["uid_user"],
      unique: json["unique"],
      updated_at: json["updated_at"],
      use_at: json["use_at"],
      user_create: json["user_create"],
      user_delete: json["user_delete"],
      user_update: json["user_update"],
      valid_end: json["valid_end"],
      valid_start: json["valid_start"]);
}
