import 'package:planner/model/beans/project/project.dart';
import 'package:planner/model/beans/project/project_member.dart';
import 'package:planner/model/beans/project/projects.dart';
import 'package:planner/model/decoders/projects_json_decoder.dart';
import 'package:planner/model/encoders/projects_json_encoder.dart';

class ProjectDataExchanger {
  ProjectsJsonDecoder _projectsJsonDecoder = new ProjectsJsonDecoder();
  ProjectsJsonEncoder _projectsJsonEncoder = new ProjectsJsonEncoder();

  Future<Projects> getProjectData() async {
    Projects _projects;
    await _projectsJsonDecoder.decode("projects.txt").then((projects) {
      _projects = projects;
    });
    if (_projects == null) {
      return handleNullProject();
    }
    return _projects;
  }

  Projects handleNullProject() {
    Projects projects = new Projects();
    List<Project> projectList = new List();
    Project _project = new Project();
    ProjectMember _projectMember = new ProjectMember();

    _projectMember.setName("exampleMemeber");
    _projectMember.setLeaves([new DateTime.now()]);
    _projectMember.setTasks(["example task"]);
    _projectMember.setTasksTime([2]);

    _project.setProjectName("example");
    _project.setProjectMembers([_projectMember]);
    _project.setFilename("example.txt");
    _project.setChanged(false);
    projectList.add(_project);
    projects.setProjects(projectList);
    return projects;
  }
}
