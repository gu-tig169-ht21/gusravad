import 'states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        task.done = newValue!;
        Provider.of<MyState>(context, listen: false)
            .checkboxPressed(task, newValue);
      },
    );
  }

  //soptunneknappen
  Widget deleteButton(context, Reminder task) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () {
        Provider.of<MyState>(context, listen: false).removeTask(task);
      },
    );
  }
}
