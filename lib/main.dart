import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:bluetooth_print/bluetooth_print.dart' as BlueIos;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';
import 'package:smexpo2023/util/router_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  dotenv.load(fileName: ".env");
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .whenComplete(
    () => runApp(const ProviderScope(child: MyApp())),
  );
}

BlueThermalPrinter bluetoothPrint = BlueThermalPrinter.instance;
BlueIos.BluetoothPrint bluetoothPrintIos = BlueIos.BluetoothPrint.instance;

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => MaterialApp.router(
        routerConfig: RouterManager().routeManager,
        scaffoldMessengerKey: scaffoldMessengerKey,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: HexColor("#0174BE")),
          useMaterial3: true,
          textTheme: GoogleFonts.interTextTheme(),
        ),
      ),
    );
  }
}
