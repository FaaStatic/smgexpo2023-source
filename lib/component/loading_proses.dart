import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:smexpo2023/component/gap.dart';

class LoadingProses extends ConsumerStatefulWidget {
  final String message;
  const LoadingProses({super.key, this.message = "Proses ..."});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoadingProsesState();
}

class _LoadingProsesState extends ConsumerState<LoadingProses>
    with TickerProviderStateMixin {
  late AnimationController controllerAnim;
  @override
  void initState() {
    controllerAnim =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..addListener(() {
            setState(() {});
          });
    controllerAnim.repeat();
    super.initState();
  }

  @override
  void dispose() {
    controllerAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 40.w,
        height: 40.w,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              value: controllerAnim.value,
              color: Theme.of(context).primaryColor,
            ),
            const Gap(
              height: 16,
            ),
            Text(
              widget.message,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 10.sp,
                  decoration: TextDecoration.none),
              textAlign: TextAlign.center,
            )
          ],
        ));
  }
}
