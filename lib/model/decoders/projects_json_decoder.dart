import 'package:planner/model/beans/project/project.dart';
import 'package:planner/model/beans/project/projects.dart';
import 'package:planner/model/decoders/project_json_decoder.dart';
import 'package:planner/utils/json/json_serde.dart';

class ProjectsJsonDecoder {
  JsonSerDe _jsonSerDe = new JsonSerDe();
  ProjectJsonDecoder _projectJsonDecoder = new ProjectJsonDecoder();

  Future<Projects> decode(String filename) async {
    Projects projects = new Projects();
    Map<String, dynamic> projectsMap = new Map();
    projectsMap = await _jsonSerDe.fromJson("data/" + filename);
    if (projectsMap == null) {
      return null;
    }
    await projectsDecode(projects, projectsMap);
    return projects;
  }

  Future projectsDecode(
      Projects projects, Map<String, dynamic> projectsMap) async {
    List<Project> projectList = new List();
    for (String currentFile in projectsMap["files"]) {
      await _projectJsonDecoder
          .decode("projects/" + currentFile)
          .then((project) {
        projectList.add(project);
      });
    }
    projects.setProjects(projectList);
  }
}
