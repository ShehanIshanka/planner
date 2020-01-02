import 'package:planner/model/beans/project/project.dart';
import 'package:planner/model/beans/project/project_member.dart';
import 'package:planner/utils/json/json_serde.dart';

class ProjectJsonEncoder {
  JsonSerDe _jsonSerDe = new JsonSerDe();

  void encode(Project project){
    Map<String, dynamic> projectMap = new Map();
    if (project.getChanged()) {
      projectEncode(project, projectMap);
      _jsonSerDe.toJson("projects", project.getFilename(), projectMap);
      project.setChanged(false);
    }
  }

  void projectEncode(Project project, Map<String, dynamic> projectMap) {
    projectMap["projectName"] = project.getProjectName();
    projectMap["projectMembers"] =
        projectMemberEncode(project.getProjectMembers());
    projectMap["startDate"] = project.getStartDate().toString();
    projectMap["endDate"] = project.getEndDate().toString();
    projectMap["holidays"] =
        project.getHolidays().map((date) => date.toString()).toList();
    projectMap["filename"] = project.getFilename();
  }

  List<Map<dynamic, dynamic>> projectMemberEncode(
      List<ProjectMember> projectMembersList) {
    List<Map<dynamic, dynamic>> encodedProjectMembersList = new List();
    for (ProjectMember projectMember in projectMembersList) {
      Map projectMemberMap = new Map();
      projectMemberMap["name"] = projectMember.getName();
      projectMemberMap["leaves"] =
          projectMember.getLeaves().map((date) => date.toString()).toList();
      projectMemberMap["tasks"] = projectMember.getTasks();
      projectMemberMap["tasksTime"] = projectMember.getTasksTime();
      encodedProjectMembersList.add(projectMemberMap);
    }
    return encodedProjectMembersList;
  }
}
