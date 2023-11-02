import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smexpo2023/component/button_component.dart';
import 'package:smexpo2023/component/gap.dart';

class ModalKonfirm extends StatelessWidget {
  final void Function() aggreCall;
  final void Function() deniedCall;
  final String titleAgree;
  final String message;
  const ModalKonfirm(
      {super.key,
      required this.aggreCall,
      required this.deniedCall,
      required this.titleAgree,
      required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25.h,
      width: 80.w,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Theme.of(context).colorScheme.primary),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            message,
            maxLines: 3,
            overflow: TextOverflow.fade,
            style: TextStyle(
                color: Colors.black,
                fontSize: 12.sp,
                decoration: TextDecoration.none),
          ),
          Gap(
            height: 5.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 30.w,
                height: 45,
                child: ButtonComponent(
                    title: "Batal",
                    bgColor: Colors.white,
                    textColor: const Color.fromRGBO(255, 82, 82, 1),
                    callback: deniedCall,
                    fontSize: 10.sp),
              ),
              Gap(
                width: 5.h,
              ),
              SizedBox(
                width: 30.w,
                height: 45,
                child: ButtonComponent(
                    title: titleAgree,
                    bgColor: const Color.fromRGBO(82, 149, 82, 1),
                    textColor: Colors.white,
                    callback: aggreCall,
                    fontSize: 10.sp),
              ),
            ],
          )
        ],
      ),
    );
  }
}
