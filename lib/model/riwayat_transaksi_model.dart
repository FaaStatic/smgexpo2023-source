class RiwayatTransaksiModel {
  dynamic id_transaksi;
  dynamic nomor_order;
  dynamic customer;
  dynamic numberPhone;
  dynamic jumlahKupon;
  dynamic merchant;
  dynamic tanggal_transaksi;
  dynamic total;

  RiwayatTransaksiModel(
      {required this.id_transaksi,
      required this.nomor_order,
      required this.customer,
      required this.jumlahKupon,
      required this.merchant,
      required this.numberPhone,
      required this.tanggal_transaksi,
      required this.total});

  factory RiwayatTransaksiModel.fromJson(Map<String, dynamic> json) =>
      RiwayatTransaksiModel(
          id_transaksi: json["id_transaksi"],
          nomor_order: json["no_order"],
          customer: json["customer"],
          jumlahKupon: json["jumlah_kupon"],
          merchant: json["merchant"],
          numberPhone: json["telepon"],
          tanggal_transaksi: json["tanggal_transaksi"],
          total: json["total"]);
}
