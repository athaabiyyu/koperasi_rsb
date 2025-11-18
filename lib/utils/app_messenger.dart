import 'package:flutter/material.dart';

class AppMessenger {
  static final GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>();

  static void showSnackBar(SnackBar snackBar) {
    final state = key.currentState;
    if (state == null) return;
    state.hideCurrentSnackBar();
    state.showSnackBar(snackBar);
  }
}
