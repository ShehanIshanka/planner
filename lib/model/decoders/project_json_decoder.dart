import 'package:planner/model/beans/project/project.dart';
import 'package:planner/model/beans/project/project_member.dart';
import 'package:planner/utils/json/json_serde.dart';

class ProjectJsonDecoder {
  JsonSerDe _jsonSerDe = new JsonSerDe();

  Future<Project> decode(String filename) async {
    Project project = new Project();
    Map<String, dynamic> projectMap = new Map();
    await _jsonSerDe.fromJson(filename).then((onValue) {
      projectMap = onValue;
    });
    projectDecode(project, projectMap);
    return project;
  }

  void projectDecode(Project project, Map<String, dynamic> projectMap) async {
    project.setProjectName(projectMap["projectName"]);
    await projectMemberDecode(projectMap["projectMembers"]).then((onValue) {
      project.setProjectMembers(onValue);
    });
    project.setStartDate(DateTime.parse(projectMap["startDate"]));
    project.setEndDate(DateTime.parse(projectMap["endDate"]));
    project.setHolidays(projectMap["holidays"].cast<DateTime>());
    project.setFilename(projectMap["filename"]);
    project.setChanged(false);
  }

  Future<List<ProjectMember>> projectMemberDecode(
      List<dynamic> projectMemberMap) async {
    List<ProjectMember> projectMembersList = new List();
    for (Map<String, dynamic> currentMemberMap in projectMemberMap) {
      ProjectMember projectMember = new ProjectMember();
      projectMember.setName(currentMemberMap["name"]);
      projectMember.setLeaves(currentMemberMap["leaves"].cast<DateTime>());
      projectMember.setTasks(currentMemberMap["tasks"].cast<String>());
      projectMember.setTasksTime(currentMemberMap["tasksTime"].cast<double>());
      projectMembersList.add(projectMember);
    }
    return projectMembersList;
  }
}
