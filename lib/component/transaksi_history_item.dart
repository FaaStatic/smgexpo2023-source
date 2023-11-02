import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:smexpo2023/component/gap.dart';
import 'package:smexpo2023/model/riwayat_transaksi_model.dart';
import 'package:smexpo2023/util/helper.dart';

class TransaksiHistoryItem extends StatelessWidget {
  final RiwayatTransaksiModel model;
  final void Function() callback;
  const TransaksiHistoryItem(
      {super.key, required this.model, required this.callback});

  DateTime convert(String date) => DateTime.parse(date);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4, right: 4, top: 24),
      child: InkWell(
        onTap: callback,
        child: Container(
          width: 100.w,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 1),
                    spreadRadius: 2,
                    blurRadius: 2),
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 40.w,
                  child: Text(
                    DateFormat("dd MMMM yyyy")
                        .format(convert(model.tanggal_transaksi)),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
              const Gap(
                height: 8,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 40.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Pembeli",
                          textAlign: TextAlign.left,
                          style:
                              TextStyle(fontSize: 12.sp, color: Colors.black),
                        ),
                        const Gap(
                          height: 8,
                        ),
                        Text(
                          model.customer,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 40.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Jumlah E-Kupon",
                          textAlign: TextAlign.left,
                          style:
                              TextStyle(fontSize: 12.sp, color: Colors.black),
                        ),
                        const Gap(
                          height: 8,
                        ),
                        Text(
                          model.jumlahKupon.toString(),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(
                height: 8,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 40.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Telepon",
                          textAlign: TextAlign.left,
                          style:
                              TextStyle(fontSize: 12.sp, color: Colors.black),
                        ),
                        const Gap(
                          height: 8,
                        ),
                        Text(
                          model.numberPhone.toString(),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 40.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Pengirim",
                          textAlign: TextAlign.left,
                          style:
                              TextStyle(fontSize: 12.sp, color: Colors.black),
                        ),
                        const Gap(
                          height: 8,
                        ),
                        Text(
                          model.merchant,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(
                height: 8,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 40.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Waktu Transaksi",
                          textAlign: TextAlign.left,
                          style:
                              TextStyle(fontSize: 12.sp, color: Colors.black),
                        ),
                        const Gap(
                          height: 8,
                        ),
                        Text(
                          DateFormat("HH:mm:ss")
                              .format(convert(model.tanggal_transaksi)),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 40.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Total",
                          textAlign: TextAlign.left,
                          style:
                              TextStyle(fontSize: 12.sp, color: Colors.black),
                        ),
                        const Gap(
                          height: 8,
                        ),
                        Text(
                          Helper()
                              .idrShow(double.parse(model.total.toString()))
                              .output
                              .symbolOnLeft,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(
                height: 8,
              ),
              SizedBox(
                width: 100.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Tap untuk Mencetak",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 8.sp, color: Colors.black),
                    ),
                  ],
                ),
              ),
              const Gap(
                height: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
