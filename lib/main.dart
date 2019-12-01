import 'package:flutter/material.dart';
import 'package:planner/view/pages/member/members_page.dart';
import 'package:planner/view/pages/loading_page.dart';

void main() => runApp(MaterialApp(
//      home: Home(),
  initialRoute: '/',
  routes: {
    '/': (context) => Loading(),
    '/home': (context) => MembersPage(),
    '/members': (context) => MembersPage(),
//        '/members_registration': (context) => MemberRegistration()
  },
));