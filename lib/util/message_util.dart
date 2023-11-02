import 'package:flutter/material.dart';
import 'package:smexpo2023/component/message_flash.dart';
import 'package:smexpo2023/main.dart';

class MessageUtil {
  static final MessageUtil msg = MessageUtil._internal();

  factory MessageUtil() {
    return msg;
  }

  MessageUtil._internal();

  void succesMessage(String msg, double marginbott) {
    scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 5,
      margin: EdgeInsets.only(bottom: marginbott, left: 28, right: 28),
      backgroundColor: Colors.transparent,
      padding: const EdgeInsets.all(0),
      content: MessageFlash(message: msg, status: 1),
      duration: const Duration(milliseconds: 2000),
    ));
  }

  void dangerMessage(String msg, double marginbott) {
    scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 5,
      margin: EdgeInsets.only(bottom: marginbott, left: 28, right: 28),
      backgroundColor: Colors.transparent,
      padding: const EdgeInsets.all(0),
      content: MessageFlash(message: msg, status: 2),
      duration: const Duration(milliseconds: 2000),
    ));
  }

  void warningMessage(String msg, double marginbott) {
    scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 5,
      margin: EdgeInsets.only(bottom: marginbott, left: 28, right: 28),
      backgroundColor: Colors.transparent,
      padding: const EdgeInsets.all(0),
      content: MessageFlash(message: msg, status: 3),
      duration: const Duration(milliseconds: 2000),
    ));
  }
}
