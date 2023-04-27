import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_api_app/src/views/todolist_add.dart';
import 'package:http/http.dart' as http;

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  @override
  void initState() {
    super.initState();
    fetchToDoData();
  }

  List items = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Center(child: Text('ToDo List')),
          elevation: 0.0,
        ),
        body: Visibility(
          visible: isLoading,
          replacement: const Center(child: CircularProgressIndicator()),
          child: RefreshIndicator(
            onRefresh: fetchToDoData,
            child: Visibility(
              visible: items.isNotEmpty,
              replacement: const Center(
                child: Text("ToDo List is Empty"),
              ),
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index] as Map;
                  final itemId = item['_id'] as String;
                  return Card(
                    shadowColor: Colors.black,
                    color: Colors.white,
                    margin: const EdgeInsets.all(4),
                    child: ListTile(
                      // leading: CircleAvatar(
                      //     radius: 10,
                      //     child: Text(
                      //       '${index + 1}',
                      //       style: TextStyle(fontSize: 10),
                      //     )),
                      title: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          item['title'],
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          item['description'],
                          style:
                              TextStyle(fontSize: 15, color: Colors.grey[700]),
                        ),
                      ),
                      trailing: PopupMenuButton(
                        onSelected: (value) {
                          if (value == "edit") {
                            // open edit page to edit the text
                            navigationtoeditpage(item);
                          } else if (value == "delete") {
                            // delete the tile and refresh the page
                            deletebyID(itemId);
                          }
                        },
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: const [
                                  Icon(Icons.edit),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Edit'),
                                  )
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Delete'),
                                  )
                                ],
                              ),
                            )
                          ];
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //fetchToDoData();
            navigationtoaddpage();
          },
          child: const Icon(
            Icons.add,
            size: 30,
          ),
        ));
  }

  Future<void> deletebyID(String id) async {
    // delete the item
    final response =
        await http.delete(Uri.parse('https://api.nstack.in/v1/todos/$id'));
    if (response.statusCode == 200) {
      // remove the item from list
      final filtered = items.where((element) => element['_id'] != id).toList();
      showsuccessmessage('Item Deleted!');
      setState(() {
        items = filtered;
      });
    } else {
      showerrormessage('Item is not be deleted!');
    }
  }

  Future<void> fetchToDoData() async {
    setState(() {
      isLoading = false;
    });

    // add internet offline exception
    final response = await http
        .get(Uri.parse('https://api.nstack.in/v1/todos?page=1&limit=20'));
    if (response.statusCode == 200) {
      //print(response);
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    }
    setState(() {
      isLoading = true;
    });
    //fetchToDoData();
  }

// snackbars
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

  // navigation
  Future<void> navigationtoaddpage() async {
    final route = MaterialPageRoute(
      builder: (context) => AddToDoList(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchToDoData();
  }

  Future<void> navigationtoeditpage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddToDoList(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchToDoData();
  }
}
