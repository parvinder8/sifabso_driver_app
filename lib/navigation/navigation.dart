import 'package:flutter/material.dart';

class Navigation {
  void navigateToHomeAndRemoveAll(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil("store", (route) => false);
  }

  void navigateToDriverLogin(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('driver');
  }

  void navigateToOtpScreen(BuildContext context) {
    Navigator.of(context).pushNamed("otp");
  }

  void navigateToWebScreenAndRemoveAll(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil("web", (route) => false);
  }
}
