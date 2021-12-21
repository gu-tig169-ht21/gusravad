import 'package:flutter/material.dart';

import 'InternetAPI.dart';

class Reminder {
  String id;
  String title;
  bool done;

  Reminder({this.id = '', required this.title, this.done = false});

  static Map<String, dynamic> toJson(Reminder task) {
    return {
      'title': task.title,
      'done': task.done,
    };
  }

  static Reminder fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'],
      title: json['title'],
      done: json['done'],
    );
  }
}

class MyState extends ChangeNotifier {
  List<Reminder> _list = [];
  List<Reminder> _filteredList = [];

  List<Reminder> get filteredList => _filteredList;

  Future getList() async {
    List<Reminder> list = await InternetAPI.getReminders();
    _list = list;
    _filteredList = _list;
    // print(_list);
    notifyListeners();
  }

  void newTask(Reminder task, [void pop]) async {
    _list = await InternetAPI.createTask(task);
    _filteredList = _list;
    // print(_list);
    notifyListeners();
  }

  void removeTask(Reminder task) async {
    _list = await InternetAPI.deleteTask(task.id);
    _filteredList = _list;
    // print(_list);
    notifyListeners();
  }

  void checkboxPressed(Reminder newValue, task) async {
    _list = await InternetAPI.updateCheckbox(newValue, task);
    // print(_list);
    notifyListeners();
  }

  void filterTasks(value) {
    if (value == 0) {
      _filteredList = _list;
    } else if (value == 1) {
      _filteredList = _list.where((task) => task.done == true).toList();
    } else if (value == 2) {
      _filteredList = _list.where((task) => task.done == false).toList();
    }
    notifyListeners();
  }
}
