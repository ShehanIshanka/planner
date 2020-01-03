import 'package:dots_indicator/dots_indicator.dart';
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

class ProjectsPage extends StatefulWidget {
  @override
  _ProjectsPageState createState() => new _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  Projects projects;
  ProjectController _projectController = new ProjectController();
  ConfirmationDialog projectRemovalCheck = new ConfirmationDialog();
  PopUpBox popUpBox = new PopUpBox();

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
          future: setProjects(),
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
                              backgroundImage: AssetImage('assets/project.jpg'),
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
                                        await projectRemovalCheck.confirmDialog(
                                            context,
                                            "Remove this project?",
                                            "This will permanently remove the member");
                                    print("STATUS IS $action");
                                    if (action == "ACCEPT") {
//                                          await _projectController
//                                              .removerMember(
//                                              snapshot.data[index]);
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
        child: Icon(Icons.add_circle),
        foregroundColor: Colors.black54,
        backgroundColor: Colors.white,
        onPressed: () async {
          await _projectController.navigateToProjectRegistrationPage(
              context, "new", new Project());
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
