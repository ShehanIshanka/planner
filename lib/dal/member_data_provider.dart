import 'package:planner/model/beans/member/member.dart';
import 'package:planner/model/beans/member/members.dart';
import 'package:planner/model/decoders/members_json_decoder.dart';

class MemberDataProvider {
  MembersJsonDecoder _membersJsonDecoder = new MembersJsonDecoder();

  Future<Members> getMemberData() async {
    Members _members;
    await _membersJsonDecoder.decode("members.txt").then((members) {
      _members = members;
    });
    if (_members == null) {
      return handleNullMember();
    }
    return _members;
  }

  Members handleNullMember() {
    Members members = new Members();
    List<Member> memberList = new List();
    Member _member = new Member();
    _member.setName("example");
    _member.setEmail("example@gmail.com");
    _member.setPosition("example");
    _member.setGender("male");
    _member.setFilename("example.txt");
    _member.setChanged(false);
    memberList.add(_member);
    members.setMembers(memberList);
    return members;
  }
}
