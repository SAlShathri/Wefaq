// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class PostProject extends StatefulWidget {
  const PostProject({Key? key}) : super(key: key);

  @override
  State<PostProject> createState() => _PostProjectState();
}

class _PostProjectState extends State<PostProject> {
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _descriptionEditingController =
      TextEditingController();
  late String _chosenValue;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Project"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                hintText: "Project name",
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87, width: 2.0)),
              ),
              controller: _nameEditingController,
            ),
            SizedBox(height: 20.0),
            TextFormField(
              maxLines: 6,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87, width: 2.0)),
                hintText: "Project description",
              ),
              controller: _descriptionEditingController,
            ),
            SizedBox(height: 20.0),
            DropdownButton<String>(
              focusColor: Colors.white,

              //elevation: 5,
              style: TextStyle(color: Colors.black),
              iconEnabledColor: Colors.black,
              items: <String>[
                'AI',
                'Web Development',
                'iOS Development',
                'Android Development',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              hint: Text(
                "Choose a catogray",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              onChanged: (value) {
                setState(() {
                  _chosenValue = value!;
                });
              },
            ),
            SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              height: 50.0,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 215, 189, 226)),
                  child: Text('Post',
                      style: TextStyle(color: Colors.white, fontSize: 16.0)),
                  onPressed: () {}),
            ),
          ],
        ),
      ),
    );
  }
}
