class Member {
  String _name;
  String _email;
  String _position;
  String _gender;
  String _filename;
  bool _changed;

  String getName() {
    return _name;
  }

  void setName(String name) {
    this._name = name;
  }

  String getEmail() {
    return _email;
  }

  void setEmail(String email) {
    this._email = email;
  }

  String getPosition() {
    return _position;
  }

  void setPosition(String position) {
    this._position = position;
  }

  String getGender() {
    return _gender;
  }

  void setGender(String gender) {
    this._gender = gender;
  }

  String getFilename() {
    return _filename;
  }

  void setFilename(String filename) {
    this._filename = filename;
  }

  bool getChanged() {
    return _changed;
  }

  void setChanged(bool changed) {
    this._changed = changed;
  }
}
