import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:planner/controller/member_controller.dart';
import 'package:planner/model/beans/member/member.dart';
import 'package:planner/model/beans/member/members.dart';
import 'package:planner/view/widgets/popup_box.dart';
import 'package:planner/view/widgets/side_drawer.dart';
import 'package:planner/view/widgets/confirmation_dialog.dart';

class ticker extends StatefulWidget {
  @override
  _tickerState createState() => _tickerState();
}

class _tickerState extends State<ticker> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MembersPage extends StatefulWidget {
  @override
  _MembersPageState createState() => new _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  Members members;
  MemberController _memberController = new MemberController();
  ConfirmationDialog memberRemovalCheck = new ConfirmationDialog();
  PopUpBox popUpBox = new PopUpBox();
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: _tickerState(),
        duration: Duration(milliseconds: 1000),
        upperBound: 4 * pi,
        lowerBound: 0)
      ..addListener(() {
        if (_controller.isCompleted) {
          _controller.reset();
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<List> setMembers() async {
    members = await _memberController.updateView();
    print(members.getMembers());
    return members.getMembers();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new SideDrawer(),
      appBar: new AppBar(
        title: new Text("Members"),
        actions: <Widget>[
          GestureDetector(
            child: RotationTransition(
              turns: Tween(begin: 0.0, end: pi / 40).animate(_controller),
              child: IconButton(
                color: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(vertical: 1, horizontal: 30),
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {});
                  _controller.forward(from: 0);
                },
              ),
            ),
          )
        ],
      ),
      body: FutureBuilder(
          future: setMembers(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.data.isEmpty) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.people_outline, color: Colors.grey, size: 42.0),
                  Text(
                    "No members",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold,fontSize: 20),
                  ),
                ],
              ));
            }
            return SafeArea(
                child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                  child: Card(
                    child: Container(
                      child: ListTile(
                          onTap: () {
                            popUpBox.showMember(context, snapshot.data[index]);
                          },
                          title: Text(
                            snapshot.data[index].getName(),
                            overflow: TextOverflow.visible,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          leading: Container(
                            padding: EdgeInsets.only(right: 12.0),
                            decoration: new BoxDecoration(
                                border: new Border(
                                    right: new BorderSide(
                                        width: 1.0, color: Colors.black12))),
                            child: CircleAvatar(
                              backgroundImage: AssetImage(
                                  'assets/${snapshot.data[index].getGender()}.png'),
                            ),
                          ),
                          subtitle: Text(snapshot.data[index].getPosition(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontFamily: 'Raleway')),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                ),
                                onPressed: () async {
                                  await _memberController
                                      .navigateToMemberRegistrationPage(
                                          context, "edit", snapshot.data[index],
                                          index: index);
                                },
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () async {
                                    String action =
                                        await memberRemovalCheck.confirmDialog(
                                            context,
                                            "Remove this member?",
                                            "This will permanently remove the member");
                                    print("STATUS IS $action");
                                    if (action == "ACCEPT") {
                                      await _memberController
                                          .removerMember(snapshot.data[index]);
                                    }
                                    setState(() {
                                      if (action == "ACCEPT") {}
                                    });
                                  }),
                            ],
                          )),
                    ),
                  ),
                );
              },
            ));
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.person_add),
        foregroundColor: Colors.black54,
        backgroundColor: Colors.white,
        onPressed: () async {
          await _memberController.navigateToMemberRegistrationPage(
              context, "new", new Member());
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
