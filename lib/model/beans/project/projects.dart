import 'package:planner/model/beans/project/project.dart';

class Projects {
  List<Project> _projects;

  List<Project> getProjects() {
    return this._projects;
  }

  void setProjects(List<Project> projects) {
    this._projects = projects;
  }
}
