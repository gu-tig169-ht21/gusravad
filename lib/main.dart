// ignore_for_file: prefer_const_constructors, unrelated_type_equality_checks

import 'reminder_list.dart';
import 'second_page.dart';
import 'states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
