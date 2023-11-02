import 'dart:io';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart' as BluIosModel;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:smexpo2023/component/button_component.dart';
import 'package:smexpo2023/component/gap.dart';
import 'package:smexpo2023/component/input_field.dart';
import 'package:smexpo2023/component/loading_proses.dart';
import 'package:smexpo2023/main.dart';
import 'package:smexpo2023/model/nota_model.dart';
import 'package:smexpo2023/model/tenant_model.dart';
import 'package:smexpo2023/provider/transaksi/list_merchant_provider.dart';
import 'package:smexpo2023/provider/transaksi/nota_print.dart';
import 'package:smexpo2023/provider/transaksi/simpan_transaksi.dart';
import 'package:smexpo2023/provider/transaksi/validasi_voucher.dart';
import 'package:smexpo2023/util/helper.dart';
import 'package:smexpo2023/util/message_util.dart';
import 'package:smexpo2023/util/storage_util.dart';

class InputTransaksiScreen extends ConsumerStatefulWidget {
  final String kodeKey;
  final bool fromHistory;
  const InputTransaksiScreen(
      {super.key, this.kodeKey = "", this.fromHistory = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InputTransaksiScreenState();
}

class _InputTransaksiScreenState extends ConsumerState<InputTransaksiScreen>
    with TickerProviderStateMixin {
  List<BluetoothDevice> deviceList = [];
  BluetoothDevice? selectedDevices;
  List<BluIosModel.BluetoothDevice> deviceListIos = [];
  BluIosModel.BluetoothDevice? selectedDevicesIos;

  final TextEditingController userControl = TextEditingController();
  final TextEditingController phoneControler = TextEditingController();
  final TextEditingController nameBarangControl = TextEditingController();
  final TextEditingController nominalControl = TextEditingController();
  final TextEditingController voucherControl = TextEditingController();
  final String hintTime = "Pilih Waktu Transaksi";
  final String hintCustomer = "Nama Customer";
  final String hintPhone = "Nomor HP Customer";
  final String hintTenant = "Pilih Tenant";
  final DateTime timeNow = DateTime.now();

  String waktuTransaksi = "";
  String labelTime = "";
  String idTenant = "";
  String nameTenant = "Pilih Tenant";
  String nameUser = "";
  String phone = "";
  String nameBarang = "";
  String order_number = "";
  String nominal = "";
  String voucher = "";
  double discount = 0;
  List<TenantModel>? dataList = [];
  String idMerchant = "";
  String undian = "";
  double totalSub = 0;
  double grandSub = 0;
  bool isSave = false;
  List<Map<String, dynamic>> detailTemp = [];
  bool cetakProses = false;

  void getDevices() async {
    try {
      setState(() {
        waktuTransaksi = DateFormat("yyyy-mm-dd").format(timeNow);
        labelTime = DateFormat("dd, MMMM yyyy").format(timeNow);
      });

      Helper()
          .loadingProsesGlobal(context: context, msg: "Memindai Bluetooth...");
      if (Platform.isIOS) {
        await bluetoothPrintIos
            .startScan(timeout: const Duration(seconds: 5))
            .then((value) {
          bluetoothPrintIos.scanResults.listen((event) {
            deviceListIos = event;
          });

          context.pop();
        });
      } else {
        await bluetoothPrint.getBondedDevices().then((value) {
          setState(() {
            deviceList = value;
          });
          connectLastPrinter();
          context.pop();
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void changeName() {
    setState(() {
      nameUser = userControl.text;
    });
  }

  void changeVoucher() {
    setState(() {
      voucher = voucherControl.text;
    });
  }

  void changeNominal() {
    setState(() {
      nominal = nominalControl.text;
    });
  }

  void changePhone() {
    setState(() {
      phone = phoneControler.text;
    });
  }

  void getListMerchant() async {
    try {
      await ref
          .read(providerMerchantTransaksi.notifier)
          .getListMerchant()
          .whenComplete(() {
        var status = ref.watch(providerMerchantTransaksi).status;
        var response = ref.watch(providerMerchantTransaksi).response;
        var msg = ref.watch(providerMerchantTransaksi).message;
        if (status == 200) {
          print(msg);
          if (response.isNotEmpty) {
            for (final element in response) {
              print(element);
              dataList?.add(TenantModel.fromJson(element));
            }
          }
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void tambahDetail() {
    var data = {
      "id": idTenant,
      "nama": nameTenant,
      "harga": nominal,
    };
    print(data);
    setState(() {
      detailTemp.add(data);
      grandSub += double.parse(nominal);
      totalSub += double.parse(nominal);
    });

    setState(() {
      nominal = "";
      nameTenant = "Pilih Tenant";
      nominalControl.clear();
      idTenant = "";
    });
    context.pop();
  }

  @override
  void initState() {
    userControl.addListener(changeName);
    phoneControler.addListener(changePhone);
    nominalControl.addListener(changeNominal);
    voucherControl.addListener(changeVoucher);

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        getDevices();
        getListMerchant();
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    userControl.removeListener(changeName);
    phoneControler.removeListener(changePhone);
    nominalControl.removeListener(changeNominal);
    voucherControl.removeListener(changeVoucher);
    userControl.dispose();
    phoneControler.dispose();
    nameBarangControl.dispose();
    nominalControl.dispose();
    voucherControl.dispose();
    super.dispose();
  }

  void openPrint() async {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        isDismissible: false,
        enableDrag: false,
        useSafeArea: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            if (cetakProses) {
              return Container(
                  height: 40.h,
                  width: 100.w,
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [LoadingProses(message: "Sedang Mencetak")],
                  ));
            } else {
              return pilihPrint();
            }
          });
        });
  }

  void printNota() async {
    try {
      await ref
          .read(providerNotaTransaksi.notifier)
          .getNotaTransaksi(noOrder: order_number)
          .whenComplete(() {
        var status = ref.watch(providerNotaTransaksi).status;
        var msg = ref.watch(providerNotaTransaksi).message;
        var response = ref.watch(providerNotaTransaksi).response;
        print(msg);
        if (status == 200) {
          NotaModel data = NotaModel.fromJson(response);

          if (Platform.isAndroid) {
            Helper().prosessPrintAndroid(data, () {
              setState(() {
                cetakProses = false;
              });
            });
          } else {
            Helper().prosessPrintIos(data, () {
              setState(() {
                cetakProses = false;
              });
            });
          }
        } else {
          setState(() {
            cetakProses = false;
          });
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Widget pilihPrint() {
    if (Platform.isAndroid) {
      if (selectedDevices != null) {
        bluetoothPrint.connect(selectedDevices!).then((value) {
          setState(() {
            selectedDevices = selectedDevices!;
          });
          print(value);
        }).onError((error, stackTrace) {
          print(error.toString());
        });
      }
    } else {
      if (selectedDevices != null) {
        bluetoothPrintIos.connect(selectedDevicesIos!).then((value) {
          setState(() {
            selectedDevicesIos = selectedDevicesIos;
          });
          print(value);
        }).onError((error, stackTrace) {
          print(error.toString());
        });
      }
    }

    return Container(
      height: 40.h,
      width: 100.w,
      padding: const EdgeInsets.only(left: 24, right: 24),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gap(
            height: 5.h,
          ),
          Text(
            "Pilih Printer",
            style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black,
                fontWeight: FontWeight.w700),
          ),
          const Gap(
            height: 16,
          ),
          Builder(builder: (context) {
            if (deviceList.isNotEmpty) {
              return Container(
                  width: 100.w,
                  height: 55,
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 0.5),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: StatefulBuilder(builder: (context, setState) {
                    return DropdownButton<BluetoothDevice>(
                      items: deviceList.map((item) {
                        return DropdownMenuItem<BluetoothDevice>(
                            value: item,
                            child: Text(
                              item.name!,
                              style: TextStyle(
                                  fontSize: 12.sp, color: Colors.black),
                            ));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedDevices = value!;
                        });
                        connectPrinter(value!);
                      },
                      underline: const SizedBox(height: 0),
                      hint: const Text("Pilih Printer Thermal"),
                      value: selectedDevices,
                      isExpanded: true,
                    );
                  }));
            } else if (deviceListIos.isNotEmpty) {
              return Container(
                  width: 100.w,
                  height: 55,
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 0.5),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: StatefulBuilder(builder: (context, setState) {
                    return DropdownButton<BluIosModel.BluetoothDevice>(
                      items: deviceListIos.map((item) {
                        return DropdownMenuItem<BluIosModel.BluetoothDevice>(
                            value: item,
                            child: Text(
                              item.name!,
                              style: TextStyle(
                                  fontSize: 12.sp, color: Colors.black),
                            ));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedDevicesIos = value!;
                        });
                        connectPrinterIos(value!);
                      },
                      underline: const SizedBox(height: 0),
                      hint: const Text("Pilih Printer Thermal"),
                      value: selectedDevicesIos,
                      isExpanded: true,
                    );
                  }));
            } else {
              return Text(
                "Printer Tidak Tersedia",
                style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w700),
              );
            }
          }),
          const Gap(
            height: 16,
          ),
          ButtonComponent(
              title: "Cetak",
              fontSize: 12.sp,
              bgColor: Theme.of(context).colorScheme.primary,
              textColor: Colors.white,
              callback: () {
                setState(() {
                  cetakProses = true;
                });
                printNota();
              }),
          const Gap(
            height: 16,
          ),
          ButtonComponent(
              title: "Keluar",
              fontSize: 12.sp,
              bgColor: Theme.of(context).colorScheme.primary,
              textColor: Colors.white,
              callback: () {
                closeMenu();
              }),
        ],
      ),
    );
  }

  void validasiVoucher() async {
    try {
      Helper().loadingProsesGlobal(context: context, msg: "Validasi ...");
      await ref
          .read(providerValidasiVoucher.notifier)
          .validasiVoucher(
              voucher: voucher,
              phone: phone,
              customer: nameUser,
              date: waktuTransaksi,
              item: detailTemp)
          .whenComplete(() {
        var status = ref.watch(providerValidasiVoucher).status;
        var msg = ref.watch(providerValidasiVoucher).message;
        var response = ref.watch(providerValidasiVoucher).response;
        if (status == 200) {
          print(response);
          if (response["voucher"] != null) {
            setState(() {
              discount = double.parse(response["voucher"].toString());
              grandSub -= discount;
            });
            context.pop();
          }
          print(msg);
          Future.delayed(const Duration(milliseconds: 1000), () {
            MessageUtil().succesMessage(msg, 100);
          });
        } else {
          print(msg);
          context.pop();
          Future.delayed(const Duration(milliseconds: 1000), () {
            MessageUtil().dangerMessage(msg, 100);
          });
        }
      });
    } catch (e) {
      print(e.toString());
      context.pop();
      Future.delayed(const Duration(milliseconds: 1000), () {
        MessageUtil().dangerMessage(e.toString(), 100);
      });
    }
  }

  void simpanTransaksi() async {
    Helper().loadingProsesGlobal(context: context, msg: "Meyimpan ...");

    try {
      var fixedPhone = "";
      if (phone.startsWith("0") || phone.startsWith("62")) {
        fixedPhone = phone;
      } else {
        fixedPhone = "0" + phone;
      }
      await ref
          .read(providerSimpanTransaksi.notifier)
          .simpanTransaksi(
              voucher: voucher,
              phone: fixedPhone,
              customer: nameUser,
              date: waktuTransaksi,
              item: detailTemp,
              subtotal: totalSub,
              grandTotal: grandSub)
          .whenComplete(() {
        var status = ref.watch(providerSimpanTransaksi).status;
        var message = ref.watch(providerSimpanTransaksi).message;
        var response = ref.watch(providerSimpanTransaksi).response;
        print(response);
        if (status == 200) {
          print(status);
          print(response);
          print(message);
          setState(() {
            isSave = true;
            order_number = response["no_order"];
          });

          context.pop();

          Future.delayed(const Duration(milliseconds: 1000), () {
            MessageUtil().succesMessage(message, 100);
          });
        } else {
          context.pop();
          Future.delayed(const Duration(milliseconds: 1000), () {
            MessageUtil().dangerMessage(message, 100);
          });
          print(message);
        }
      });
    } catch (e) {
      context.pop();
      Future.delayed(const Duration(milliseconds: 1000), () {
        MessageUtil().dangerMessage(e.toString(), 100);
      });
      print(e.toString());
    }
  }

  void connectLastPrinter() async {
    if (Platform.isIOS) {
      var path = dotenv.get("LAST_PRINTER_CONNECT");
      await StorageUtil.getAsString(path).then((value) {
        if (value == null) {
        } else {
          for (final element in deviceListIos) {
            if (element.address == value) {
              setState(() {
                selectedDevicesIos = element;
              });
            } else {
              print("choose your print");
            }
          }
        }
      });
    } else {
      var path = dotenv.get("LAST_PRINTER_CONNECT");
      await StorageUtil.getAsString(path).then((value) {
        if (value == null) {
        } else {
          for (final element in deviceList) {
            if (element.address == value) {
              setState(() {
                selectedDevices = element;
              });
            } else {
              print("choose your print");
            }
          }
        }
      });
    }
  }

  void connectPrinter(BluetoothDevice dev) async {
    try {
      await bluetoothPrint.connect(dev).then((item) {
        var path = dotenv.get("LAST_PRINTER_CONNECT");
        StorageUtil.storeAsString(path, dev.address!);
        print(item);
      }).onError((error, stackTrace) {
        print(error.toString());
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void connectPrinterIos(BluIosModel.BluetoothDevice dev) async {
    try {
      await bluetoothPrintIos.connect(dev).then((item) {
        var path = dotenv.get("LAST_PRINTER_CONNECT");
        StorageUtil.storeAsString(path, dev.address!);
        print(item);
      }).onError((error, stackTrace) {
        print(error.toString());
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void closeMenu() async {
    if (Platform.isIOS) {
      await bluetoothPrintIos.isConnected.then((value) {
        if (value!) {
          bluetoothPrintIos.disconnect();
        }
        context.pop();
      });
    } else {
      await bluetoothPrint.isConnected.then((value) {
        if (value!) {
          bluetoothPrint.disconnect();
        }
        context.pop();
      });
    }
  }

  void modalTambah() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.black.withOpacity(0.5),
        isScrollControlled: true,
        enableDrag: false,
        isDismissible: false,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              width: 100.w,
              padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
              height: 70.h,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Gap(
                      height: 16,
                    ),
                    Text(
                      "Tenant",
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                    const Gap(
                      height: 16,
                    ),
                    Container(
                        width: 100.w,
                        height: 55,
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 0.5),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: StatefulBuilder(
                          builder: (context, setState) {
                            if (dataList!.isNotEmpty) {
                              return DropdownButton<TenantModel>(
                                items: dataList?.map((item) {
                                  return DropdownMenuItem<TenantModel>(
                                      value: item,
                                      child: Text(
                                        item.nama_tenant as String,
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.black),
                                      ));
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    nameTenant = value!.nama_tenant;
                                    idTenant = value.id;
                                  });
                                },
                                underline: const SizedBox(height: 0),
                                hint: Text(nameTenant.isNotEmpty
                                    ? nameTenant
                                    : hintTenant),
                                isExpanded: true,
                              );
                            } else {
                              return const SizedBox(
                                child: Text("Merchant Kosong"),
                              );
                            }
                          },
                        )),
                    const Gap(
                      height: 16,
                    ),
                    Text(
                      "Nominal",
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                    const Gap(
                      height: 16,
                    ),
                    StatefulBuilder(builder: (context, setState) {
                      return InputField(
                          control: nominalControl,
                          height: 55,
                          tipeku: Platform.isIOS
                              ? const TextInputType.numberWithOptions(
                                  signed: true, decimal: true)
                              : TextInputType.number,
                          hint: "Nominal",
                          callback: () {});
                    }),
                    const Gap(
                      height: 16,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 45.w,
                        height: 45,
                        child: ButtonComponent(
                            title: "Tambah",
                            fontSize: 12.sp,
                            bgColor: Theme.of(context).colorScheme.primary,
                            textColor: Colors.white,
                            callback: () {
                              tambahDetail();
                            }),
                      ),
                    ),
                    const Gap(
                      height: 24,
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Tambah Transaksi",
              style: TextStyle(
                  fontSize: 20.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w700),
            ),
            const Gap(
              height: 24,
            ),
            Container(
              width: 100.w,
              height: 55,
              padding: const EdgeInsets.only(left: 8, right: 8),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 0.5),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    waktuTransaksi.isEmpty ? hintTime : labelTime,
                    style: TextStyle(
                      color:
                          waktuTransaksi.isEmpty ? Colors.grey : Colors.black,
                      fontSize: 10.sp,
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: SvgPicture.asset(
                      "assets/icons/ic_calendar.svg",
                      width: 24,
                      height: 24,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(
              height: 16,
            ),
            InputField(
                control: userControl,
                height: 55,
                hint: hintCustomer,
                callback: () {}),
            const Gap(
              height: 16,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(width: 0.5, color: Colors.grey)),
              child: Row(
                children: [
                  Container(
                    height: 55,
                    width: 55,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.grey),
                    child: Center(
                      child: Text(
                        "+62",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InputField(
                        control: phoneControler,
                        height: 55,
                        tipeku: Platform.isIOS
                            ? const TextInputType.numberWithOptions(
                                signed: true, decimal: true)
                            : TextInputType.number,
                        usingBorder: false,
                        hint: hintPhone,
                        callback: () {}),
                  )
                ],
              ),
            ),
            const Gap(
              height: 16,
            ),
            Builder(builder: (context) {
              if (isSave) {
                return const Gap();
              } else {
                return ButtonComponent(
                    title: "Tambah Transaksi",
                    fontSize: 12.sp,
                    bgColor: Theme.of(context).colorScheme.primary,
                    textColor: Colors.white,
                    callback: () {
                      modalTambah();
                    });
              }
            }),
            const Gap(
              height: 24,
            ),
            Text(
              "Detail Transaksi",
              style: TextStyle(
                  fontSize: 20.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w700),
            ),
            const Gap(
              height: 8,
            ),
            Container(
              color: Colors.black,
              height: 1,
              width: 100.w,
            ),
            const Gap(
              height: 8,
            ),
            Builder(builder: (context) {
              if (detailTemp.isNotEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Gap(
                      height: 24,
                    ),
                    ...detailTemp.map((item) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            item["nama"].toString(),
                            style:
                                TextStyle(fontSize: 10.sp, color: Colors.black),
                          ),
                          Text(
                            Helper()
                                .idrShow(double.parse(item["harga"]))
                                .output
                                .symbolOnLeft,
                            style:
                                TextStyle(fontSize: 10.sp, color: Colors.black),
                          ),
                        ],
                      );
                    }),
                    const Gap(
                      height: 24,
                    ),
                    Container(
                      color: Colors.black,
                      height: 1,
                      width: 100.w,
                    ),
                  ],
                );
              } else {
                return const Gap();
              }
            }),
            const Gap(
              height: 16,
            ),
            Builder(builder: (context) {
              if (detailTemp.isNotEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Summary",
                      style: TextStyle(
                          fontSize: 20.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                    const Gap(
                      height: 16,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: SizedBox(
                        width: 70.w,
                        height: 55,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                                child: InputField(
                                    control: voucherControl,
                                    height: 55,
                                    hint: "Masukan Kode Voucher",
                                    callback: () {})),
                            const Gap(
                              width: 16,
                            ),
                            SizedBox(
                              width: 25.w,
                              height: 35,
                              child: ButtonComponent(
                                  title: "Validasi",
                                  fontSize: 8.sp,
                                  bgColor: Theme.of(context).primaryColor,
                                  textColor: Colors.white,
                                  callback: () {
                                    validasiVoucher();
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(
                      height: 24,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 50.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Builder(builder: (context) {
                              if (totalSub > 0) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: 20.w,
                                          child: Text(
                                            "Sub-total",
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                                fontSize: 10.sp,
                                                color: Colors.black),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20.w,
                                          child: Text(
                                            Helper()
                                                .idrShow(totalSub)
                                                .output
                                                .symbolOnLeft,
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                                fontSize: 10.sp,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              } else {
                                return const Gap();
                              }
                            }),
                            const Gap(
                              height: 16,
                            ),
                            Builder(builder: (context) {
                              if (discount != 0) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: 20.w,
                                      child: Text(
                                        voucher,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20.w,
                                      child: Text(
                                        "-${Helper().idrShow(discount).output.symbolOnLeft}",
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return const Gap();
                              }
                            }),
                            const Gap(
                              height: 16,
                            ),
                            Builder(builder: (context) {
                              if (detailTemp.isNotEmpty) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: 20.w,
                                      child: Text(
                                        "Grand Total",
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            fontSize: 10.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20.w,
                                      child: Text(
                                        Helper()
                                            .idrShow(grandSub)
                                            .output
                                            .symbolOnLeft,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            fontSize: 10.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return const Gap();
                              }
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return const Gap();
              }
            }),
            const Gap(
              height: 24,
            ),
            Builder(builder: (context) {
              if (isSave) {
                return SizedBox(
                  width: 100.w,
                  child: ButtonComponent(
                      title: "",
                      bgColor: Colors.white,
                      iconPath: "assets/icons/ic_print.svg",
                      textColor: Theme.of(context).primaryColor,
                      callback: () {
                        openPrint();
                      },
                      fontSize: 12.sp),
                );
              } else if (isSave == false && detailTemp.isNotEmpty) {
                return SizedBox(
                  width: 100.w,
                  child: ButtonComponent(
                      title: "Simpan",
                      bgColor: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      callback: () {
                        Helper().konfirmGlobal(
                            context: context,
                            agree: () {
                              simpanTransaksi();
                            },
                            denied: () {
                              context.pop();
                            },
                            titleAgree: "Simpan",
                            msg: "Konfirmasi Simpan Transaksi?");
                      },
                      fontSize: 12.sp),
                );
              } else {
                return const Gap();
              }
            }),
            Gap(
              height: 10.h,
            )
          ],
        ),
      )),
    );
  }
}
