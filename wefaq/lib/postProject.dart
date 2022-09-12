// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:wefaq/projectsScreen.dart';
import 'bottom_bar_custom.dart';
import 'TabScreen.dart';

class PostProject extends StatefulWidget {
  const PostProject({Key? key}) : super(key: key);

  @override
  State<PostProject> createState() => _PostProjectState();
}

class _PostProjectState extends State<PostProject> {
  final _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _descriptionEditingController =
      TextEditingController();
  final TextEditingController _lookingForEditingController =
      TextEditingController();
  static final TextEditingController _startSearchFieldController =
      TextEditingController();

  DetailsResult? startPosition;

  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  Timer? _debounce;

  // Project category list
  List<String> options = [];

  String? selectedCat;

  @override
  void initState() {
    // call the methods to fetch the data from the DB
    getCategoryList();

    super.initState();
    String apiKey = 'AIzaSyCkRaPfvVejBlQIAWEjc9klnkqk6olnhuc';
    googlePlace = GooglePlace(apiKey);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  void getCategoryList() async {
    final categories = await _firestore.collection('categories').get();
    for (var category in categories.docs) {
      for (var element in category['categories']) {
        setState(() {
          options.add(element);
        });
      }
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                onPressed: () {
                  // do something
                }),
          ],
          backgroundColor: Color.fromARGB(255, 182, 168, 203),
          title: Text('Post Project',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ))),
      bottomNavigationBar: CustomNavigationBar(
        currentHomeScreen: 2,
        updatePage: () {},
      ),
      body: Scrollbar(
        thumbVisibility: true,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
            children: <Widget>[
              TextFormField(
                  maxLength: 20,
                  decoration: InputDecoration(
                    label: RichText(
                      text: TextSpan(
                          text: 'Project title',
                          style: const TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(144, 64, 7, 87)),
                          children: [
                            TextSpan(
                                text: ' *',
                                style: TextStyle(
                                  color: Colors.red,
                                ))
                          ]),
                    ),
                    labelStyle: TextStyle(
                        fontSize: 18, color: Color.fromARGB(144, 64, 7, 87)),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(144, 64, 7, 87),
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(144, 64, 7, 87),
                        width: 2.0,
                      ),
                    ),
                  ),
                  controller: _nameEditingController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the project title.';
                    }
                  }),
              SizedBox(height: 25.0),
              TextFormField(
                  controller: _startSearchFieldController,
                  decoration: InputDecoration(
                      label: RichText(
                        text: TextSpan(
                            text: 'Project location',
                            style: const TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(144, 64, 7, 87)),
                            children: [
                              TextSpan(
                                  text: ' *',
                                  style: TextStyle(
                                    color: Colors.red,
                                  ))
                            ]),
                      ),
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black87, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(144, 64, 7, 87),
                          width: 2.0,
                        ),
                      ),
                      suffixIcon: _startSearchFieldController.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  predictions = [];
                                  _startSearchFieldController.clear();
                                });
                              },
                              icon: Icon(Icons.clear_outlined),
                            )
                          : Icon(Icons.location_searching,
                              color: Color.fromARGB(221, 137, 171, 187))),
                  onChanged: (value) {
                    if (_debounce?.isActive ?? false) _debounce!.cancel();
                    _debounce = Timer(const Duration(milliseconds: 1000), () {
                      if (value.isNotEmpty) {
                        //places api
                        autoCompleteSearch(value);
                      } else {
                        //clear out the results
                        setState(() {
                          predictions = [];
                          startPosition = null;
                        });
                      }
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the project location.';
                    }
                  }),
              Scrollbar(
                thumbVisibility: true,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: predictions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Color.fromARGB(221, 137, 171, 187),
                          child: Icon(
                            Icons.pin_drop,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          predictions[index].description.toString(),
                        ),
                        onTap: () async {
                          final placeId = predictions[index].placeId!;
                          final details =
                              await googlePlace.details.get(placeId);
                          if (details != null &&
                              details.result != null &&
                              mounted) {
                            setState(() {
                              startPosition = details.result;
                              _startSearchFieldController.text =
                                  details.result!.name!;

                              predictions = [];
                            });
                          }
                        },
                      );
                    }),
              ),
              SizedBox(height: 25.0),
              DropdownButtonFormField(
                hint: RichText(
                  text: TextSpan(
                      text: 'Project category ',
                      style: const TextStyle(
                          fontSize: 18, color: Color.fromARGB(144, 64, 7, 87)),
                      children: [
                        TextSpan(
                            text: ' *',
                            style: TextStyle(
                              color: Colors.red,
                            ))
                      ]),
                ),
                items: options
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCat = value as String?;
                  });
                },
                icon: Icon(
                  Icons.arrow_drop_down_circle,
                  color: Color.fromARGB(221, 137, 171, 187),
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(144, 64, 7, 87),
                      width: 2.0,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value == "") {
                    return 'Please select the project catogory.';
                  }
                },
              ),
              SizedBox(height: 25.0),
              TextFormField(
                  maxLength: 40,
                  decoration: InputDecoration(
                    label: RichText(
                      text: TextSpan(
                          text: 'Looking for',
                          style: const TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(144, 64, 7, 87)),
                          children: [
                            TextSpan(
                                text: ' *',
                                style: TextStyle(
                                  color: Colors.red,
                                ))
                          ]),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(144, 64, 7, 87),
                        width: 2.0,
                      ),
                    ),
                  ),
                  controller: _lookingForEditingController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the project team members neded.';
                    }
                  }),
              SizedBox(height: 25.0),
              Scrollbar(
                thumbVisibility: true,
                child: TextFormField(
                    maxLength: 500,
                    maxLines: 3,
                    decoration: InputDecoration(
                      label: RichText(
                        text: TextSpan(
                            text: 'Project description',
                            style: const TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(144, 64, 7, 87)),
                            children: [
                              TextSpan(
                                  text: ' *',
                                  style: TextStyle(
                                    color: Colors.red,
                                  ))
                            ]),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(144, 64, 7, 87),
                          width: 2.0,
                        ),
                      ),
                    ),
                    controller: _descriptionEditingController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the project description.';
                      }

                      return null;
                    }),
              ),
              SizedBox(height: 15),
              SizedBox(
                width: 50,
                height: 50.0,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(144, 64, 7, 87),
                    ),
                    child: Text('Post',
                        style: TextStyle(color: Colors.white, fontSize: 16.0)),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        // for sorting purpose
                        var now = new DateTime.now();

                        _firestore.collection('projects').add({
                          'name': _nameEditingController.text,
                          'location': _startSearchFieldController.text,
                          'description': _descriptionEditingController.text,
                          'category': selectedCat,
                          'lookingFor': _lookingForEditingController.text,
                          'created': now,
                        });
                        //Clear

                        _nameEditingController.clear();
                        _startSearchFieldController.clear();
                        _descriptionEditingController.clear();
                        _lookingForEditingController.clear();
                        selectedCat = "";

                        //sucess message
                        CoolAlert.show(
                          context: context,
                          title: "Success!",
                          confirmBtnColor: Color.fromARGB(144, 64, 7, 87),
                          onConfirmBtnTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Tabs()));
                          },
                          type: CoolAlertType.success,
                          backgroundColor: Color.fromARGB(221, 137, 171, 187),
                          text: "Project posted successfuly",
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
