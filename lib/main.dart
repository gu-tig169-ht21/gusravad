// ignore_for_file: prefer_const_constructors, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyState extends ChangeNotifier {
  final List<Reminder> _list = [];

  List<Reminder> get list => _list;
  void getList() {}

  void newTask(Reminder task) {
    _list.add(task);
    notifyListeners();
  }

  void removeTask(Reminder task) {
    _list.remove(task);
    notifyListeners();
  }

  //work in progress
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
//  - filtreringsknapp (work in progress),
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
            (Consumer<MyState>(
              builder: (context, state, child) => ReminderList(state._list),
            )),
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
          var addreminder = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SecondPage(Reminder(variabletext: ''))),
          );

          if (addreminder != null) {
            Provider.of<MyState>(context, listen: false).newTask(addreminder);
          }
        },
      ),
    );
  }

  //filtrering av påminnelser (work in progress)
  //  Alternativ: "all", "done" och "not done"
  Widget filterListButton() {
    return PopupMenuButton(
      icon: const Icon(Icons.miscellaneous_services),
      offset: const Offset(0, 50),
      onSelected: (value) {
        // Provider.of<MyState>(context, listen: false).filterList(value);
      },
      itemBuilder: (context) => [
        const PopupMenuItem(child: Text('All'), value: 0),
        const PopupMenuItem(child: Text('Done'), value: 1),
        const PopupMenuItem(child: Text('Not done'), value: 2)
      ],
    );
  }
}

//hanterar kryssrutorna
class Checkboxes extends StatefulWidget {
  const Checkboxes({Key? key, bool? value}) : super(key: key);

  @override
  State<Checkboxes> createState() => CheckboxState();
}

class CheckboxState extends State<Checkboxes> {
  late bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        });
      },
    );
  }
}

class SecondPage extends StatefulWidget {
  final Reminder task;

  const SecondPage(this.task, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return _SecondPage(task);
  }
}

//andra sidan
//innehåller
//  - förklarande text
//  - textfältet för inmatning av påminnelse
//  - knapp för att lägga till påminnelse
class _SecondPage extends State<SecondPage> {
  late String variabletext;
  late TextEditingController fromInputField;

  _SecondPage(Reminder task) {
    variabletext = task.variabletext;

    fromInputField = TextEditingController();

    fromInputField.addListener(() {
      setState(() {
        variabletext = fromInputField.text;
      });
    });
  }

  final List<String> listobjects = [];

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
            inputReminder(),
            addReminderButton(),
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
  Widget inputReminder() {
    return Container(
      child: TextField(
        decoration: InputDecoration(hintText: 'Example: Buy groceries'),
        controller: fromInputField,
        onSubmitted: (vari) {
          Navigator.pop(context, Reminder(variabletext: variabletext));
          fromInputField.clear();
        },
      ),
      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
    );
  }

  //"add"-knappen
  Widget addReminderButton() {
    return Container(
        padding: EdgeInsets.all(20),
        child: OutlinedButton(
            child: const Text('+ Add'),
            onPressed: () {
              Navigator.pop(context, Reminder(variabletext: variabletext));
            }));
  }
}

class Reminder {
  String variabletext;
  Reminder({required this.variabletext});
}

//Hanterar listan över påminnelser
//Innehåller:
//  - skapande av listan tillsammans med andra element
//  - knapp för att ta bort påminnelser
class ReminderList extends StatelessWidget {
  const ReminderList(this.list, {Key? key}) : super(key: key);

  final List<Reminder> list;
  final bool checked = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: list.map((task) => _listOfReminders(context, task)).toList(),
      shrinkWrap: true,
    );
  }

  //rad med påminnelse, ruta och borttagningsknapp
  Widget _listOfReminders(BuildContext context, task) {
    return ListTile(
        leading: Checkboxes(),
        title: Text(
          task.variabletext,
          // style: TextStyle(
          //     decoration:   isChecked
          //         ? TextDecoration.lineThrough
          //         : TextDecoration.none),
        ),
        trailing: deleteButton(context, task));
  }

  //soptunneknappen
  Widget deleteButton(context, task) {
    return IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          var state = Provider.of<MyState>(context, listen: false);
          state.removeTask(task);
        });
  }
}
