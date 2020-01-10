import 'package:planner/model/beans/project/project.dart';
import 'package:planner/model/beans/project/project_member.dart';
import 'package:planner/model/beans/project/projects.dart';
import 'package:planner/model/decoders/projects_json_decoder.dart';
import 'package:planner/model/encoders/projects_json_encoder.dart';
import 'package:planner/utils/file/file_stream.dart';
import 'package:planner/utils/json/json_serde.dart';

class ProjectDataExchanger {
  ProjectsJsonDecoder _projectsJsonDecoder = new ProjectsJsonDecoder();
  ProjectsJsonEncoder _projectsJsonEncoder = new ProjectsJsonEncoder();
  JsonSerDe _jsonSerDe = new JsonSerDe();
  FileStream _fileStream = new FileStream();

  Future setProjectFileName(Project project) async {
    int projectId;
    await getProjectId().then((onValue) {
      projectId = onValue;
    });
    project.setFilename(projectId.toString() + ".txt");
  }

  Future<Projects> getProjectData() async {
    Projects _projects;
    await Future.delayed(const Duration(milliseconds: 5));
    await _projectsJsonDecoder.decode("projects.txt").then((projects) {
      _projects = projects;
    });
    if (_projects == null) {
      _projects=new Projects();
      _projects.setProjects([]);
//      return handleNullProject();
    }
    return _projects;
  }

  Future removeProjectData(Projects projects, Project project) async {
    List<Project> projectList = projects.getProjects();
    projectList.remove(project);
    projects.setProjects(projectList);
    _projectsJsonEncoder.encode(projects);
    await _fileStream.removeFile("projects", project.getFilename());
  }

  Future<void> addProjectData(Projects projects, Project project) async {
    List<Project> projectList = projects.getProjects();
    project.setChanged(true);
    projectList.add(project);
    projects.setProjects(projectList);
    await _projectsJsonEncoder.encode(projects);
    await setNewProjectId(
        int.parse(project.getFilename().replaceAll(".txt", "")));
  }

  void editProjectData(Projects projects, Project project, int index) {
    List<Project> projectList = projects.getProjects();
    projectList[index] = project;
    project.setChanged(true);
    projects.setProjects(projectList);
    _projectsJsonEncoder.encode(projects);
  }

  Future setNewProjectId(int id) async {
    Map<String, dynamic> projectIdMap = new Map();
    projectIdMap["projectId"] = id + 1;
    _jsonSerDe.toJson("data", "projectId.txt", projectIdMap);
  }

  Future<int> getProjectId() async {
    Map<String, dynamic> projectIdMap = new Map();
    await _jsonSerDe.fromJson("data/projectId.txt").then((onValue) {
      projectIdMap = onValue;
    });
    print(projectIdMap);
    if (projectIdMap != null) {
      return projectIdMap["projectId"];
    } else {
      return 0;
    }
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
