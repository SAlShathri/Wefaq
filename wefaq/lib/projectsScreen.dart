import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class projectsScreen extends StatefulWidget {
  const projectsScreen({Key? key}) : super(key: key);

  @override
  State<projectsScreen> createState() => _projectsScreenState();
}

class _projectsScreenState extends State<projectsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Projects",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 176, 145, 207),
      ),
    );
  }
}
