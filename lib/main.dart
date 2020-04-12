import 'package:flutter/material.dart';
import 'package:planner/view/pages/about_page.dart';
import 'package:planner/view/pages/instruction_page.dart';
import 'package:planner/view/pages/member/members_page.dart';
import 'package:planner/view/pages/loading_page.dart';
import 'package:planner/view/pages/project/project_registration_page.dart';
import 'package:planner/view/pages/project/projects_page.dart';


void main() => runApp(MaterialApp(
//      home: Home(),
  initialRoute: '/',
  routes: {
    '/': (context) => new Loading(),
    '/home': (context) => ProjectsPage(),
    '/members': (context) => MembersPage(),
    '/projects': (context) => ProjectsPage(),
    '/projectRegistration': (context) => ProjectRegistration(),
    '/instructions': (context) => Instructions(),
    '/about': (context) => About(),
//        '/members_registration': (context) => MemberRegistration()
  },
));