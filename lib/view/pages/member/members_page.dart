//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
//import 'package:planner/model/beans/member/member.dart';
//import 'package:planner/view/widgets/popup_box.dart';
//import 'package:planner/view/widgets/side_drawer.dart';
//import 'package:planner/view/widgets/confirmation_box.dart';
//
////import 'member_registration.dart';
//
//class Members extends StatefulWidget {
//  @override
//  _MembersState createState() => _MembersState();
//}
//
//class _MembersState extends State<Members> {
//
//  ConfirmationDialog memberRemovalCheck = new ConfirmationDialog();
//  PopUpBox popUpBox = new PopUpBox();
//  List memberDetails;
//  String fileContent;
//
//  Future removeData(
//      String name, String email, String position, String gender) async {
////    Member member = new Member();
////    member.name = name;
////    member.email = email;
////    member.position = position;
////    member.gender = gender;
////    member.removeMember("members", "members.txt");
//    await fileStream.readContent("members/members.txt").then((c) {
//      fileContent = c;
//    });
//    String data = '$name,$email,$position,$gender\n';
//    print("--------------------");
//    print(data);
//    print("--------------------");
//    print(fileContent.replaceAll(data, ""));
//    print("--------------------");
//    fileStream.writeContent(
//        "members", "members.txt", fileContent.replaceAll(data, ""), false);
//  }
//
//  Future<List> readData() async {
//    await fileStream.readContent("members/members.txt").then((c) {
//      memberDetails = c.split("\n");
//    });
//    memberDetails.removeLast();
//    return memberDetails;
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//      drawer: new SideDrawer(),
//      appBar: new AppBar(
//        title: new Text("Members"),
//        actions: <Widget>[
//          FlatButton(
//            textColor: Colors.white,
//            onPressed: () {
//              fileStream.writeContent(
//                  "members",
//                  "members.txt",
//                  "a,a@e,1,male\nb,b@e,2,female\nc,c@e,3,male\nd,d@e,4,female\n",
//                  false);
//            },
//            child: Text("reset"),
//            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
//          ),
//        ],
//      ),
//      body: FutureBuilder(
//          future: readData(),
//          builder: (context, snapshot) {
//            if (!snapshot.hasData) {
//              return Center(child: CircularProgressIndicator());
//            }
//            return SafeArea(
//                child: ListView.builder(
//                  itemCount: snapshot.data.length,
//                  itemBuilder: (context, index) {
//                    return Padding(
//                      padding:
//                      const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
//                      child: Card(
//                        child: Container(
//                          child: ListTile(
//                              onTap: () {
//                                popUpBox.confirmDialog(
//                                    context, snapshot.data[index]);
//                              },
//                              title: Text(
//                                snapshot.data[index].split(",")[0],
//                                overflow: TextOverflow.visible,
//                                style: TextStyle(fontWeight: FontWeight.bold),
//                              ),
//                              leading: Container(
//                                padding: EdgeInsets.only(right: 12.0),
//                                decoration: new BoxDecoration(
//                                    border: new Border(
//                                        right: new BorderSide(
//                                            width: 1.0, color: Colors.black12))),
//                                child: CircleAvatar(
//                                  backgroundImage: AssetImage(
//                                      'assets/${snapshot.data[index].split(",")[3]}.png'),
//                                ),
//                              ),
//                              subtitle: Text(snapshot.data[index].split(",")[2],
//                                  overflow: TextOverflow.ellipsis,
//                                  style: TextStyle(fontFamily: 'Raleway')),
//                              trailing: Row(
//                                mainAxisSize: MainAxisSize.min,
//                                children: <Widget>[
//                                  IconButton(
//                                    icon: Icon(
//                                      Icons.edit,
//                                      color: Colors.grey,
//                                    ),
//                                    onPressed: () async {
//                                      await Navigator.push(
//                                          context,
//                                          MaterialPageRoute(
//                                              builder: (context) =>
//                                                  MemberRegistration(
//                                                      member: Member(
//                                                          snapshot.data[index]
//                                                              .split(",")[0],
//                                                          snapshot.data[index]
//                                                              .split(",")[1],
//                                                          snapshot.data[index]
//                                                              .split(",")[2],
//                                                          snapshot.data[index]
//                                                              .split(",")[3]),
//                                                      status: "edit")));
//                                    },
//                                  ),
//                                  IconButton(
//                                      icon: Icon(
//                                        Icons.delete,
//                                        color: Colors.grey,
//                                      ),
//                                      onPressed: () async {
//                                        String action =
//                                        await memberRemovalCheck.confirmDialog(
//                                            context,
//                                            "Remove this member?",
//                                            "This will permanently remove the member");
//                                        print("STATUS IS $action");
//                                        if (action == "ACCEPT") {
//                                          await removeData(
//                                              snapshot.data[index].split(",")[0],
//                                              snapshot.data[index].split(",")[1],
//                                              snapshot.data[index].split(",")[2],
//                                              snapshot.data[index].split(",")[3]);
//                                        }
//                                        setState(() {
//                                          if (action == "ACCEPT") {
//                                            snapshot.data.removeAt(index);
//                                          }
//                                        });
//                                      }),
//                                ],
//                              )),
//                        ),
//                      ),
//                    );
//                  },
//                ));
//          }),
//      floatingActionButton: FloatingActionButton(
//        child: Icon(Icons.person_add),
//        foregroundColor: Colors.black54,
//        backgroundColor: Colors.white,
//        onPressed: () {
////          Navigator.pushNamed(context, "/members_registration");
//          Navigator.push(
//              context,
//              MaterialPageRoute(
//                  builder: (context) => MemberRegistration(
//                      member: Member("", "", "", "male"), status: "new")));
//        },
//      ),
//      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//    );
//  }
//}
