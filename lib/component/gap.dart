import 'package:flutter/material.dart';

class Gap extends StatelessWidget {
  final double height;
  final double width;
  const Gap({super.key, this.height = 0, this.width = 0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
    );
  }
}
