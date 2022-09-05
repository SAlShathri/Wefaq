import 'package:flutter/material.dart';
import 'package:wefaq/postProject.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorSchemeSeed: const Color.fromARGB(255, 215, 189, 226),
          useMaterial3: true,
          brightness: Brightness.light),
      home: const PostProject(),
    );
  }
}
