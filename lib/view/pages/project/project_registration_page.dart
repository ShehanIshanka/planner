import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:planner/controller/project_controller.dart';
import 'package:planner/model/beans/member/members.dart';
import 'package:planner/model/beans/project/project.dart';
import 'package:planner/model/beans/project/project_member.dart';
import 'package:planner/view/widgets/message_box.dart';
import 'package:planner/view/widgets/multi_select_dialog.dart';
import 'package:planner/view/widgets/popup_calendar.dart';
import 'package:planner/view/widgets/task_dialog.dart';

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

class ProjectRegistration extends StatefulWidget {
  final Project project;
  final String status;
  final Members members;

  ProjectRegistration(
      {Key key,
      @required this.project,
      @required this.status,
      @required this.members})
      : super(key: key);

  @override
  _ProjectRegistration createState() => new _ProjectRegistration(
      project: project, status: status, members: members);
}

class _ProjectRegistration extends State<ProjectRegistration> {
  Project project;
  Members members;
  String status;
  String title;
  List<DateTime> dateRange = [
    new DateTime.now(),
    (new DateTime.now()).add(new Duration(days: 14))
  ];
  List<DateTime> selectedDates = [];
  List projectMembers = [];

  _ProjectRegistration({this.project, this.status, this.members});

  PopUpBoxCalender popUpBoxCalender = new PopUpBoxCalender();
  TaskDialog taskDialog = new TaskDialog();
  MessageBox _messageBox = new MessageBox();
  ProjectController _projectController = new ProjectController();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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
    setState(() {
      if (status == "new") {
        title = "New Project";
      } else if (status == "edit") {
        title = "Edit Project";
        dateRange = [project.getStartDate(), project.getEndDate()];
        selectedDates = project.getHolidays();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future selectDateRange(BuildContext context) async {
    final List<DateTime> picked = await DateRagePicker.showDatePicker(
        context: context,
        initialFirstDate: dateRange[0],
        initialLastDate: dateRange[1],
        firstDate: new DateTime(2000),
        lastDate: new DateTime(2100));
    if (picked != null && picked.length == 2) {
      dateRange = picked;
      selectedDates.clear();
      project.setStartDate(dateRange[0]);
      project.setEndDate(dateRange[1]);
      for (ProjectMember currentProjectMember in project.getProjectMembers()) {
        currentProjectMember.getLeaves().clear();
        currentProjectMember.setTasksTime(currentProjectMember
            .getTasksTime()
            .map((time) => time > calculateWorkingDays(currentProjectMember)
                ? calculateWorkingDays(currentProjectMember).toDouble()
                : time)
            .toList());
      }
      setState(() {});
      _messageBox.showMessage(
          'Please set holidays, leaves and task times.', _scaffoldKey);
//      print('Project Duration Range : $picked');
    }
  }

  Future selectHolidays(BuildContext context) async {
    List output = await PopUpBoxCalender()
        .popUpCalender(context, dateRange, selectedDates, []);
    String action = output[0];
    if (action == "OK") {
      selectedDates = output[1];
      selectedDates.sort((a, b) => a.compareTo(b));
//      print(selectedDates);
      project.setHolidays(selectedDates);
      for (ProjectMember currentProjectMember in project.getProjectMembers()) {
        currentProjectMember.setLeaves(currentProjectMember
            .getLeaves()
            .toSet()
            .difference(output[1].toSet())
            .toList());
        currentProjectMember.setTasksTime(currentProjectMember
            .getTasksTime()
            .map((time) => time > calculateWorkingDays(currentProjectMember)
                ? calculateWorkingDays(currentProjectMember).toDouble()
                : time)
            .toList());
      }
      setState(() {});
      _messageBox.showMessage(
          'Please check leaves and task times of added project members',
          _scaffoldKey);
//      print('Holidays selected : $selectedDates');
    }
  }

  Future selectLeaves(BuildContext context, ProjectMember projectMember) async {
    List<DateTime> selectedLeaves = project.getHolidays();
//    print('Leaves selected for ${projectMember.getName()} : ${projectMember.getLeaves()}');
    List output = await PopUpBoxCalender().popUpCalender(context, dateRange,
        selectedLeaves + projectMember.getLeaves(), selectedLeaves);
    String action = output[0];
    if (action == "OK") {
      selectedLeaves =
          output[1].toSet().difference(selectedLeaves.toSet()).toList();
      selectedLeaves..sort((a, b) => a.compareTo(b));
      setState(() {
        projectMember.setLeaves(selectedLeaves);
        projectMember.setTasksTime(projectMember
            .getTasksTime()
            .map((time) => time > calculateWorkingDays(projectMember)
                ? calculateWorkingDays(projectMember).toDouble()
                : time)
            .toList());
      });
      _messageBox.showMessage('Please check task times', _scaffoldKey);
//      print('Leaves selected for ${projectMember.getName()} : ${projectMember.getLeaves()}');
    }
  }

  void selectMembers(BuildContext context) async {
    final items = <MultiSelectDialogItem<int>>[];
    Set<String> memberNamesSet =
        members.getMembers().map((member) => member.getName()).toSet();
    Set<String> projectMemberNamesSet =
        project.getProjectMembers().map((member) => member.getName()).toSet();
    List<String> memberNamesList =
        memberNamesSet.difference(projectMemberNamesSet).toList();
    int i = 0;
    for (String currentMemberName in memberNamesList) {
      items.add(MultiSelectDialogItem(i, currentMemberName));
      i++;
    }
    final selectedValues = (await showDialog<Set<int>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items,
          initialSelectedValues: [1000].toSet(),
        );
      },
    ));
    if (selectedValues != null) {
      selectedValues.remove(1000);
      List<ProjectMember> projectMembersList = project.getProjectMembers();
      for (int index in selectedValues) {
        ProjectMember projectMember = new ProjectMember();
        projectMember.setName(memberNamesList[index]);
        projectMembersList.add(projectMember);
      }
      setState(() {
        project.setProjectMembers(projectMembersList);
      });
    }
  }

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

