import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AddToDoList extends StatefulWidget {
  final Map? todo;
  AddToDoList({super.key, this.todo});

  @override
  State<AddToDoList> createState() => _AddToDoListState();
}

class _AddToDoListState extends State<AddToDoList> {
  TextEditingController titlecontroller = TextEditingController();

  TextEditingController discriptioncontroller = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final discription = todo['description'];
      titlecontroller.text = title;
      discriptioncontroller.text = discription;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit ToDo" : "Add ToDo")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(children: [
            TextFormField(
              controller: titlecontroller,
              decoration: InputDecoration(
                  hintText: 'Title',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: discriptioncontroller,
              minLines: 5,
              maxLines: 10,
              decoration: InputDecoration(
                  hintText: 'Description',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                  onPressed: isEdit ? updateData : submitData,
                  child: Text(isEdit ? 'Update' : 'Add')),
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      print("You can not call update without todo data");
      return;
    }
    final id = todo["_id"];
    //final id = todo["is_co"]
    final title = titlecontroller.text;
    final discription = discriptioncontroller.text;
    final body = {
      "title": title,
      "description": discription,
      "is_completed": false,
    };

    final response = await http.put(
        Uri.parse('https://api.nstack.in/v1/todos/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body));

    if (response.statusCode == 200) {
      showsuccessmessage('List Updated Succesfully');
      Get.back();
    } else {
      showerrormessage('List Not be Updated!');
    }
  }

  Future<void> submitData() async {
    final title = titlecontroller.text;
    final discription = discriptioncontroller.text;
    final body = {
      "title": title,
      "description": discription,
      "is_completed": false,
    };

    final response = await http.post(
        Uri.parse('https://api.nstack.in/v1/todos'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body));

    if (response.statusCode == 201) {
      titlecontroller.text = '';
      discriptioncontroller.text = '';
      //print('Data Submit Successfully');
      showsuccessmessage('Data Submit Successfully');
      Get.back();
    } else {
      // print('Failed to Load');
      // print(response.body);
    }
  }

  showsuccessmessage(String message) {
    final snackbar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  showerrormessage(String message) {
    final snackbar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
