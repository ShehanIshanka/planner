import 'package:flutter/material.dart';

class PopUpBox {
  void confirmDialog(BuildContext context, String data) {
    List details = data.split(",");
    String name = details[0];
    String email = details[1];
    String position = details[2];
    String gender = details[3];

    showDialog(
      context: context,
      barrierDismissible: true, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          content: new Container(
//            height: MediaQuery.of(context).size.height / 4,
//            width: MediaQuery.of(context).size.width / 4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: AssetImage('assets/$gender.png'),
                ),
                Card(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.person),
                      Flexible(
                          child: Text(name, overflow: TextOverflow.fade)),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ),
                Card(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.mail),
                      Flexible(
                          child: Text(email, overflow: TextOverflow.fade)),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),

                ),
                Card(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.person_pin),
                      Flexible(
                          child: Text(position, overflow: TextOverflow.fade)),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        );
      },
    );
  }
}
