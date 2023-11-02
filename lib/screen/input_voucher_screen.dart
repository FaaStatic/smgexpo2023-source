import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:smexpo2023/component/button_component.dart';
import 'package:smexpo2023/component/gap.dart';
import 'package:smexpo2023/component/input_field.dart';
import 'package:smexpo2023/component/kupon_list_item.dart';
import 'package:smexpo2023/model/kupon_model.dart';
import 'package:smexpo2023/provider/upload/provider_upload.dart';
import 'package:smexpo2023/provider/voucher/simpan_voucher.dart';
import 'package:smexpo2023/util/helper.dart';
import 'package:smexpo2023/util/message_util.dart';

final ImagePicker picker = ImagePicker();

class InputVoucherScreen extends ConsumerStatefulWidget {
  final KuponModel? model;
  const InputVoucherScreen({super.key, required this.model});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InputVoucherScreenState();
}

class _InputVoucherScreenState extends ConsumerState<InputVoucherScreen> {
  DateTime timeNow = DateTime.now();
  String waktuTransaksi = "";
  String labelWaktu = "";
  final String hintTime = "Pilih Waktu Transaksi";
  final String hintCustomer = "Nama Customer";
  final String hintPhone = "Nomor HP Customer";
  final TextEditingController userControl = TextEditingController();
  final TextEditingController phoneControler = TextEditingController();
  String nameUser = "";
  String phone = "";
  String link = "";
  void changeName() {
    setState(() {
      nameUser = userControl.text;
    });
  }

  void changePhone() {
    setState(() {
      phone = phoneControler.text;
    });
  }

