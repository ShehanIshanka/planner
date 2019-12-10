import 'package:planner/model/beans/project/project_member.dart';

class Project {
  String _projectName = "";
  List<ProjectMember> _projectMembers = new List();
  DateTime _startDate = new DateTime.now();
  DateTime _endDate = new DateTime.now().add(new Duration(days: 14));
  String _filename = "";
  bool _changed = false;

  void setProjectName(String projectName) {
    this._projectName = projectName;
  }

  String getProjectName() {
    return this._projectName;
  }

  void setProjectMembers(List<ProjectMember> projectMembers) {
    this._projectMembers = projectMembers;
  }

  List<ProjectMember> getProjectMembers() {
    return this._projectMembers;
  }

  void setStartDate(DateTime startDate) {
    this._startDate = startDate;
  }

  DateTime getStartDate() {
    return this._startDate;
  }

  void setEndDate(DateTime endDate) {
    this._endDate = endDate;
  }

  DateTime getEndDate() {
    return this._endDate;
  }

  String getFilename() {
    return _filename;
  }

  void setFilename(String filename) {
    this._filename = filename;
  }

  bool getChanged() {
    return _changed;
  }

  void setChanged(bool changed) {
    this._changed = changed;
  }
}
