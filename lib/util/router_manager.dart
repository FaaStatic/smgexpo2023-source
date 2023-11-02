import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smexpo2023/model/kupon_model.dart';
import 'package:smexpo2023/screen/history_screen.dart';
import 'package:smexpo2023/screen/home_screen.dart';
import 'package:smexpo2023/screen/input_transaksi_screen.dart';
import 'package:smexpo2023/screen/input_voucher_screen.dart';
import 'package:smexpo2023/screen/login_screen.dart';
import 'package:smexpo2023/screen/splash_screen.dart';

final GlobalKey<NavigatorState> keyMasterPage = GlobalKey();

class RouterManager {
  static final RouterManager router = RouterManager._internal();

  factory RouterManager() {
    return router;
  }

  RouterManager._internal();

  final routeManager =
      GoRouter(navigatorKey: keyMasterPage, initialLocation: "/", routes: [
    GoRoute(
      path: "/",
      parentNavigatorKey: keyMasterPage,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: "/login",
      parentNavigatorKey: keyMasterPage,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: "/home",
      parentNavigatorKey: keyMasterPage,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: "/history",
      parentNavigatorKey: keyMasterPage,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return HistoryScreen(
          historyVoucher: args["stat"],
          inputVoucher: args["input"] ?? false,
        );
      },
    ),
    GoRoute(
      path: "/inputvoucher",
      parentNavigatorKey: keyMasterPage,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        print(args);
        return InputVoucherScreen(
          model: KuponModel.fromJson(args["data"]),
        );
      },
    ),
    GoRoute(
      path: "/inputtransaksi",
      parentNavigatorKey: keyMasterPage,
      builder: (context, state) => const InputTransaksiScreen(),
    ),
  ]);
}
