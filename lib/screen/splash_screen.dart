import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:smexpo2023/util/storage_util.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  Future<void> nextPage(BuildContext context) async {
    var key = dotenv.get("SESSION");
    StorageUtil.getAsMap(key).then((value) {
      if (value["data"] == "kosong") {
        Future.delayed(const Duration(milliseconds: 3000), () {
          context.push("/login");
        });
      } else {
        Future.delayed(const Duration(milliseconds: 3000), () {
          context.go("/home");
        });
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    nextPage(context);
    return Scaffold(
      body: SafeArea(
          child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo_smexpo.png",
              width: 50.w,
              height: 50.w,
              fit: BoxFit.contain,
            )
          ],
        ),
      )),
    );
  }
}
