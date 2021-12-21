import 'states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        decoration: const InputDecoration(hintText: 'Example: Buy groceries'),
        controller: fromInputField,
        onSubmitted: (variabletext) {
          Provider.of<MyState>(context, listen: false).newTask(
            Reminder(title: fromInputField.text),
          );
          Navigator.pop(context);
          fromInputField.clear();
        },
      ),
      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
    );
  }

  //"add"-knappen
  Widget addReminderButton(context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: OutlinedButton(
        child: const Text('+ Add'),
        onPressed: () {
          Provider.of<MyState>(context, listen: false).newTask(
            Reminder(title: fromInputField.text),
          );
          Navigator.pop(context);
          fromInputField.clear();
        },
      ),
    );
  }
}
