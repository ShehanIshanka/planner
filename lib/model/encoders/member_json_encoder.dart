import 'package:planner/model/beans/member/member.dart';
import 'package:planner/utils/json/json_serde.dart';

class MemberJsonEncoder {
  JsonSerDe _jsonSerDe = new JsonSerDe();

  void encode(Member member) async{
    Map<String, String> memberMap = new Map();
    if (member.getChanged()) {
      memberEncode(member, memberMap);
     await _jsonSerDe.toJson("members", member.getFilename(), memberMap);
      member.setChanged(false);
    }
  }

  void memberEncode(Member member, Map<String, String> memberMap) {
    memberMap["name"] = member.getName();
    memberMap["email"] = member.getEmail();
    memberMap["position"] = member.getPosition();
    memberMap["gender"] = member.getGender();
    memberMap["filename"] = member.getFilename();
  }
}
