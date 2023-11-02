import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:sizer/sizer.dart';
import 'package:smexpo2023/component/button_component.dart';
import 'package:smexpo2023/component/gap.dart';
import 'package:smexpo2023/component/loading_proses.dart';
import 'package:smexpo2023/component/modal_konfirm.dart';
import 'package:smexpo2023/main.dart';
import 'package:smexpo2023/model/nota_model.dart';

class Helper {
  static final Helper helper = Helper._internal();

  factory Helper() {
    return helper;
  }

  Helper._internal();

  final List<Map<String, dynamic>> dummyTenant = [
    {
      "id": 10,
      "name": "Ibox",
    },
    {
      "id": 12,
      "name": "Digimap",
    },
    {
      "id": 15,
      "name": "Gucci",
    },
  ];

  final List<Map<String, dynamic>> dummyVocuher = [
    {
      "id": "2733",
      "unique": "FFD5WL",
      "id_m": "459",
      "kategori": "0",
      "nama_voucher": "Wartawan 1",
      "valid_start": "2023-10-30 00:00:00",
      "valid_end": "2023-11-30 00:00:00",
      "flag_nilai": "R",
      "nominal": "50000",
      "uid_user": "",
      "use_at": null,
      "snk": "Wartawan 1",
      "created_at": "2023-10-30 11:28:08",
      "user_create": "nexasmex",
      "updated_at": null,
      "user_update": "",
      "deleted_at": null,
      "user_delete": "",
      "customer": null
    },
    {
      "id": "2736",
      "unique": "F3P2WL",
      "id_m": "459",
      "kategori": "0",
      "nama_voucher": "Wartawan 2",
      "valid_start": "2023-10-30 00:00:00",
      "valid_end": "2023-11-30 00:00:00",
      "flag_nilai": "R",
      "nominal": "50000",
      "uid_user": "",
      "use_at": null,
      "snk": "Wartawan 2",
      "created_at": "2023-10-30 11:28:08",
      "user_create": "nexasmex",
      "updated_at": null,
      "user_update": "",
      "deleted_at": null,
      "user_delete": "",
      "customer": null
    },
    {
      "id": "2739",
      "unique": "F3CRWL",
      "id_m": "459",
      "kategori": "0",
      "nama_voucher": "Wartawan 3",
      "valid_start": "2023-10-30 00:00:00",
      "valid_end": "2023-11-30 00:00:00",
      "flag_nilai": "R",
      "nominal": "50000",
      "uid_user": "",
      "use_at": null,
      "snk": "Wartawan 3",
      "created_at": "2023-10-30 11:28:08",
      "user_create": "nexasmex",
      "updated_at": null,
      "user_update": "",
      "deleted_at": null,
      "user_delete": "",
      "customer": null
    },
    {
      "id": "2742",
      "unique": "F2TVWL",
      "id_m": "459",
      "kategori": "0",
      "nama_voucher": "Wartawan 4",
      "valid_start": "2023-10-30 00:00:00",
      "valid_end": "2023-11-30 00:00:00",
      "flag_nilai": "R",
      "nominal": "50000",
      "uid_user": "",
      "use_at": null,
      "snk": "Wartawan 4",
      "created_at": "2023-10-30 11:28:08",
      "user_create": "nexasmex",
      "updated_at": null,
      "user_update": "",
      "deleted_at": null,
      "user_delete": "",
      "customer": null
    },
    {
      "id": "2745",
      "unique": "FBXMWL",
      "id_m": "459",
      "kategori": "0",
      "nama_voucher": "Wartawan 5",
      "valid_start": "2023-10-30 00:00:00",
      "valid_end": "2023-11-30 00:00:00",
      "flag_nilai": "R",
      "nominal": "50000",
      "uid_user": "",
      "use_at": null,
      "snk": "Wartawan 5",
      "created_at": "2023-10-30 11:28:08",
      "user_create": "nexasmex",
      "updated_at": null,
      "user_update": "",
      "deleted_at": null,
      "user_delete": "",
      "customer": null
    },
    {
      "id": "2748",
      "unique": "FUSYWL",
      "id_m": "459",
      "kategori": "0",
      "nama_voucher": "Wartawan 6",
      "valid_start": "2023-10-30 00:00:00",
      "valid_end": "2023-11-30 00:00:00",
      "flag_nilai": "R",
      "nominal": "50000",
      "uid_user": "",
      "use_at": null,
      "snk": "Wartawan 6",
      "created_at": "2023-10-30 11:28:08",
      "user_create": "nexasmex",
      "updated_at": null,
      "user_update": "",
      "deleted_at": null,
      "user_delete": "",
      "customer": null
    },
  ];

