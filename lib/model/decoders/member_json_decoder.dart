import 'package:planner/model/beans/member/member.dart';
import 'package:planner/utils/json/json_serde.dart';

class MemberJsonDecoder {
  JsonSerDe _jsonSerDe = new JsonSerDe();

  Future<Member> decode(String filename) async {
    Member member = new Member();
    Map<String, dynamic> memberMap = new Map();
    await _jsonSerDe.fromJson(filename).then((onValue) {
      memberMap = onValue;
    });
    memberDecode(member, memberMap);
    return member;
  }

  void memberDecode(Member member, Map<String, dynamic> memberMap) {
    member.setName(memberMap["name"]);
    member.setEmail(memberMap["email"]);
    member.setPosition(memberMap["position"]);
    member.setGender(memberMap["gender"]);
    member.setFilename(memberMap["filename"]);
    member.setChanged(false);
  }
}
