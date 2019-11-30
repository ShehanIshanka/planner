import 'package:flutter/material.dart';
import 'package:planner/view/pages/member/members_page.dart';
//import 'package:planner/pages/member_registration.dart';
import 'package:planner/view/pages/loading_page.dart';
//import 'package:planner/views/pages/project/project_page.dart';

void main() => runApp(MaterialApp(
//      home: Home(),
  initialRoute: '/',
  routes: {
    '/': (context) => Loading(),
//    '/home': (context) => Home(),
//    '/members': (context) => Members(),
//        '/members_registration': (context) => MemberRegistration()
  },
));