import 'dart:math';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:planner/controller/project_controller.dart';
import 'package:planner/model/beans/project/project.dart';
import 'package:planner/model/beans/project/project_member.dart';
import 'package:planner/model/beans/project/projects.dart';
import 'package:planner/model/encoders/projects_json_encoder.dart';
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

class ProjectsPage extends StatefulWidget {
  @override
  _ProjectsPageState createState() => new _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  Projects projects;
  ProjectController _projectController = new ProjectController();
  ConfirmationDialog projectRemovalCheck = new ConfirmationDialog();
  PopUpBox popUpBox = new PopUpBox();
  AnimationController _controller;
  final ScrollController controller = ScrollController();

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

  void test() {
    Projects projects = new Projects();
    List<Project> projectList = new List();
    ProjectMember projectMember = new ProjectMember();

    projectMember.setName("exampleMemeber");
    projectMember.setLeaves([new DateTime.now()]);
    projectMember.setTasks(["example task"]);
    projectMember.setTasksTime([2]);

    for (int i = 1000; i < 1002; i++) {
      Project project = new Project();
      project.setProjectName(i.toString());
      project.setHolidays([new DateTime.now()]);
      project.setProjectMembers([projectMember]);
      project.setChanged(true);
      project.setFilename(i.toString() + ".txt");
      projectList.add(project);
    }
    projects.setProjects(projectList);
    ProjectsJsonEncoder().encode(projects);
    setState(() {});
  }

  bool enableScrollBar(double height, int length) {
    if (height / 96 < length) {
      return true;
    } else {
      return false;
    }
  }

  double getHeight(double height, int length) {
    double h = height - (length + 1 - height / 96) * 96;
    if (h < 20) {
      return 20.0;
    }
    return h;
  }

  Future<List> setProjects() async {
    projects = await _projectController.updateView();
    print("data/");
    print(projects.getProjects());
    print("data/");
    return projects.getProjects();
  }

  List setProjectState(DateTime startDate, DateTime endDate) {
    DateTime now = new DateTime.now();
    if (startDate.year > now.year) {
      return ["Not started yet", Colors.amber];
    } else if (startDate.year == now.year && startDate.month > now.month) {
      return ["Not started yet", Colors.amber];
    } else if (startDate.year == now.year &&
        startDate.month == now.month &&
        startDate.day > now.day) {
      return ["Not started yet", Colors.amber];
    }

    if (endDate.year < now.year) {
      return ["Completed", Colors.green];
    } else if (endDate.year == now.year && endDate.month < now.month) {
      return ["Completed", Colors.green];
    } else if (endDate.year == now.year &&
        endDate.month == now.month &&
        endDate.day < now.day) {
      return ["Completed", Colors.green];
    }

    return ["In progress", Colors.redAccent];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new SideDrawer(),
      appBar: new AppBar(
        title: new Text("Projects"),
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
          future: setProjects(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.data.isEmpty) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.event_note, color: Colors.grey, size: 42.0),
                  Text(
                    "No projects",
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ],
              ));
            }
            return SafeArea(
                child: DraggableScrollbar.rrect(
              controller: controller,
              heightScrollThumb: getHeight(
                  MediaQuery.of(context).size.height, snapshot.data.length),
              backgroundColor: Colors.grey[400],
              alwaysVisibleScrollThumb: enableScrollBar(
                  MediaQuery.of(context).size.height, snapshot.data.length),
              child: ListView.builder(
                itemCount: snapshot.data.length,
                controller: controller,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                    child: Card(
                      child: Container(
                        child: ListTile(
                            onTap: () async {
                              _projectController.navigateToProjectViewPage(
                                  context, snapshot.data[index]);
                            },
                            title: Text(
                              snapshot.data[index].getProjectName(),
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
                                backgroundImage:
                                    AssetImage('assets/project.jpg'),
                              ),
                            ),
                            subtitle: Row(
                              children: <Widget>[
                                new DotsIndicator(
                                  dotsCount: 1,
                                  position: 0,
                                  decorator: DotsDecorator(
                                    activeColor: setProjectState(
                                        snapshot.data[index].getStartDate(),
                                        snapshot.data[index].getEndDate())[1],
                                  ),
                                ),
                                Text(
                                    setProjectState(
                                        snapshot.data[index].getStartDate(),
                                        snapshot.data[index].getEndDate())[0],
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontFamily: 'Raleway')),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () async {
                                    await _projectController
                                        .navigateToProjectRegistrationPage(
                                            context,
                                            "edit",
                                            snapshot.data[index],
                                            index: index);
                                  },
                                ),
                                IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () async {
                                      String action = await projectRemovalCheck
                                          .confirmDialog(
                                              context,
                                              "Remove this project?",
                                              "This will permanently remove the member");
                                      print("STATUS IS $action");
                                      if (action == "ACCEPT") {
                                        await _projectController.removeProject(
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
              ),
            ));
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_circle),
        foregroundColor: Colors.black54,
        backgroundColor: Colors.white,
        onPressed: () async {
          await _projectController.navigateToProjectRegistrationPage(
              context, "new", new Project());
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
