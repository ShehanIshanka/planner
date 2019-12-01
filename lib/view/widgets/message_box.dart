import 'package:flutter/material.dart';

class MessageBox {
  void showMessage(String message, GlobalKey<ScaffoldState> _scaffoldKey,
      [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(backgroundColor: color, content: new Text(message)));
  }
}
