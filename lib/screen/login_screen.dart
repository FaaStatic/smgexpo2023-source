import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:smexpo2023/component/button_component.dart';
import 'package:smexpo2023/component/gap.dart';
import 'package:smexpo2023/component/input_field.dart';
import 'package:smexpo2023/provider/auth/login_provider.dart';
import 'package:smexpo2023/util/helper.dart';
import 'package:smexpo2023/util/message_util.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String username = "";
  String password = "";
  bool obsecure = true;

  final TextEditingController usernameControl = TextEditingController();
  final TextEditingController passwordControl = TextEditingController();

  void changeUsername() {
    setState(() {
      username = usernameControl.text;
    });
  }

  void changePassword() {
    setState(() {
      password = passwordControl.text;
    });
  }

  Future<void> loginSubmit() async {
    if (username.isNotEmpty && password.isNotEmpty) {
      Helper().loadingProsesGlobal(context: context, msg: "Login ...");
      await ref
          .read(providerLogin.notifier)
          .loginProcess(username: username, pass: password)
          .whenComplete(() {
        var status = ref.watch(providerLogin).status;
        var msg = ref.watch(providerLogin).message;
        if (status == 200) {
          print(msg);
          context.pop();
          Future.delayed(const Duration(milliseconds: 1000), () {
            MessageUtil().succesMessage(msg, 100);
          });
          Future.delayed(const Duration(milliseconds: 3000), () {
            context.go("/home");
          });
        } else {
          context.pop();
          Future.delayed(const Duration(milliseconds: 1000), () {
            MessageUtil().dangerMessage(msg, 100);
          });
          print(msg);
        }
      });
    } else {
      context.pop();
      Future.delayed(const Duration(milliseconds: 1000), () {
        MessageUtil().succesMessage("Mohon Isi Usernama/Password", 100);
      });
      print("object kosong");
    }
  }

  @override
  void initState() {
    usernameControl.addListener(changeUsername);
    passwordControl.addListener(changePassword);
    super.initState();
  }

  @override
  void dispose() {
    usernameControl.removeListener(changeUsername);
    passwordControl.removeListener(changePassword);
    usernameControl.dispose();
    passwordControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(
          left: 24,
          right: 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                "assets/images/logo_smexpo.png",
                height: 30.h,
                width: 30.h,
              ),
              const Gap(
                height: 16,
              ),
              InputField(
                control: usernameControl,
                height: 55,
                hint: "Masukan Username",
                callback: () {},
              ),
              const Gap(
                height: 24,
              ),
              InputField(
                control: passwordControl,
                height: 55,
                hint: "Masukan Password",
                callback: () {
                  setState(() {
                    obsecure = !obsecure;
                  });
                },
                obsecure: obsecure,
                isPassword: true,
              ),
              Gap(
                height: 8.h,
              ),
              ButtonComponent(
                  title: "Login",
                  bgColor: Theme.of(context).colorScheme.primary,
                  textColor: Colors.white,
                  fontSize: 12.sp,
                  callback: () {
                    loginSubmit();
                  })
            ],
          ),
        ),
      )),
    );
  }
}
