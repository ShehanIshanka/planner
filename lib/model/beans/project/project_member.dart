class ProjectMember {
  String _name = "";
  List<DateTime> _leaves = new List();
  List<String> _tasks = ["ssssssssssssssssssssssssss","ss"];
  List<double> _tasksTime = [1.0,2.0];
  bool _changed = false;

  void setName(String name) {
    this._name = name;
  }

  String getName() {
    return this._name;
  }

  void setLeaves(List<DateTime> leaves) {
    this._leaves = leaves;
  }

  List<DateTime> getLeaves() {
    return this._leaves;
  }

  void setTasks(List<String> tasks) {
    this._tasks = tasks;
  }

  List<String> getTasks() {
    return this._tasks;
  }

  void setTasksTime(List<double> tasksTime) {
    this._tasksTime = tasksTime;
  }

  List<double> getTasksTime() {
    return this._tasksTime;
  }

  bool getChanged() {
    return _changed;
  }

  void setChanged(bool changed) {
    this._changed = changed;
  }
}
