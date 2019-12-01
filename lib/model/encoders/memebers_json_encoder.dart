import 'package:planner/model/beans/member/member.dart';
import 'package:planner/model/beans/member/members.dart';
import 'package:planner/model/encoders/member_json_encoder.dart';
import 'package:planner/utils/json/json_serde.dart';

class MembersJsonEncoder {
  JsonSerDe _jsonSerDe = new JsonSerDe();
  MemberJsonEncoder _memberJsonEncoder = new MemberJsonEncoder();

  void encode(Members members) {
    Map<String, List<String>> membersMap = new Map();
    membersEncode(members, membersMap);
    _jsonSerDe.toJson("data", "members.txt", membersMap);
  }

  void membersEncode(Members members, Map<String, List<String>> membersMap) {
    List<String> memberList = new List();
    for (Member currentMember in members.getMembers()) {
      _memberJsonEncoder.encode(currentMember);
      memberList.add(currentMember.getFilename());
    }
    membersMap["files"] = memberList;
  }
}
