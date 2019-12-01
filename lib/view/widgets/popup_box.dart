import 'package:flutter/material.dart';
import 'package:planner/model/beans/member/member.dart';

class PopUpBox {
  void confirmDialog(BuildContext context, Member member) {
    String name = member.getName();
    String email = member.getEmail();
    String position = member.getPosition();
    String gender = member.getGender();

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
                      Flexible(child: Text(name, overflow: TextOverflow.fade)),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ),
                Card(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.mail),
                      Flexible(child: Text(email, overflow: TextOverflow.fade)),
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
