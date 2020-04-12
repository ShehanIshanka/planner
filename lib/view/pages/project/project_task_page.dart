import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:planner/model/beans/project/project_member.dart';
import 'package:planner/view/widgets/message_box.dart';

class ProjectTask extends StatefulWidget {
  final ProjectMember projectMember;
  final int projectTime;

  ProjectTask(
      {Key key, @required this.projectMember, @required this.projectTime})
      : super(key: key);

  @override
  _ProjectTaskState createState() =>
      _ProjectTaskState(projectMember: projectMember, projectTime: projectTime);
}

class _ProjectTaskState extends State<ProjectTask> {
  ProjectMember projectMember;
  int projectTime;
  List<String> _tasks = [];
  List<double> _tasksTime = [];
  String selectedTaskTime;
  List<String> dropDownItems = [];

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  MessageBox _messageBox = new MessageBox();

  _ProjectTaskState({this.projectMember, this.projectTime});

  Future<List> setTasks() async {
    return _tasks;
  }

  initialValue(val) {
    return TextEditingController(text: val);
  }

  String selectTaskTime(int index) {
    if (_tasksTime[index] != -1) {
      return dropDownItems[dropDownItems.indexOf(_tasksTime[index].toString())];
    }
    return selectedTaskTime;
  }

  void _submitForm(BuildContext context) {
    final FormState form = _formKey.currentState;

    if (!form.validate() | _tasksTime.contains(-1.0)) {
      _messageBox.showMessage(
          'Form is not valid!  Please review and correct.', _scaffoldKey);
    } else {
      form.save(); //This invokes each onSaved event
      projectMember.setTasks(_tasks);
      projectMember.setTasksTime(_tasksTime);
      Navigator.pop(context, projectMember);
//      Navigator.pushReplacementNamed(context, "/projects");
    }
  }

  @override
  void initState() {
    _tasks = List.from(projectMember.getTasks());
    _tasksTime = List.from(projectMember.getTasksTime());
    for (double i = 0; i <= projectTime; i = i + 0.5) {
      dropDownItems.add(i.toString());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text("Task Sheet of ${projectMember.getName()}"),
      ),
      body: SafeArea(
        child: Scrollbar(
          child: FutureBuilder(
              future: setTasks(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.data.isEmpty) {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.note, color: Colors.grey, size: 42.0),
                      Text(
                        "No tasks for ${projectMember.getName()}",
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ],
                  ));
                }
                return SafeArea(
                    child: Form(
                  key: _formKey,
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
//                            mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Maximum word length is 100.',
                                        labelText: 'Task',
                                      ),
                                      controller: initialValue(_tasks[index]),
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 2,
                                      onChanged: (val) => _tasks[index] = val,
//                                  initialValue: _tasks[index],
                                      inputFormatters: [
                                        new LengthLimitingTextInputFormatter(100)
                                      ],
                                      validator: (val) =>
                                          val.isEmpty ? 'Task is required' : null,
                                      onSaved: (val) => _tasks[index] = val,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Card(
                                          child: DropdownButtonHideUnderline(
                                            child: ButtonTheme(
                                              alignedDropdown: true,
                                              child: new DropdownButton<String>(
//                      isExpanded: true,
                                                items: dropDownItems
                                                    .map((String value) {
                                                  return new DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: new Text(value),
                                                  );
                                                }).toList(),
                                                value: selectTaskTime(index),
                                                hint: new Text("Set task time"),
                                                onChanged: (val) {
                                                  _tasksTime[index] =
                                                      double.parse(val);
                                                  setState(() {});
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        Card(
                                          child: IconButton(
                                            icon: Icon(Icons.delete_forever),
                                            onPressed: () async {
                                              await _tasks.removeAt(index);
                                              await _tasksTime.removeAt(index);
                                              setState(() {});
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                ));
              }),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FloatingActionButton(
            child: Icon(Icons.library_add),
            heroTag: "btn1",
            foregroundColor: Colors.black54,
            backgroundColor: Colors.white,
            onPressed: () {
              setState(() {
                _tasks.add("");
                _tasksTime.add(-1);
              });
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
