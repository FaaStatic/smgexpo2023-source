import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:smexpo2023/component/button_component.dart';
import 'package:smexpo2023/component/gap.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smexpo2023/model/user_model.dart';
import 'package:smexpo2023/util/storage_util.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String username = "User Admin";
  void permissionCheck() async {
    try {
      if (Platform.isIOS) {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.bluetooth,
          Permission.bluetoothConnect,
          Permission.bluetoothScan,
          Permission.locationWhenInUse,
          Permission.locationAlways,
          Permission.location,
          Permission.camera,
          Permission.storage
        ].request();
        print(statuses);
      } else {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        if (androidInfo.version.sdkInt <= 31) {
          Map<Permission, PermissionStatus> statuses = await [
            Permission.bluetooth,
            Permission.bluetoothConnect,
            Permission.bluetoothScan,
            Permission.location,
            Permission.locationWhenInUse,
            Permission.locationAlways,
            Permission.storage,
            Permission.camera,
          ].request();
          print(statuses);
        } else {
          Map<Permission, PermissionStatus> statuses = await [
            Permission.bluetooth,
            Permission.bluetoothConnect,
            Permission.bluetoothScan,
            Permission.location,
            Permission.locationWhenInUse,
            Permission.locationAlways,
            Permission.videos,
            Permission.photos,
            Permission.camera,
          ].request();
          print(statuses);
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void logOut() async {
    try {
      StorageUtil.clearAll();
      context.go("/login");
    } catch (e) {
      print(e.toString());
    }
  }

  void checkUsername() async {
    try {
      var key = dotenv.get("SESSION");
      StorageUtil.getAsMap(key).then((value) {
        if (value["data"] != "kosong") {
          var model = UserModel.fromJson(value);
          username = model.nama;
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      permissionCheck();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Hello, $username",
                  style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w700),
                ),
                GestureDetector(
                  onTap: () {
                    logOut();
                  },
                  child: SvgPicture.asset(
                    "assets/icons/ic_exit.svg",
                    width: 30,
                    height: 30,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
            Gap(
              height: 10.h,
            ),
            ButtonComponent(
                title: "Input Transaksi",
                bgColor: Theme.of(context).colorScheme.primary,
                textColor: Colors.white,
                iconPath: "assets/icons/ic_add.svg",
                fontSize: 12.sp,
                callback: () {
                  context.push("/inputtransaksi");
                }),
            const Gap(
              height: 16,
            ),
            ButtonComponent(
                title: "Histori Transaksi",
                bgColor: Colors.white,
                fontSize: 12.sp,
                textColor: Theme.of(context).colorScheme.primary,
                iconPath: "assets/icons/ic_history.svg",
                callback: () {
                  context.push("/history", extra: {
                    "stat": false,
                    "input": false,
                  });
                }),
            const Gap(
              height: 16,
            ),
            ButtonComponent(
                title: "Input Voucher",
                bgColor: Theme.of(context).colorScheme.primary,
                textColor: Colors.white,
                fontSize: 12.sp,
                iconPath: "assets/icons/ic_add.svg",
                callback: () {
                  context.push("/history", extra: {
                    "input": true,
                    "stat": false,
                  });
                }),
            const Gap(
              height: 16,
            ),
            ButtonComponent(
                title: "History Voucher",
                bgColor: Colors.white,
                fontSize: 12.sp,
                textColor: Theme.of(context).colorScheme.primary,
                iconPath: "assets/icons/ic_history.svg",
                callback: () {
                  context.push("/history", extra: {
                    "input": false,
                    "stat": true,
                  });
                }),
            const Gap(
              height: 16,
            ),
          ],
        ),
      )),
    );
  }
}
