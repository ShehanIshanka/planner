import 'package:planner/dal/member_data_provider.dart';
import 'package:planner/model/beans/member/member.dart';
import 'package:planner/model/beans/member/members.dart';

class MemberController {
  MemberDataProvider _memberDataProvider = new MemberDataProvider();
  Members _members;

  Future<Members> updateView() async {
    await _memberDataProvider.getMemberData().then((members) {
      _members = members;
    });
    return _members;
  }

  void removerMember(Member member) async {
    await _memberDataProvider.removeMemberData(_members, member);
  }
}
