import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '<TIG169 ToDo>',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'TIG169 ToDo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//startsida

class _MyHomePageState extends State<MyHomePage> {
  String dropdownValue = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          Container(
            child: dropdownFilter(),
            margin: const EdgeInsets.only(right: 15),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            reminderRow(),
            reminderRow(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SecondPage()));
        },
        tooltip: 'Create new action',
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 50,
        ),
      ),
    );
  }

  //rad som innehåller checkboxen, påminnelsetexten och soptunnan
  Widget reminderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            margin:
                const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 15),
            child: Checkbox(
              value: false,
              onChanged: (val) {},
            )),
        Container(
          constraints: const BoxConstraints(minWidth: 255, maxWidth: 255),
          margin: const EdgeInsets.only(top: 20, bottom: 15),
          child: Text(
            //text för påminnelsen
            'Påminnelse',
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.start,
          ),
        ),
        Container(
            margin:
                const EdgeInsets.only(left: 20, right: 10, top: 20, bottom: 15),
            child: deleteButton())
      ],
    );
  }

  //soptunneknappen
  Widget deleteButton() {
    return Column(children: <Widget>[
      IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          // work in progress
        },
      ),
    ]);
  }

  //kuggen i appbaren för att filtrera
  Widget dropdownFilter() {
    return DropdownButton<String>(
      icon: const Icon(
        Icons.miscellaneous_services,
        color: Colors.white,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>['All', 'Done', 'Undone']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      //iconSize: 30,
    );
  }
}

//sidan för att lägga till ny påminnelse

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key}) : super(key: key);

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

  //översta texten för att förklara
  Widget newReminderText() {
    return Container(
      child: const Text('New reminder:'),
      margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
    );
  }

  //textfältet
  Widget inputReminder() {
    return Container(
      child: const TextField(),
      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
    );
  }

  //"add"-knappen
  Widget addReminderButton() {
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      child: OutlinedButton(
        child: const Text('+ Add'),
        onPressed: () {
          //work in progress
        },
      ),
    );
  }
}
