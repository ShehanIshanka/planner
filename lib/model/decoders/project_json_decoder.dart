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

  void projectDecode(Project project, Map<String, dynamic> projectMap) {
    project.setProjectName(projectMap["projectName"]);
    project
        .setProjectMembers(projectMemberDecode(projectMap["projectMembers"]));
    project.setStartDate(DateTime.parse(projectMap["startDate"]));
    project.setEndDate(DateTime.parse(projectMap["endDate"]));
    project.setFilename(projectMap["filename"]);
    project.setChanged(false);
  }

  List<ProjectMember> projectMemberDecode(
      List<Map<String, dynamic>> projectMemberMap) {
    List<ProjectMember> projectMembersList = new List();
    for (Map<String, dynamic> currentMemberMap in projectMemberMap) {
      ProjectMember projectMember = new ProjectMember();
      projectMember.setName(currentMemberMap["name"]);
      projectMember.setLeaves(currentMemberMap["leaves"]);
      projectMember.setTasks(currentMemberMap["tasks"]);
      projectMember.setTasksTime(currentMemberMap["tasksTime"]);
      projectMembersList.add(projectMember);
    }
    return projectMembersList;
  }
}
