import 'package:planner/model/beans/member/member.dart';
import 'package:planner/model/beans/member/members.dart';
import 'package:planner/model/decoders/members_json_decoder.dart';
import 'package:planner/model/encoders/memebers_json_encoder.dart';
import 'package:planner/utils/file/file_stream.dart';
import 'package:planner/utils/json/json_serde.dart';

class MemberDataExchanger {
  MembersJsonDecoder _membersJsonDecoder = new MembersJsonDecoder();
  MembersJsonEncoder _membersJsonEncoder = new MembersJsonEncoder();
  JsonSerDe _jsonSerDe = new JsonSerDe();
  FileStream _fileStream = new FileStream();

  Future setMemberFileName(Member member) async {
    int memberId;
    await getMemberId().then((onValue) {
      memberId = onValue;
    });
    member.setFilename(memberId.toString() + ".txt");
  }

  Future<Members> getMemberData() async {
    Members _members;
    await Future.delayed(const Duration(milliseconds: 4));
    await _membersJsonDecoder.decode("members.txt").then((members) {
      _members = members;
    });
    if (_members == null) {
      _members = new Members();
      _members.setMembers([]);
//      return handleNullMember();
    }
    return _members;
  }

  Future removeMemberData(Members members, Member member) async {
    List<Member> memberList = members.getMembers();
    memberList.remove(member);
    members.setMembers(memberList);
    _membersJsonEncoder.encode(members);
    await _fileStream.removeFile("members", member.getFilename());
  }

  Future addMemberData(Members members, Member member) async {
    List<Member> memberList = members.getMembers();
    member.setChanged(true);
    memberList.add(member);
    members.setMembers(memberList);
    await _membersJsonEncoder.encode(members);
    await setNewMemberId(
        int.parse(member.getFilename().replaceAll(".txt", "")));
  }

  void editMemberData(Members members, Member member, int index) {
    List<Member> memberList = members.getMembers();
    memberList[index] = member;
    member.setChanged(true);
    members.setMembers(memberList);
    _membersJsonEncoder.encode(members);
  }

  Future setNewMemberId(int id) async {
    Map<String, dynamic> memberIdMap = new Map();
    memberIdMap["memberId"] = id + 1;
    _jsonSerDe.toJson("data", "memberId.txt", memberIdMap);
  }

  Future<int> getMemberId() async {
    Map<String, dynamic> memberIdMap = new Map();
    await _jsonSerDe.fromJson("data/memberId.txt").then((onValue) {
      memberIdMap = onValue;
    });
    print(memberIdMap);
    if (memberIdMap != null) {
      return memberIdMap["memberId"];
    } else {
      return 0;
    }
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
