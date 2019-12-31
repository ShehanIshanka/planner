import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:planner/controller/member_controller.dart';
import 'package:planner/model/beans/member/member.dart';
import 'package:planner/model/beans/member/members.dart';
import 'package:planner/view/widgets/popup_box.dart';
import 'package:planner/view/widgets/side_drawer.dart';
import 'package:planner/view/widgets/confirmation_dialog.dart';
import 'package:planner/model/encoders/memebers_json_encoder.dart';

class MembersPage extends StatefulWidget {
  @override
  _MembersPageState createState() => new _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  Members members;
  MemberController _memberController = new MemberController();
  ConfirmationDialog memberRemovalCheck = new ConfirmationDialog();
  PopUpBox popUpBox = new PopUpBox();

  void test() {
    Members members = new Members();
    List<Member> memberList = new List();
    for (int i = 0; i < 4; i++) {
      Member member = new Member();
      member.setName(i.toString()+"member");
      member.setEmail(i.toString() + "@gmail.com");
      member.setGender("female");
      if (i % 2 == 0) {
        member.setGender("male");
      }
      member.setPosition(i.toString());
      member.setChanged(true);
      member.setFilename(i.toString() + ".txt");
      memberList.add(member);
    }
    members.setMembers(memberList);
    MembersJsonEncoder().encode(members);
    setState(() {});
  }

  Future<List> setMembers() async {
    members = await _memberController.updateView();
    return members.getMembers();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new SideDrawer(),
      appBar: new AppBar(
        title: new Text("Members"),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              test();
            },
            child: Text("reset"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body: FutureBuilder(
          future: setMembers(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
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
                                popUpBox.showMember(
                                    context, snapshot.data[index]);
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
                                            width: 1.0,
                                            color: Colors.black12))),
                                child: CircleAvatar(
                                  backgroundImage: AssetImage(
                                      'assets/${snapshot.data[index]
                                          .getGender()}.png'),
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
                                          context, "edit", snapshot.data[index],index: index);
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
                                              .removerMember(
                                              snapshot.data[index]);
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
