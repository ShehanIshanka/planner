import 'package:flutter/material.dart';

class ConfirmationDialog {
  Future<String> confirmDialog(
      BuildContext context, String title, String message) async {
    print(context.toString());
    String state;
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: new Text(message),
          actions: <Widget>[
            FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                state = "CANCEL";
                Navigator.pop(context, state);
              },
            ),
            FlatButton(
              child: const Text('ACCEPT'),
              onPressed: () {
                state = "ACCEPT";
                Navigator.pop(context, state);
              },
            )
          ],
        );
      },
    );
  }
}
