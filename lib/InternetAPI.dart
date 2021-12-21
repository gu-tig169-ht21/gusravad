// ignore_for_file: file_names

import 'states.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//nycklar
const apiURL = 'https://todoapp-api-pyq5q.ondigitalocean.app';
const apiKey = '64d1a609-053f-4d4d-ac33-e7438bebf7d9';

class InternetAPI {
  // lägg till //
  static Future<List<Reminder>> createTask(Reminder task) async {
    Map<String, dynamic> json = Reminder.toJson(task);
    var bodyText = jsonEncode(json);
    var response = await http.post(
      Uri.parse('$apiURL/todos?key=$apiKey'),
      body: bodyText,
      headers: {'Content-Type': 'application/json'},
    );
    bodyText = response.body;
    var list = jsonDecode(bodyText);

    return list.map<Reminder>(
      (data) {
        return Reminder.fromJson(data);
      },
    ).toList();
  }

  // ta bort //
  static Future<List<Reminder>> deleteTask(id) async {
    var response = await http.delete(
      Uri.parse('$apiURL/todos/$id?key=$apiKey&_confirm=true'),
    );
    var bodyText = response.body;
    var list = jsonDecode(bodyText);

    return list.map<Reminder>(
      (data) {
        return Reminder.fromJson(data);
      },
    ).toList();
  }

  // hämta påminnelser //
  static Future<List<Reminder>> getReminders() async {
    var response = await http.get(
      Uri.parse('$apiURL/todos?key=$apiKey'),
    );
    String bodyText = response.body;
    var json = jsonDecode(bodyText);
    // print(bodyText);
    return json.map<Reminder>(
      (data) {
        return Reminder.fromJson(data);
      },
    ).toList();
  }

  // checkbox uppdatera status //
  static Future<List<Reminder>> updateCheckbox(Reminder task, newValue) async {
    Map<String, dynamic> json = Reminder.toJson(task);
    var id = task.id;
    task.done = newValue;
    var bodyText = jsonEncode(json);
    var response = await http.put(
      Uri.parse('$apiURL/todos/$id?key=$apiKey'),
      body: bodyText,
      headers: {'Content-Type': 'application/json'},
    );
    bodyText = response.body;
    var list = jsonDecode(bodyText);
    print('ID: $id, text: $bodyText');
    return list.map<Reminder>(
      (data) {
        return Reminder.fromJson(data);
      },
    ).toList();
  }
}