  Future<void> pickPhoto() async {
    try {
      context.pop();
      await picker.pickImage(source: ImageSource.camera).then((value) {
        if (value != null) {
          uploadBukti(value);
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> pickGaleri() async {
    try {
      context.pop();
      await picker.pickImage(source: ImageSource.gallery).then((value) {
        if (value != null) {
          uploadBukti(value);
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void uploadBukti(XFile file) async {
    try {
      Helper().loadingProsesGlobal(context: context, msg: "Upload Bukti ...");
      FormData savingpoint = FormData();
      savingpoint.files.add(
        MapEntry(
          "file",
          await MultipartFile.fromFile(file.path,
              filename: file.name, contentType: MediaType("image", "jpeg")),
        ),
      );
      await ref
          .read(providerUploadMinioUp.notifier)
          .uploadFile(fileUpload: savingpoint)
          .whenComplete(() {
        var status = ref.watch(providerUploadMinioUp).status;
        var response = ref.watch(providerUploadMinioUp).response;
        var msg = ref.watch(providerUploadMinioUp).message;

        if (status == 200) {
          setState(() {
            link = response["url"];
          });
          print(msg);
          context.pop();
          Future.delayed(const Duration(milliseconds: 1000), () {
            MessageUtil().succesMessage(msg, 100);
          });
        } else {
          context.pop();
          Future.delayed(const Duration(milliseconds: 1000), () {
            MessageUtil().dangerMessage(msg, 100);
          });
        }
      });
    } catch (e) {
      context.pop();
      Future.delayed(const Duration(milliseconds: 1000), () {
        MessageUtil().succesMessage(e.toString(), 100);
      });
    }
  }

  void simpanVoucher() async {
    try {
      Helper().loadingProsesGlobal(context: context, msg: "Simpan Voucher ...");
      var fixedPhone = "";
      if (phone.startsWith("0") || phone.startsWith("62")) {
        fixedPhone = phone;
      } else {
        fixedPhone = "0" + phone;
      }

      await ref
          .read(providerSimpanVoucher.notifier)
          .simpanVoucher(
              id: widget.model?.id,
              phone: fixedPhone,
              customer: nameUser,
              photo: link,
              date: waktuTransaksi)
          .whenComplete(() {
        var status = ref.watch(providerSimpanVoucher).status;
        var msg = ref.watch(providerSimpanVoucher).message;
        if (status == 200) {
          context.pop();
          Future.delayed(const Duration(milliseconds: 1000), () {
            context.pop(true);
          });
          Future.delayed(const Duration(milliseconds: 3000), () {
            MessageUtil().succesMessage(msg, 100);
          });
        } else {
          print(msg);
          context.pop();
          Future.delayed(const Duration(milliseconds: 3000), () {
            MessageUtil().dangerMessage(msg, 100);
          });
        }
      });
    } catch (e) {
      Future.delayed(const Duration(milliseconds: 3000), () {
        MessageUtil().dangerMessage(e.toString(), 100);
      });
      print(e.toString());
    }
  }

  void uploadModal() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: false,
      backgroundColor: Colors.black.withOpacity(0.5),
      builder: (context) {
        return Container(
          height: 25.h,
          width: 100.w,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonComponent(
                  title: "Camera",
                  bgColor: Colors.white,
                  textColor: Theme.of(context).primaryColor,
                  callback: () {
                    pickPhoto();
                  },
                  fontSize: 12.sp),
              const Gap(
                height: 16,
              ),
              ButtonComponent(
                  title: "Galeri",
                  bgColor: Colors.white,
                  textColor: Theme.of(context).primaryColor,
                  callback: () {
                    pickGaleri();
                  },
                  fontSize: 12.sp),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    print(widget.model?.id);
    userControl.addListener(changeName);
    phoneControler.addListener(changePhone);
    changeDate();

    super.initState();
  }

  void changeDate() {
    setState(() {
      waktuTransaksi = DateFormat("yyyy-MM-dd").format(timeNow);
      labelWaktu = DateFormat("dd, MMMM yyyy").format(timeNow);
    });
  }

  @override
  void dispose() {
    userControl.removeListener(changeName);
    phoneControler.removeListener(changePhone);
    userControl.dispose();
    phoneControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Input Voucher",
              style: TextStyle(
                  fontSize: 20.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w700),
            ),
            const Gap(
              height: 24,
            ),
            KuponListItem(
                model: widget.model!, statUsed: false, callback: () {}),
            const Gap(
              height: 8,
            ),
            Container(
              width: 100.w,
              height: 55,
              padding: const EdgeInsets.only(left: 8, right: 8),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 0.5),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    waktuTransaksi.isEmpty ? hintTime : labelWaktu,
                    style: TextStyle(
                      color:
                          waktuTransaksi.isEmpty ? Colors.grey : Colors.black,
                      fontSize: 10.sp,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // Helper().showDate(context, timeNow, (value) {
                      //   if (value != null) {
                      //     setState(() {
                      //       waktuTransaksi =
                      //           DateFormat("yyyy-MM-dd").format(value);
                      //       labelWaktu =
                      //           DateFormat("dd, MMM yyyy").format(value);
                      //     });
                      //   }
                      // });
                    },
                    child: SvgPicture.asset(
                      "assets/icons/ic_calendar.svg",
                      width: 24,
                      height: 24,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(
              height: 8,
            ),
            InputField(
                control: userControl,
                height: 55,
                hint: hintCustomer,
                callback: () {}),
            const Gap(
              height: 16,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(width: 0.5, color: Colors.grey)),
              child: Row(
                children: [
                  Container(
                    height: 55,
                    width: 55,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.grey),
                    child: Center(
                      child: Text(
                        "+62",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InputField(
                        control: phoneControler,
                        height: 55,
                        tipeku: TextInputType.number,
                        usingBorder: false,
                        hint: hintPhone,
                        callback: () {}),
                  )
                ],
              ),
            ),
            const Gap(
              height: 16,
            ),
            ButtonComponent(
                title: "Upload Bukti",
                bgColor: Colors.white,
                textColor: Theme.of(context).primaryColor,
                callback: () {
                  uploadModal();
                },
                fontSize: 12.sp),
            const Gap(
              height: 24,
            ),
            ButtonComponent(
                title: "Simpan",
                bgColor: Colors.white,
                textColor: Theme.of(context).primaryColor,
                callback: () {
                  Helper().konfirmGlobal(
                      context: context,
                      agree: () {
                        simpanVoucher();
                        context.pop();
                      },
                      denied: () {
                        context.pop();
                      },
                      titleAgree: "Simpan",
                      msg: "Konfirmasi Simpan Voucher?");
                },
                fontSize: 12.sp)
          ],
        ),
      )),
    );
  }
}
