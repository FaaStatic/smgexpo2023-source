import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

class MessageFlash extends StatelessWidget {
  final int status;
  final String message;
  const MessageFlash({super.key, required this.message, required this.status});

  Color borderColor() {
    switch (status) {
      case 1:
        return const Color.fromRGBO(82, 149, 82, 1);

      case 2:
        return const Color.fromRGBO(255, 82, 82, 1);

      case 3:
        return const Color.fromRGBO(188, 150, 83, 1);

      default:
        return const Color.fromRGBO(188, 150, 83, 1);
    }
  }

  Color backgroundColor() {
    switch (status) {
      case 1:
        return const Color.fromRGBO(231, 237, 231, 1);

      case 2:
        return const Color.fromRGBO(252, 235, 235, 1);

      case 3:
        return Colors.white;

      default:
        return Colors.white;
    }
  }

  String imageStatus() {
    switch (status) {
      case 1:
        return "assets/images/ic_success.svg";

      case 2:
        return "assets/images/ic_error.svg";

      case 3:
        return "assets/images/ic_warning.svg";

      default:
        return "assets/images/ic_warning.svg";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
            color: backgroundColor(),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: borderColor(),
              width: 1,
            )),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: FittedBox(
                child: SvgPicture.asset(
                  imageStatus(),
                  width: 20,
                  height: 20,
                  color: borderColor(),
                ),
              ),
            ),
            SizedBox(
              width: 70.w,
              child: Text(
                message,
                maxLines: 2,
                style: const TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                    overflow: TextOverflow.ellipsis),
              ),
            )
          ],
        ),
      ),
    );
  }
}
