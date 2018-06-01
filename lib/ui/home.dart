import 'package:flutter/material.dart';
import 'package:todoapp/ui/todo_screen.dart';
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("To Do"),
        backgroundColor: Colors.indigoAccent,
        
      ),
      body: new ToDoScreen(),
    );
  }
}