  Future<void> prosessPrintAndroid(
      NotaModel dataLempar, void Function() callback) async {
    var status = await bluetoothPrint.isConnected;
    ByteData data = await rootBundle.load('assets/images/logo_expo_nota.png');
    Uint8List bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    if (status!) {
      bluetoothPrint.printNewLine();
      bluetoothPrint.printImageBytes(bytes);
      bluetoothPrint.printNewLine();
      bluetoothPrint.printCustom("Pertamina SM Expo Semarang", 3, 1);
      bluetoothPrint.printNewLine();
      bluetoothPrint.printNewLine();
      bluetoothPrint.printCustom(dataLempar.order_number, 1, 0);
      bluetoothPrint.printCustom(dataLempar.tanggal, 1, 0);
      bluetoothPrint.printNewLine();
      bluetoothPrint.printCustom("------------------------------", 1, 1);
      bluetoothPrint.printNewLine();
      bluetoothPrint.printCustom("Detail Transaksi", 1, 0);
      bluetoothPrint.printNewLine();
      if (dataLempar.item != null) {
        for (final data in dataLempar.item!) {
          bluetoothPrint.printLeftRight(
              data["nama"],
              Helper()
                  .idrShow(double.parse(data["harga"].toString()))
                  .output
                  .symbolOnLeft,
              0);
        }
      }

      bluetoothPrint.printNewLine();
      bluetoothPrint.printCustom("------------------------------", 1, 1);
      bluetoothPrint.printNewLine();
      bluetoothPrint.printLeftRight(
          "Sub-Total",
          Helper()
              .idrShow(double.parse(dataLempar.sub_total))
              .output
              .symbolOnLeft,
          0);
      bluetoothPrint.printNewLine();
      bluetoothPrint.printLeftRight(
          "Voucher",
          "-${Helper().idrShow(double.parse(dataLempar.pot_voucher.toString())).output.symbolOnLeft}",
          0);
      bluetoothPrint.printNewLine();
      bluetoothPrint.printLeftRight(
          "Grand Total",
          Helper()
              .idrShow(double.parse(dataLempar.grand_total.toString()))
              .output
              .symbolOnLeft,
          0);

      bluetoothPrint.printNewLine();
      if (dataLempar.kupon != null) {
        bluetoothPrint.printCustom("Selamat! Anda mendapatkan", 0, 1);
        bluetoothPrint.printCustom("kesempatan  mengikuti", 0, 1);
        bluetoothPrint.printCustom("LuckyDraw Pertamina SM Expo.", 0, 1);
        bluetoothPrint.printCustom("Nomor Undian : ${dataLempar.kupon}", 0, 1);
      }

      bluetoothPrint.paperCut();
    }
    callback();
  }

  MoneyFormatter idrShow(double value) {
    return MoneyFormatter(
        amount: value,
        settings: MoneyFormatterSettings(
            symbol: 'Rp',
            thousandSeparator: '.',
            decimalSeparator: ',',
            symbolAndNumberSeparator: ' ',
            fractionDigits: 0,
            compactFormatType: CompactFormatType.short));
  }

