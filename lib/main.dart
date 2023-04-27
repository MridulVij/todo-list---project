import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'src/views/todolist_homepage.dart';
//import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  runApp(const MainApp());
}

//const orng = Colors.orange;

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange),
      home: ToDoList(),
    );
  }
}
