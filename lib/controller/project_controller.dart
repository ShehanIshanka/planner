import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planner/dal/member_data_exchanger.dart';
import 'package:planner/dal/project_data_exchanger.dart';
import 'package:planner/model/beans/member/members.dart';
import 'package:planner/model/beans/project/project.dart';
import 'package:planner/model/beans/project/project_member.dart';
import 'package:planner/model/beans/project/projects.dart';
import 'package:planner/view/pages/project/project_registration_page.dart';
import 'package:planner/view/pages/project/project_task_page.dart';
import 'package:planner/view/pages/project/projects_view_page.dart';

class ProjectController {
  ProjectDataExchanger _projectDataExchanger = new ProjectDataExchanger();
  MemberDataExchanger _memberDataExchanger = new MemberDataExchanger();
  Projects _projects;

  Future<Projects> updateView() async {
    await _projectDataExchanger.getProjectData().then((projects) {
      _projects = projects;
    });
    return _projects;
  }

  Future navigateToProjectRegistrationPage(
      BuildContext context, String status, Project project,
      {int index = 1}) async {
    Members _members;
    await _memberDataExchanger.getMemberData().then((members) {
      _members = members;
    });
    Project resultProject;
    if (status == "new") {
      await _projectDataExchanger.setProjectFileName(project);
      resultProject = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProjectRegistration(
                  project: project, status: status, members: _members)));
      if (resultProject != null) {
        await _projectDataExchanger.addProjectData(_projects, resultProject);
      }
    } else if (status == "edit") {
      resultProject = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProjectRegistration(
                  project: project, status: status, members: _members)));
      if (resultProject != null) {
        _projectDataExchanger.editProjectData(_projects, resultProject, index);
      }
    }
  }

  Future navigateToProjectTaskPage(BuildContext context,
      ProjectMember projectMember, int projectTime) async {
    ProjectMember resultProjectMember;
    resultProjectMember = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProjectTask(
                projectMember: projectMember, projectTime: projectTime)));
    if (resultProjectMember != null) {
//        _projectDataExchanger.addMemberData(_members, resultMember);
    }
  }

  Future navigateToProjectViewPage(
      BuildContext context, Project project) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProjectsViewPage(project: project)));
  }

  void removeProject(Project project) async {
    await _projectDataExchanger.removeProjectData(_projects, project);
  }
}
