import 'package:flutter/material.dart';
import 'package:planner/view/pages/member/members_page.dart';
import 'package:planner/view/pages/loading_page.dart';
import 'package:planner/view/pages/project/projects_page.dart';

void main() => runApp(MaterialApp(
//      home: Home(),
  initialRoute: '/',
  routes: {
    '/': (context) => Loading(),
    '/home': (context) => ProjectsPage(),
    '/members': (context) => MembersPage(),
    '/projects': (context) => ProjectsPage(),
//        '/members_registration': (context) => MemberRegistration()
  },
));