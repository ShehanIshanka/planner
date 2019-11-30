import 'package:planner/model/beans/member/member.dart';
import 'package:planner/model/beans/member/members.dart';
import 'package:planner/model/decoders/member_json_decoder.dart';
import 'package:planner/utils/json/json_serde.dart';

class MembersJsonDecoder {
  JsonSerDe _jsonSerDe = new JsonSerDe();
  MemberJsonDecoder _memberJsonDecoder = new MemberJsonDecoder();

  Future<Members> decode(String filename) async {
    Members members = new Members();
    Map<String, List<String>> membersMap;
    await _jsonSerDe.fromJson("data/" + filename).then((onValue) {
      membersMap = onValue;
    });
    membersDecode(members, membersMap);
  }

  Future membersDecode(
      Members members, Map<String, List<String>> membersMap) async {
    List<Member> memberList;
    for (String currentFile in membersMap["files"]) {
      await _memberJsonDecoder.decode("members/" + currentFile).then((member) {
        memberList.add(member);
      });
    }
    members.setMembers(memberList);
  }
}