  void loadingProsesGlobal(
      {required BuildContext context, required String msg}) async {
    showGeneralDialog(
        context: context,
        barrierLabel: "",
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return Align(
            alignment: Alignment.center,
            child: LoadingProses(
              message: msg,
            ),
          );
        });
  }

  void konfirmGlobal(
      {required BuildContext context,
      required String msg,
      required void Function() agree,
      required void Function() denied,
      required String titleAgree}) async {
    showGeneralDialog(
        context: context,
        barrierLabel: "",
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return Align(
            alignment: Alignment.center,
            child: ModalKonfirm(
                aggreCall: agree,
                deniedCall: denied,
                titleAgree: titleAgree,
                message: msg),
          );
        });
  }

  final examplePrintData = {
    "kode_transaksi": "kode",
    "tanggal_transaksi": "kode",
    "list_transaksi": [
      {
        "nama_barang": "Kucing",
        "total_harga": "2000000",
      },
      {
        "nama_barang": "Anjing",
        "total_harga": "2500000",
      },
    ],
    "sub_total": "4500000",
    "voucher": "-100000",
    "grand_total": "3500000",
    "kupon": "MAUDY-EWE"
  };

  final transaksiHistory = [
    {
      "id_transaksi": "bla-bla",
      "no_order": "bla-ble",
      "tanggal_transaksi": DateTime.now(),
      "jumlah_kupon": 5,
      "merchant": "Kucing",
      "telepon": "08121212121",
      "customer": "Kunci"
    },
    {
      "id_transaksi": "bla-bla1",
      "no_order": "bla-ble",
      "tanggal_transaksi": DateTime.now(),
      "jumlah_kupon": 5,
      "merchant": "Kucing1",
      "telepon": "08121212121",
      "customer": "Kunci"
    },
    {
      "id_transaksi": "bla-bla2",
      "no_order": "bla-ble",
      "tanggal_transaksi": DateTime.now(),
      "jumlah_kupon": 5,
      "merchant": "Kucing2",
      "telepon": "08121212121",
      "customer": "Kunci"
    },
    {
      "id_transaksi": "bla-bla3",
      "no_order": "bla-ble",
      "tanggal_transaksi": DateTime.now(),
      "jumlah_kupon": 5,
      "merchant": "Kucing3",
      "telepon": "08121212121",
      "customer": "Kunci"
    },
    {
      "id_transaksi": "bla-bla4",
      "no_order": "bla-ble",
      "tanggal_transaksi": DateTime.now(),
      "jumlah_kupon": 5,
      "merchant": "Kucing4",
      "telepon": "08121212121",
      "customer": "Kunci"
    },
  ];

  void prosessPrintIos(NotaModel dataLempar, void Function() callback) async {
    var status = await bluetoothPrintIos.isConnected;

    ByteData data = await rootBundle.load("assets/images/logo_smexpo2.png");
    List<int> imageBytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    String base64Image = base64Encode(imageBytes);
    if (status!) {
      Map<String, dynamic> config = Map();
      List<LineText> list = <LineText>[];

      list.add(LineText(
          type: LineText.TYPE_IMAGE,
          content: base64Image,
          width: 150,
          height: 150,
          align: LineText.ALIGN_CENTER,
          linefeed: 1));

      list.add(LineText(linefeed: 2));

      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: 'Pertamina SM Expo Semarang',
          weight: 700,
          size: 14,
          align: LineText.ALIGN_CENTER,
          linefeed: 1));

      list.add(LineText(linefeed: 2));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: dataLempar.order_number,
          align: LineText.ALIGN_LEFT,
          linefeed: 1));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: dataLempar.tanggal,
          align: LineText.ALIGN_LEFT,
          linefeed: 1));

      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: '------------------------------',
          align: LineText.ALIGN_CENTER,
          linefeed: 1));
      list.add(LineText(linefeed: 1));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: 'Detail Transaksi',
          size: 10,
          align: LineText.ALIGN_LEFT,
          linefeed: 1));
      list.add(LineText(linefeed: 1));
      if (dataLempar.item != null) {
        if (dataLempar.item!.isNotEmpty) {
          for (final data in dataLempar.item!) {
            list.add(LineText(
                type: LineText.TYPE_TEXT,
                content: data["nama"],
                size: 10,
                align: LineText.ALIGN_LEFT,
                linefeed: 0));
            list.add(LineText(
                type: LineText.TYPE_TEXT,
                content: data["harga"].toString(),
                size: 10,
                align: LineText.ALIGN_RIGHT,
                linefeed: 1));
          }
        }
      }

      list.add(LineText(linefeed: 1));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: '------------------------------',
          align: LineText.ALIGN_CENTER,
          linefeed: 1));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: 'Sub-total',
          align: LineText.ALIGN_CENTER,
          linefeed: 0));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: dataLempar.sub_total.toString(),
          align: LineText.ALIGN_RIGHT,
          linefeed: 1));

      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: 'Voucher',
          align: LineText.ALIGN_CENTER,
          linefeed: 0));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: dataLempar.pot_voucher.toString(),
          align: LineText.ALIGN_RIGHT,
          linefeed: 1));

      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: 'Grand Total',
          align: LineText.ALIGN_CENTER,
          linefeed: 0));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: dataLempar.grand_total.toString(),
          align: LineText.ALIGN_RIGHT,
          linefeed: 1));

      list.add(LineText(linefeed: 2));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content:
              "Selamat! Anda mendapatkan kesempatan mengikuti LuckyDraw Pertamina SM Expo: ${dataLempar.kupon}",
          align: LineText.ALIGN_LEFT,
          linefeed: 1));
      await bluetoothPrintIos.printReceipt(config, list).whenComplete(() {
        callback();
      });
    }
  }

  void showDate(BuildContext context, DateTime initdate,
      void Function(DateTime? value) callback) {
    if (Platform.isIOS) {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useRootNavigator: true,
          backgroundColor: Colors.transparent,
          builder: ((context) => Container(
                height: 35.h,
                padding: const EdgeInsets.all(25),
                constraints: BoxConstraints(minHeight: 30.h, maxHeight: 45.h),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        child: Text(
                          "Pilih Waktu Transaksi",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              decorationThickness: 0,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp),
                        ),
                      ),
                      const Gap(
                        height: 16,
                      ),
                      SizedBox(
                        height: 15.h,
                        child: CupertinoDatePicker(
                          onDateTimeChanged: callback,
                          dateOrder: DatePickerDateOrder.dmy,
                          initialDateTime: initdate,
                          minimumDate: DateTime(1945),
                          maximumDate: DateTime(2099),
                          mode: CupertinoDatePickerMode.date,
                        ),
                      ),
                      ButtonComponent(
                        title: "Save",
                        fontSize: 12.sp,
                        textColor: Colors.white,
                        bgColor: Theme.of(context).colorScheme.primary,
                        callback: () {
                          context.pop();
                        },
                      )
                    ],
                  ),
                ),
              )));
    } else {
      showDatePicker(
          context: context,
          initialDate: initdate,
          fieldLabelText: "Pilih Waktu Transaksi",
          firstDate: DateTime(1990),
          lastDate: DateTime(2050),
          builder: (context, picker) {
            return Theme(
              data: ThemeData.dark().copyWith(
                useMaterial3: false,
                colorScheme: ColorScheme.light(
                  primary: Theme.of(context).colorScheme.primary,
                ),
                dialogBackgroundColor: HexColor("#F0F1F2"),
              ),
              child: picker!,
            );
          }).then((value) {
        callback(value);
      });
    }
  }
}
