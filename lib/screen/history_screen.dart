import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:smexpo2023/component/button_component.dart';
import 'package:smexpo2023/component/gap.dart';
import 'package:smexpo2023/component/input_field.dart';
import 'package:smexpo2023/component/kupon_list_item.dart';
import 'package:smexpo2023/component/loading_proses.dart';
import 'package:smexpo2023/component/transaksi_history_item.dart';
import 'package:smexpo2023/main.dart';
import 'package:smexpo2023/model/kupon_model.dart';
import 'package:smexpo2023/model/nota_model.dart';
import 'package:smexpo2023/model/riwayat_transaksi_model.dart';
import 'package:smexpo2023/provider/transaksi/history_transaksi.dart';
import 'package:smexpo2023/provider/transaksi/nota_print.dart';
import 'package:smexpo2023/provider/voucher/list_history_voucher.dart';
import 'package:smexpo2023/provider/voucher/list_voucher.dart';
import 'package:smexpo2023/util/helper.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart' as BluIosModel;
import 'package:smexpo2023/util/storage_util.dart';

DateFormat formattedSample = DateFormat("yyyy-MM-dd");

class HistoryScreen extends ConsumerStatefulWidget {
  final bool historyVoucher;
  final bool inputVoucher;
  const HistoryScreen({
    super.key,
    required this.historyVoucher,
    this.inputVoucher = false,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  TextEditingController controlSearch = TextEditingController();
  ScrollController controlScroll = ScrollController();
  List<BluetoothDevice> deviceList = [];
  BluetoothDevice? selectedDevices;
  List<BluIosModel.BluetoothDevice> deviceListIos = [];
  BluIosModel.BluetoothDevice? selectedDevicesIos;
  DateTime first = DateTime.now();
  DateTime last = DateTime.now();
  String search = "";
  bool searchChange = true;
  bool loadingMore = false;
  String tanggalFirst = "";
  String tanggalLast = "";
  String title = "";
  int start = 0;
  String hint = "";
  bool reload = false;
  bool cetakProses = false;
  void changeSearch() {
    setState(() {
      search = controlSearch.text;
    });
  }

  @override
  void didUpdateWidget(covariant HistoryScreen oldWidget) {
    if (mounted && reload) {
      if (widget.historyVoucher && widget.inputVoucher == false) {
        getListHistoriVoucher();
      } else if (widget.inputVoucher && widget.historyVoucher == false) {
        getListVoucher();
      } else {
        getListHistoriTransaksi();
        getDevices();
      }
      changeTitle();
      setState(() {
        reload = false;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  void getDevices() async {
    try {
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

  void openPrint(String order_number) async {
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
              return pilihPrint(order_number);
            }
          });
        });
  }

  void printNota(String order_number) async {
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

  Widget pilihPrint(String order_number) {
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
                printNota(order_number);
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

  Future<void> getListVoucher({String start = "0"}) async {
    try {
      //Helper().loadingProsesGlobal(context: context, msg: "Memuat...");
      await ref
          .read(providerListVoucher.notifier)
          .getListVoucher(start: start, search: search)
          .whenComplete(() {
        setState(() {
          title = "List Voucher";
        });
        var status = ref.watch(providerListVoucher).status;
        var msg = ref.watch(providerListVoucher).message;
        //var response = ref.watch(providerListVoucher).response;
        print(status);
        print(msg);
        if (status == 200) {
          setState(() {
            search = "";
            controlSearch.clear();
          });
          //context.pop();
        } else {
          setState(() {
            search = "";
            controlSearch.clear();
          });
          //context.pop();
        }
        // print(response);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getListHistoriTransaksi({String start = "0"}) async {
    try {
      if (!loadingMore) {
        Helper().loadingProsesGlobal(context: context, msg: "Memuat...");
      }
      await ref
          .read(providerHistoryTransaksi.notifier)
          .getListHistory(
              start: start,
              from: tanggalFirst,
              until: tanggalLast,
              search: search)
          .whenComplete(() {
        var status = ref.watch(providerListVoucher).status;
        var msg = ref.watch(providerListVoucher).message;
        print(status);
        print(msg);
        setState(() {
          search = "";
          controlSearch.clear();
        });
        if (!loadingMore) {
          context.pop();
        } else {
          setState(() {
            loadingMore = false;
          });
        }
      });
    } catch (e) {
      if (!loadingMore) {
        context.pop();
      } else {
        setState(() {
          loadingMore = false;
        });
      }
      print(e.toString());
    }
  }

  Future<void> getListHistoriVoucher({String start = "0"}) async {
    try {
      if (!loadingMore) {
        Helper().loadingProsesGlobal(context: context, msg: "Memuat...");
      }
      await ref
          .read(providerHistoryVoucher.notifier)
          .getListHistory(
              start: start,
              from: tanggalFirst,
              until: tanggalLast,
              search: search)
          .whenComplete(() {
        var status = ref.watch(providerListVoucher).status;
        var msg = ref.watch(providerListVoucher).message;

        print(status);
        setState(() {
          search = "";
          controlSearch.clear();
        });
        if (!loadingMore) {
          context.pop();
        } else {
          setState(() {
            loadingMore = false;
          });
        }
        print(msg);
      });
    } catch (e) {
      if (!loadingMore) {
        context.pop();
      } else {
        setState(() {
          loadingMore = false;
        });
      }
      print(e.toString());
    }
  }

  Future<void> getMoreListHistoriVoucher({String start = "0"}) async {
    try {
      await ref
          .read(providerHistoryVoucher.notifier)
          .getMoreHistory(
              start: start,
              from: tanggalFirst,
              until: tanggalLast,
              search: search)
          .whenComplete(() {
        var status = ref.watch(providerListVoucher).status;
        var msg = ref.watch(providerListVoucher).message;

        print(status);
        setState(() {
          search = "";
          controlSearch.clear();
        });
        setState(() {
          loadingMore = false;
        });
        print(msg);
      });
    } catch (e) {
      setState(() {
        loadingMore = false;
      });
      print(e.toString());
    }
  }

  Future<void> getMoreListHistoriTransaksi({String start = "0"}) async {
    try {
      await ref
          .read(providerHistoryTransaksi.notifier)
          .getMoreHistory(
              start: start,
              from: tanggalFirst,
              until: tanggalLast,
              search: search)
          .whenComplete(() {
        var status = ref.watch(providerListVoucher).status;
        var msg = ref.watch(providerListVoucher).message;

        print(status);
        setState(() {
          search = "";
          controlSearch.clear();
        });
        setState(() {
          loadingMore = false;
        });
        print(msg);
      });
    } catch (e) {
      setState(() {
        loadingMore = false;
      });
      print(e.toString());
    }
  }

  Future<void> getMoreListVoucher({String start = "0"}) async {
    try {
      await ref
          .read(providerListVoucher.notifier)
          .getMoreVocuher(start: start, search: search)
          .whenComplete(() {
        var status = ref.watch(providerListVoucher).status;
        var msg = ref.watch(providerListVoucher).message;

        print(status);
        setState(() {
          search = "";
          controlSearch.clear();
        });
        setState(() {
          loadingMore = false;
        });
        print(msg);
      });
    } catch (e) {
      setState(() {
        loadingMore = false;
      });
      print(e.toString());
    }
  }

  Future<void> moreList() async {
    try {
      var nextPageTrigger = 0.8 * controlScroll.position.maxScrollExtent;
      if (widget.historyVoucher && widget.inputVoucher == false) {
        var hasNext = ref.watch(providerHistoryVoucher).hasNextPage ?? false;
        if (hasNext && controlScroll.position.pixels > nextPageTrigger) {
          start += 10;
          setState(() {
            loadingMore = true;
          });
          getMoreListHistoriVoucher(start: start.toString());
        }
      } else if (widget.inputVoucher && widget.historyVoucher == false) {
        var hasNext = ref.watch(providerListVoucher).hasNextPage ?? false;
        if (hasNext && controlScroll.position.pixels > nextPageTrigger) {
          start += 10;
          setState(() {
            loadingMore = true;
          });
          getMoreListVoucher(start: start.toString());
        }
      } else {
        var hasNext = ref.watch(providerHistoryTransaksi).hasNextPage ?? false;
        if (hasNext && controlScroll.position.pixels > nextPageTrigger) {
          start += 10;
          setState(() {
            loadingMore = true;
          });
          getMoreListHistoriTransaksi(start: start.toString());
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    controlSearch.addListener(changeSearch);
    controlScroll.addListener(moreList);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.historyVoucher && widget.inputVoucher == false) {
        getListHistoriVoucher();
      } else if (widget.inputVoucher && widget.historyVoucher == false) {
        getListVoucher();
      } else {
        getListHistoriTransaksi();
        getDevices();
      }
      changeTitle();
    });
    super.initState();
  }

  void searchTest() {
    if (widget.historyVoucher && widget.inputVoucher == false) {
      getListHistoriVoucher();
    } else if (widget.inputVoucher && widget.historyVoucher == false) {
      getListVoucher();
    } else {
      getListHistoriTransaksi();
    }
  }

  void changeTitle() {
    if (widget.historyVoucher && widget.inputVoucher == false) {
      setState(() {
        title = "Riwayat Voucher";
        hint = "Cari Nominal";
      });
    } else if (widget.inputVoucher && widget.historyVoucher == false) {
      setState(() {
        title = "List Voucher";
        hint = "Cari Nominal";
      });
    } else {
      setState(() {
        title = "Riwayat Transaksi";
        hint = "Cari Transaksi";
      });
    }
  }

  @override
  void dispose() {
    controlSearch.removeListener(changeSearch);
    controlScroll.removeListener(moreList);
    controlSearch.dispose();
    controlScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black,
              fontWeight: FontWeight.w700),
        ),
        actions: [
          Builder(builder: (context) {
            if (widget.inputVoucher && widget.historyVoucher == false) {
              return const Gap();
            } else {
              return IconButton(
                  onPressed: () {
                    setState(() {
                      searchChange = !searchChange;
                    });
                  },
                  icon: Icon(
                    Icons.swap_vert,
                    color: Theme.of(context).primaryColor,
                  ));
            }
          })
        ],
      ),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Column(
          children: [
            Builder(builder: (context) {
              if (searchChange) {
                return SizedBox(
                  height: 55,
                  width: 100.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 70.w,
                        height: 55,
                        child: InputField(
                            control: controlSearch,
                            height: 55,
                            hint: hint,
                            callback: () {}),
                      ),
                      IconButton(
                          onPressed: () {
                            searchTest();
                          },
                          icon: Icon(
                            Icons.search,
                            size: 24,
                            color: Theme.of(context).primaryColor,
                          )),
                    ],
                  ),
                );
              } else {
                return SizedBox(
                  height: 55,
                  width: 100.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 30.w,
                        height: 35,
                        child: ButtonComponent(
                            title: formattedSample.format(first),
                            bgColor: Colors.white,
                            textColor: Theme.of(context).primaryColor,
                            callback: () {
                              Helper().showDate(context, first, (value) {
                                if (value != null) {
                                  setState(() {
                                    tanggalFirst =
                                        DateFormat("yyyy-MM-dd").format(value);
                                    first = value;
                                  });
                                }
                              });
                            },
                            fontSize: 8.sp),
                      ),
                      Text(
                        "-",
                        style: TextStyle(fontSize: 12.sp),
                      ),
                      SizedBox(
                        width: 30.w,
                        height: 35,
                        child: ButtonComponent(
                            title: formattedSample.format(last),
                            bgColor: Colors.white,
                            textColor: Theme.of(context).primaryColor,
                            callback: () {
                              Helper().showDate(context, last, (value) {
                                setState(() {
                                  if (value != null) {
                                    tanggalLast =
                                        DateFormat("yyyy-MM-dd").format(value);
                                    last = value;
                                  }
                                });
                              });
                            },
                            fontSize: 8.sp),
                      ),
                      IconButton(
                          onPressed: () {
                            searchTest();
                          },
                          icon: Icon(
                            Icons.calendar_today,
                            size: 24,
                            color: Theme.of(context).primaryColor,
                          )),
                    ],
                  ),
                );
              }
            }),
            const Gap(
              height: 24,
            ),
            Expanded(child: Builder(builder: (context) {
              if (widget.inputVoucher && widget.historyVoucher == false) {
                return Consumer(builder: (context, ref, child) {
                  var res = ref.watch(providerListVoucher).response;
                  if (res.isNotEmpty) {
                    return ListView.builder(
                        controller: controlScroll,
                        itemCount: res.length,
                        shrinkWrap: true,
                        itemBuilder: (item, index) {
                          return KuponListItem(
                              model: KuponModel.fromJson(res.elementAt(index)),
                              statUsed: false,
                              callback: () {
                                context.push("/inputvoucher", extra: {
                                  "data": res.elementAt(index),
                                }).then((value) {
                                  if (value != null) {
                                    setState(() {
                                      reload = value as bool;
                                    });
                                  }
                                });
                              });
                        });
                  } else {
                    return const SizedBox();
                  }
                });
              } else if (widget.historyVoucher &&
                  widget.inputVoucher == false) {
                return Consumer(builder: (context, ref, child) {
                  var res = ref.watch(providerHistoryVoucher).response;

                  if (res.isNotEmpty) {
                    return ListView.builder(
                        controller: controlScroll,
                        itemCount: res.length,
                        shrinkWrap: true,
                        itemBuilder: (item, index) {
                          return KuponListItem(
                              model: KuponModel.fromJson(res.elementAt(index)),
                              statUsed: true,
                              callback: () {});
                        });
                  } else {
                    return const SizedBox();
                  }
                });
              } else {
                return Consumer(builder: (context, ref, child) {
                  var res = ref.watch(providerHistoryTransaksi).response;
                  if (res.isNotEmpty) {
                    return ListView.builder(
                        controller: controlScroll,
                        itemCount: res.length,
                        shrinkWrap: true,
                        itemBuilder: (item, index) {
                          return TransaksiHistoryItem(
                              model: RiwayatTransaksiModel.fromJson(
                                  res.elementAt(index)),
                              callback: () {
                                var model = RiwayatTransaksiModel.fromJson(
                                    res.elementAt(index));
                                openPrint(model.nomor_order);
                              });
                        });
                  } else {
                    return const SizedBox();
                  }
                });
              }
            })),
            Builder(builder: (context) {
              if (loadingMore) {
                return SizedBox(
                  height: 10.h,
                  width: 100.w,
                  child: const Center(
                    child: LoadingProses(
                      message: "",
                    ),
                  ),
                );
              } else {
                return const Gap();
              }
            })
          ],
        ),
      )),
    );
  }
}
