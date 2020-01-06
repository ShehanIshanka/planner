import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:planner/model/beans/project/project.dart';
import 'package:planner/model/beans/project/project_member.dart';
import 'package:intl/intl.dart';

class ProjectsViewPage extends StatefulWidget {
  final Project project;

  ProjectsViewPage({Key key, @required this.project}) : super(key: key);

  @override
  _ProjectsViewPageState createState() =>
      new _ProjectsViewPageState(project: project);
}

class _ProjectsViewPageState extends State<ProjectsViewPage> {
  Project project;
  var formatter = new DateFormat('yyyy/MM/dd');

  _ProjectsViewPageState({this.project});

  int calculateWorkingDays(ProjectMember projectMember) {
    return project.getEndDate().difference(project.getStartDate()).inDays +
        1 -
        project.getHolidays().length -
        projectMember.getLeaves().length;
  }

  String setWorkingDays(ProjectMember projectMember) {
    int workingDays = calculateWorkingDays(projectMember);
    if (workingDays <= 1) {
      return workingDays.toString() + " day";
    }
    return workingDays.toString() + " days";
  }

  double setTasksTime(ProjectMember projectMember) {
    int workingDays = calculateWorkingDays(projectMember);
    if (workingDays <= 0) {
      return 0;
    }
    double progress =
        projectMember.getTasksTime().fold(0, (p, c) => p + c) / workingDays;
    if (progress < 1.0) {
      return progress;
    } else {
      return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(project.getProjectName()),
        ),
        body: new SafeArea(
            top: false,
            bottom: false,
            child: new ListView(
//                mainAxisSize: MainAxisSize.min,
//                mainAxisAlignment: MainAxisAlignment.center,
//                padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                ),
                Card(
                  child: Table(border: new TableBorder(
                      horizontalInside: new BorderSide(color: Colors.grey[200], width: 0.5)
                  ),
                    children: [
                      TableRow(children: [
                        TableCell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text("Project Duration",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              Text("Holidays",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                            ],
                          ),
                        ),
                      ]),
                      TableRow(children: [
                        TableCell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                  "${formatter.format(project.getStartDate())} - ${formatter.format(project.getEndDate())}"),
                              Text(
                                  "\n${project.getHolidays().map((T) => formatter.format(T)).join("\n")}\n"),
                            ],
                          ),
                        )
                      ])
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    Card(
                      shape: RoundedRectangleBorder(
                          side: new BorderSide(color: Colors.blue, width: 2.0),
                          borderRadius: BorderRadius.circular(4.0)),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                              columns: [
                                DataColumn(
                                    label: Text(
                                      "Members",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    numeric: false,
                                    tooltip: "Member name"),
                                DataColumn(
                                  label: Center(
                                    child: Text(
                                      "Tasks",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                  numeric: false,
                                  tooltip: "Task assigned",
                                ),
                                DataColumn(
                                  label: Text(
                                    "Working Days",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  numeric: false,
                                  tooltip: "Task assigned",
                                ),
                                DataColumn(
                                  label: Text(
                                    "Leaves",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  numeric: false,
                                  tooltip: "Personal holidays",
                                ),
                              ],
                              rows: project
                                  .getProjectMembers()
                                  .map((projectMember) => DataRow(cells: [
                                        DataCell(Text(projectMember.getName()),
                                            showEditIcon: false),
                                        DataCell(
                                          SingleChildScrollView(
                                            child: Column(
                                              children: List.generate(
                                                  projectMember
                                                      .getTasks()
                                                      .length,
                                                  (index) => Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Container(
                                                              child: Text(
                                                                  projectMember
                                                                          .getTasks()[
                                                                      index],
                                                                  overflow:
                                                                      TextOverflow
                                                                          .visible),
                                                            ),
                                                            Container(
                                                              child: Text(
                                                                  projectMember
                                                                          .getTasksTime()[
                                                                              index]
                                                                          .toString() +
                                                                      " days",
                                                                  overflow:
                                                                      TextOverflow
                                                                          .visible),
                                                            ),
                                                          ])).toList(),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          new LinearPercentIndicator(
                                            width: 50.0,
                                            lineHeight: 14.0,
                                            percent:
                                                setTasksTime(projectMember),
                                            center: Text(
                                              projectMember
                                                      .getTasksTime()
                                                      .fold(0, (p, c) => p + c)
                                                      .toString() +
                                                  " days",
                                              style:
                                                  new TextStyle(fontSize: 12.0),
                                            ),
                                            backgroundColor: Colors.grey,
                                            progressColor: Colors.blue,
                                            trailing: Text(
                                                setWorkingDays(projectMember)),
                                          ),
                                        ),
                                        DataCell(
                                          SingleChildScrollView(
                                            child: Column(
                                              children: List.generate(
                                                  projectMember
                                                      .getLeaves()
                                                      .length,
                                                  (index) => Container(
                                                        child: Text(
                                                            formatter.format(projectMember
                                                                .getLeaves()[
                                                                    index]),
                                                            overflow:
                                                                TextOverflow
                                                                    .visible),
                                                      )).toList(),
                                            ),
                                          ),
                                        )
                                      ]))
                                  .toList()),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )));
  }
}
