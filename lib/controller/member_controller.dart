import 'package:flutter/material.dart';
import 'package:planner/dal/member_data_exchanger.dart';
import 'package:planner/model/beans/member/member.dart';
import 'package:planner/model/beans/member/members.dart';
import 'package:planner/view/pages/member/member_registration_page.dart';

class MemberController {
  MemberDataExchanger _memberDataExchanger = new MemberDataExchanger();
  Members _members;

  Future<Members> updateView() async {
    await _memberDataExchanger.getMemberData().then((members) {
      _members = members;
    });
    return _members;
  }

  Future navigateToMemberRegistrationPage(
      BuildContext context, String status, Member member,{int index=1}) async {
    Member resultMember;
    if (status == "new") {
      resultMember = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MemberRegistration(member: member, status: status)));
      if (resultMember != null) {
        _memberDataExchanger.addMemberData(_members, resultMember);
      }
    } else if (status == "edit") {
      resultMember = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MemberRegistration(member: member, status: status)));
      if (resultMember != null) {
        _memberDataExchanger.editMemberData(_members, resultMember,index);
      }
    }
  }

  void removerMember(Member member) async {
    await _memberDataExchanger.removeMemberData(_members, member);
  }
}
