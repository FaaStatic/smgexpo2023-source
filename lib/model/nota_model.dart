class NotaModel {
  dynamic order_number;
  dynamic tanggal;
  dynamic sub_total;
  dynamic kode_voucher;
  dynamic pot_voucher;
  dynamic grand_total;
  dynamic kupon;
  List<dynamic>? item;

  NotaModel(
      {required this.order_number,
      required this.kode_voucher,
      required this.grand_total,
      required this.item,
      required this.pot_voucher,
      required this.kupon,
      required this.sub_total,
      required this.tanggal});

  factory NotaModel.fromJson(Map<String, dynamic> json) => NotaModel(
      order_number: json["order_number"],
      kode_voucher: json["kode_voucher"],
      grand_total: json["grand_total"],
      item: json["item"],
      pot_voucher: json["pot_voucher"],
      sub_total: json["sub_total"],
      tanggal: json["tanggal"],
      kupon: json["kupon"]);
}
