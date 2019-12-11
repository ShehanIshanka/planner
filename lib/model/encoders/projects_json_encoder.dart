import 'package:planner/model/beans/project/project.dart';
import 'package:planner/model/beans/project/projects.dart';
import 'package:planner/model/encoders/project_json_encoder.dart';
import 'package:planner/utils/json/json_serde.dart';

class ProjectsJsonEncoder {
  JsonSerDe _jsonSerDe = new JsonSerDe();
  ProjectJsonEncoder _projectsJsonEncoder = new ProjectJsonEncoder();

  void encode(Projects projects) {
    Map<String, List<String>> projectsMap = new Map();
    projectsEncode(projects, projectsMap);
    _jsonSerDe.toJson("data", "projects.txt", projectsMap);
  }

  void projectsEncode(
      Projects projects, Map<String, List<String>> projectsMap) {
    List<String> projectFileList = new List();
    for (Project currentProject in projects.getProjects()) {
      _projectsJsonEncoder.encode(currentProject);
      projectFileList.add(currentProject.getFilename());
    }
    projectsMap["files"] = projectFileList;
  }
}