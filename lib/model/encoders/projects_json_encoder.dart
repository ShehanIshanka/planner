import 'package:planner/model/beans/project/project.dart';
import 'package:planner/model/beans/project/projects.dart';
import 'package:planner/model/encoders/project_json_encoder.dart';
import 'package:planner/utils/json/json_serde.dart';

class ProjectsJsonEncoder {
  JsonSerDe _jsonSerDe = new JsonSerDe();
  ProjectJsonEncoder _projectJsonEncoder = new ProjectJsonEncoder();

  Future encode(Projects projects) async{
    Map<String, List<String>> projectsMap = new Map();
    projectsEncode(projects, projectsMap);
    await _jsonSerDe.toJson("data", "projects.txt", projectsMap);
  }

  void projectsEncode(
      Projects projects, Map<String, List<String>> projectsMap) {
    List<String> projectFileList = new List();
    for (Project currentProject in projects.getProjects()) {
      _projectJsonEncoder.encode(currentProject);
      projectFileList.add(currentProject.getFilename());
    }
    projectsMap["files"] = projectFileList;
  }
}