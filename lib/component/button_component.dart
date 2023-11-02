import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:smexpo2023/component/gap.dart';

class ButtonComponent extends StatelessWidget {
  final void Function() callback;
  final String title;
  final double radius;
  final double height;
  final double fontSize;
  final Color textColor;
  final Color bgColor;
  final String iconPath;
  final bool isDisabled;

  const ButtonComponent({
    super.key,
    required this.title,
    required this.bgColor,
    this.isDisabled = false,
    required this.textColor,
    required this.callback,
    this.iconPath = "",
    required this.fontSize,
    this.height = 55,
    this.radius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (isDisabled) {
        } else {
          callback();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color:
                    bgColor == Colors.white ? textColor : Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(radius))),
        fixedSize: Size(100.w, height),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
                overflow: TextOverflow.ellipsis),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
          const Gap(
            width: 8,
          ),
          Builder(builder: (context) {
            if (iconPath.isNotEmpty) {
              return SvgPicture.asset(
                iconPath,
                height: 24,
                width: 24,
                color: textColor,
              );
            } else {
              return const Gap();
            }
          }),
        ],
      ),
    );
  }
}