  List<Row> getTasks(ProjectMember projectMember) {
    if (projectMember.getTasks().length == 0) {
      return [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Text("No tasks",
                    style: TextStyle(color: Colors.grey[400]),
                    overflow: TextOverflow.visible),
              ),
            ])
      ];
    }
    return List.generate(
        projectMember.getTasks().length,
        (index) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Text("${projectMember.getTasks()[index]} ",
                        overflow: TextOverflow.visible),
                  ),
                  Container(
                    child: Text(
                        projectMember.getTasksTime()[index].toString() +
                            " days",
                        overflow: TextOverflow.visible),
                  ),
                ])).toList();
  }

  void _submitForm(BuildContext context) {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      _messageBox.showMessage(
          'Form is not valid!  Please review and correct.', _scaffoldKey);
    } else {
      form.save(); //This invokes each onSaved event
      Navigator.pop(context, project);
      Navigator.pushReplacementNamed(context, "/projects");
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(title),
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
      body: new SafeArea(
          top: false,
          bottom: false,
          child: Scrollbar(
            child: new ListView(
//                mainAxisSize: MainAxisSize.min,
//                mainAxisAlignment: MainAxisAlignment.center,
//                padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                ),
                Form(
                  key: _formKey,
                  autovalidate: true,
                  child: new TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      icon: const Icon(Icons.assignment),
                      hintText: 'Enter project name',
                      labelText: 'Project Name',
                    ),
                    initialValue: project.getProjectName(),
                    inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                    validator: (val) => val.isEmpty ? 'Name is required' : null,
                    onSaved: (val) => project.setProjectName(val.trim()),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new RaisedButton(
                        color: Colors.lightBlue,
                        onPressed: () async {
                          await selectDateRange(context);
                          project.setStartDate(dateRange[0]);
                          project.setEndDate(dateRange[1]);
                        },
                        child: new Text("Project Duration")),
                    new MaterialButton(
                        color: Colors.lightBlue,
                        onPressed: () async {
                          await selectHolidays(context);
//                        project.setHolidays(selectedDates);
                        },
                        child: new Text("Mark Holidays"))
                  ],
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
                                DataColumn(
                                    label: Text(
                                      "",
                                    ),
                                    numeric: false),
                              ],
                              rows: project
                                  .getProjectMembers()
                                  .map((projectMember) => DataRow(cells: [
                                        DataCell(Text(projectMember.getName()),
                                            showEditIcon: true,
                                            onTap: () async {
                                          _projectController
                                              .navigateToProjectTaskPage(
                                                  context,
                                                  projectMember,
                                                  calculateWorkingDays(
                                                      projectMember));
                                        }),
                                        DataCell(
                                          SingleChildScrollView(
                                            child: Column(
                                              children: getTasks(projectMember),
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
                                        DataCell(new MaterialButton(
                                            color: Colors.blueGrey,
                                            onPressed: () async {
                                              await selectLeaves(
                                                  context, projectMember);
                                            },
                                            child: new Text("Set Leaves"))),
                                        DataCell(IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.grey,
                                          ),
                                          onPressed: () {
                                            project
                                                .getProjectMembers()
                                                .remove(projectMember);
                                            setState(() {});
                                          },
                                        )),
                                      ]))
                                  .toList()),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FloatingActionButton(
            child: Icon(Icons.person_add),
            heroTag: "btn1",
            foregroundColor: Colors.black54,
            backgroundColor: Colors.white,
            onPressed: () {
              selectMembers(context);
            },
          ),
          FloatingActionButton(
            child: Icon(Icons.save),
            heroTag: "btn2",
            foregroundColor: Colors.black54,
            backgroundColor: Colors.white,
            onPressed: () {
              _submitForm(context);
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
