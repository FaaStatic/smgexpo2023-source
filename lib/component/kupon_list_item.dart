import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:smexpo2023/component/gap.dart';
import 'package:smexpo2023/model/kupon_model.dart';
import 'package:smexpo2023/util/helper.dart';

class KuponListItem extends StatelessWidget {
  final KuponModel model;
  final bool statUsed;
  final void Function() callback;
  const KuponListItem(
      {super.key,
      required this.model,
      required this.statUsed,
      required this.callback});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8, left: 4, right: 4),
      child: GestureDetector(
        onTap: () {
          if (statUsed == false) {
            callback();
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          width: 100.w,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 10)
              ],
              border: Border.all(
                  color: statUsed ? Colors.grey : Colors.transparent,
                  width: 0.5),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                model.unique,
                style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: statUsed ? Colors.grey : Colors.black),
              ),
              Builder(builder: (context) {
                if (statUsed) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Gap(
                        height: 16,
                      ),
                      Text(
                        model.customer,
                        style: TextStyle(
                            fontSize: 10.sp,
                            color: statUsed ? Colors.grey : Colors.black),
                      ),
                      const Gap(
                        height: 8,
                      ),
                      Text(
                        model.uid_user,
                        style: TextStyle(
                            fontSize: 10.sp,
                            color: statUsed ? Colors.grey : Colors.black),
                      ),
                      const Gap(
                        height: 8,
                      ),
                      Text(
                        DateFormat("dd, MMMM yyyy")
                            .format(DateTime.parse(model.updated_at)),
                        style: TextStyle(
                            fontSize: 10.sp,
                            color: statUsed ? Colors.grey : Colors.black),
                      ),
                      const Gap(
                        height: 8,
                      ),
                    ],
                  );
                } else {
                  return const Gap();
                }
              }),
              const Gap(
                height: 16,
              ),
              Text(
                "Potongan -${Helper().idrShow(double.parse(model.nominal.toString())).output.symbolOnLeft}",
                style: TextStyle(
                    fontSize: 10.sp,
                    color: statUsed ? Colors.grey : Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
