// ignore_for_file: prefer_const_constructors, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  void newTask(Reminder task) async {
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

void main() {
  var state = MyState();
  state.getList();

  runApp(
    ChangeNotifierProvider(
      create: (context) => state,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key, listOfReminders}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

//startsida
//innehåller:
//  - filtreringsknapp
//  - listan
//  - samt knapp för att skapa ny påminnelse
class MainPageState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TIG169 ToDo'),
        centerTitle: true,
        actions: [
          Container(
            child: filterListButton(),
            margin: const EdgeInsets.only(right: 15),
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Consumer<MyState>(
              builder: (context, state, child) => ReminderList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Create new action',
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 50,
        ),
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SecondPage(),
            ),
          );
        },
      ),
    );
  }

  //filtrering av påminnelser
  //  Alternativ: "all", "done" och "not done"
  Widget filterListButton() {
    return PopupMenuButton(
      icon: const Icon(Icons.miscellaneous_services),
      offset: const Offset(0, 50),
      onSelected: (value) {
        Provider.of<MyState>(context, listen: false).filterTasks(value);
      },
      itemBuilder: (context) => [
        const PopupMenuItem(child: Text('All'), value: 0),
        const PopupMenuItem(child: Text('Done'), value: 1),
        const PopupMenuItem(child: Text('Not done'), value: 2)
      ],
    );
  }
}

// andra sidan
// innehåller:
//   - förklarande text
//   - textfält
//   - "lägg till"-knapp
class SecondPage extends StatelessWidget {
  SecondPage({Key? key}) : super(key: key);

  final fromInputField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TIG169 ToDo'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            newReminderText(),
            inputReminder(context),
            addReminderButton(context),
          ],
        ),
      ),
    );
  }

  //förklarande text
  Widget newReminderText() {
    return Container(
      child: const Text('Add a new reminder:'),
      margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
    );
  }

  //textfältet
  Widget inputReminder(context) {
    return Container(
      child: TextField(
        decoration: InputDecoration(hintText: 'Example: Buy groceries'),
        controller: fromInputField,
        onSubmitted: (variabletext) {
          Provider.of<MyState>(context, listen: false).newTask(
            Reminder(title: fromInputField.text),
          );
          fromInputField.clear();
        },
      ),
      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
    );
  }

  //"add"-knappen
  Widget addReminderButton(context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: OutlinedButton(
        child: const Text('+ Add'),
        onPressed: () {
          Provider.of<MyState>(context, listen: false).newTask(
            Reminder(title: fromInputField.text),
          );
          fromInputField.clear();
        },
      ),
    );
  }
}

// listan med påminnelser
// innehåller:
//  - listan
//  - checkbox- samt "ta-bort"-knappar
class ReminderList extends StatelessWidget {
  const ReminderList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MyState>(
      builder: (context, state, child) => _reminderList(state.filteredList),
    );
  }

  Widget _reminderList(list) {
    return ListView.builder(
      itemCount: list.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return _listOfReminders(context, list[index], index);
      },
    );
  }

  Widget _listOfReminders(context, Reminder task, index) {
    return ListTile(
      leading: checkboxButton(context, task),
      title: Text(
        task.title,
        style: TextStyle(
            decoration:
                task.done ? TextDecoration.lineThrough : TextDecoration.none),
      ),
      trailing: deleteButton(context, task),
    );
  }

  //checkboxarna
  Widget checkboxButton(context, Reminder task) {
    return Checkbox(
      value: task.done,
      onChanged: (bool? newValue) {
        Provider.of<MyState>(context, listen: false)
            .checkboxPressed(task, newValue);
      },
    );
  }

  //soptunneknappen
  Widget deleteButton(context, Reminder task) {
    return IconButton(
      icon: Icon(Icons.delete),
      onPressed: () {
        Provider.of<MyState>(context, listen: false).removeTask(task);
      },
    );
  }
}
