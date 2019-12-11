import 'package:planner/model/beans/member/member.dart';
import 'package:planner/model/beans/member/members.dart';
import 'package:planner/model/decoders/members_json_decoder.dart';
import 'package:planner/model/encoders/memebers_json_encoder.dart';
import 'package:planner/utils/file/file_stream.dart';

class MemberDataExchanger {
  MembersJsonDecoder _membersJsonDecoder = new MembersJsonDecoder();
  MembersJsonEncoder _membersJsonEncoder = new MembersJsonEncoder();
  FileStream _fileStream = new FileStream();

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

  Future removeMemberData(Members members, Member member) async {
    List<Member> memberList = members.getMembers();
    memberList.remove(member);
    members.setMembers(memberList);
    _membersJsonEncoder.encode(members);
    await _fileStream.removeFile("members", member.getFilename());
  }

  void addMemberData(Members members, Member member) {
    List<Member> memberList = members.getMembers();
    member.setFilename(member.getName() + ".txt");
    member.setChanged(true);
    memberList.add(member);
    members.setMembers(memberList);
    _membersJsonEncoder.encode(members);
  }

  void editMemberData(Members members, Member member, int index) {
    List<Member> memberList = members.getMembers();
    memberList[index] = member;
    member.setChanged(true);
    members.setMembers(memberList);
    _membersJsonEncoder.encode(members);
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
