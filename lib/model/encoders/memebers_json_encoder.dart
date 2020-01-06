import 'package:planner/model/beans/member/member.dart';
import 'package:planner/model/beans/member/members.dart';
import 'package:planner/model/encoders/member_json_encoder.dart';
import 'package:planner/utils/json/json_serde.dart';

class MembersJsonEncoder {
  JsonSerDe _jsonSerDe = new JsonSerDe();
  MemberJsonEncoder _memberJsonEncoder = new MemberJsonEncoder();

  Future encode(Members members)async {
    Map<String, List<String>> membersMap = new Map();
    membersEncode(members, membersMap);
    await _jsonSerDe.toJson("data", "members.txt", membersMap);
  }

  void membersEncode(Members members, Map<String, List<String>> membersMap) {
    List<String> memberFileList = new List();
    for (Member currentMember in members.getMembers()) {
      _memberJsonEncoder.encode(currentMember);
      memberFileList.add(currentMember.getFilename());
    }
    membersMap["files"] = memberFileList;
  }
}
