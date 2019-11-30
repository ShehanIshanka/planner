import 'package:planner/model/beans/member/member.dart';

class Members {
  List<Member> _members;

  List<Member> getMembers() {
    return this._members;
  }

  void setMembers(List<Member> members) {
    this._members = members;
  }
}
