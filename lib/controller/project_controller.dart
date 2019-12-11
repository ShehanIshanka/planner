import 'package:planner/dal/project_data_exchanger.dart';
import 'package:planner/model/beans/project/projects.dart';

class ProjectController{
  ProjectDataExchanger _projectDataExchanger = new ProjectDataExchanger();
  Projects _projects;

  Future<Projects> updateView() async {
    await _projectDataExchanger.getProjectData().then((projects) {
      _projects = projects;
    });
    return _projects;
  }
}