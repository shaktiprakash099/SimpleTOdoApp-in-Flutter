import 'package:flutter/material.dart';
import 'package:todoapp/ui/home.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo App',
      
      home: new Home(),
    );
  }
}

