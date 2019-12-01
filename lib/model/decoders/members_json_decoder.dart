import 'package:planner/model/beans/member/member.dart';
import 'package:planner/model/beans/member/members.dart';
import 'package:planner/model/decoders/member_json_decoder.dart';
import 'package:planner/utils/json/json_serde.dart';

class MembersJsonDecoder {
  JsonSerDe _jsonSerDe = new JsonSerDe();
  MemberJsonDecoder _memberJsonDecoder = new MemberJsonDecoder();

  Future<Members> decode(String filename) async {
    Members members = new Members();
    Map<String, dynamic> membersMap = new Map();
    membersMap = await _jsonSerDe.fromJson("data/" + filename);
    if (membersMap == null) {
      return null;
    }
    await membersDecode(members, membersMap);
    return members;
  }

  Future membersDecode(
      Members members, Map<String, dynamic> membersMap) async {

    List<Member> memberList = new List();
    for (String currentFile in membersMap["files"]) {
      await _memberJsonDecoder.decode("members/" + currentFile).then((member) {
        memberList.add(member);
      });
    }
    members.setMembers(memberList);
  }
}
