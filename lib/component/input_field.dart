import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:smexpo2023/component/gap.dart';

class InputField extends StatelessWidget {
  final TextEditingController control;
  final String hint;
  final double height;
  final bool isPassword;
  final bool obsecure;
  final TextInputType tipeku;
  final void Function() callback;
  final String pathIcon;
  final bool usingBorder;

  const InputField(
      {super.key,
      required this.control,
      required this.height,
      this.isPassword = false,
      required this.hint,
      required this.callback,
      this.pathIcon = "",
      this.tipeku = TextInputType.text,
      this.usingBorder = true,
      this.obsecure = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: height,
      padding: const EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: usingBorder ? Colors.grey : Colors.transparent,
            width: usingBorder ? 0.5 : 0,
          )),
      child: Row(
        children: [
          Expanded(
              child: TextFormField(
            controller: control,
            obscureText: obsecure,
            keyboardType: tipeku,
            style: TextStyle(fontSize: 12.sp, color: Colors.black),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                hintText: hint,
                border: InputBorder.none,
                constraints:
                    BoxConstraints(minHeight: height, maxHeight: 100.w),
                hintStyle: TextStyle(fontSize: 12.sp, color: Colors.grey)),
          )),
          Builder(builder: (context) {
            if (isPassword) {
              return GestureDetector(
                onTap: callback,
                child: SvgPicture.asset(
                  obsecure
                      ? "assets/icons/ic_eye_close.svg"
                      : "assets/icons/ic_eye_open.svg",
                  height: 24,
                  width: 24,
                ),
              );
            } else if (pathIcon.isNotEmpty) {
              return GestureDetector(
                onTap: callback,
                child: SvgPicture.asset(
                  pathIcon,
                  height: 24,
                  width: 24,
                ),
              );
            } else {
              return const Gap();
            }
          })
        ],
      ),
    );
  }
}
