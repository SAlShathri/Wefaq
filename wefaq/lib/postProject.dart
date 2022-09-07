// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:multiselect/multiselect.dart';
import 'package:get/get.dart';
import 'package:google_place/google_place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wefaq/projectsScreen.dart';

import 'bottom_bar_custom.dart';

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

  // Project catogery list
  List<String> options = [
    "AI",
    "Web",
    "iOS",
    "Android",
    "Flutter",
    "React Native"
  ];
  Rx<List<String>> selectedOptionList = Rx<List<String>>([]);
  var selectedOption = ''.obs;

  //Project looking for lis
  List<String> options2 = [
    "Developers",
    "Testers",
    "Designers",
    "Managers",
  ];
  Rx<List<String>> selectedOptionList2 = Rx<List<String>>([]);
  var selectedOption2 = ''.obs;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Post project',
              style: TextStyle(
                  color: Color.fromARGB(144, 64, 7, 87),
                  fontWeight: FontWeight.bold))),
      bottomNavigationBar: CustomNavigationBar(
        currentHomeScreen: 4,
        updatePage: () {},
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Project name",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black87,
                      width: 2.0,
                    ),
                  ),
                ),
                controller: _nameEditingController,
              ),
              SizedBox(height: 25.0),
              Align(
                child: SearchScreen(),
              ),
              TextFormField(
                maxLines: 3,
                decoration: InputDecoration(
                  suffixIcon: _descriptionEditingController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              _descriptionEditingController.clear();
                            });
                          },
                          icon: Icon(Icons.clear_outlined),
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87, width: 2.0),
                  ),
                  labelText: "Project description",
                ),
                controller: _descriptionEditingController,
              ),
              SizedBox(height: 25.0),
              DropDownMultiSelect(
                options: options,
                whenEmpty: 'Select project catogery',
                onChanged: (Value) {
                  selectedOptionList.value = Value;
                  selectedOption.value = '';
                  selectedOptionList.value.forEach((element) {
                    selectedOption.value = selectedOption.value + " " + element;
                  });
                },
                selectedValues: selectedOptionList.value,
              ),
              SizedBox(height: 25.0),
              DropDownMultiSelect(
                options: options2,
                whenEmpty: 'Looking for',
                onChanged: (Value) {
                  selectedOptionList2.value = Value;
                  selectedOption2.value = '';
                  selectedOptionList2.value.forEach((element) {
                    selectedOption2.value =
                        selectedOption2.value + " " + element;
                  });
                },
                selectedValues: selectedOptionList2.value,
              ),
              SizedBox(height: 40.0),
              SizedBox(
                width: 50,
                height: 50.0,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(144, 64, 7, 87),
                    ),
                    child: Text('Post',
                        style: TextStyle(color: Colors.white, fontSize: 16.0)),
                    onPressed: () {
                      if (_nameEditingController.text == "" ||
                          _SearchScreenState._startSearchFieldController.text ==
                              "" ||
                          _descriptionEditingController.text == "" ||
                          selectedOptionList.value.length == 0 ||
                          selectedOptionList2.value.length == 0) {
                        CoolAlert.show(
                          context: context,
                          title: "Missing fields!",
                          confirmBtnColor: Color.fromARGB(255, 201, 166, 216),
                          type: CoolAlertType.info,
                          backgroundColor: Color.fromARGB(255, 222, 201, 231),
                          text: "Please fill out all fields",
                        );
                      } else {
                        _firestore.collection('projects').add({
                          'name': _nameEditingController.text,
                          'location': _SearchScreenState
                              ._startSearchFieldController.text,
                          'description': _descriptionEditingController.text,
                          'category': selectedOptionList.value,
                          'lookingFor': selectedOptionList2.value
                        });
                        //Clear
                        _nameEditingController.clear();
                        _SearchScreenState._startSearchFieldController.clear();
                        _descriptionEditingController.clear();
                        selectedOptionList.value.clear();
                        selectedOptionList2.value.clear();
                        //sucess message
                        CoolAlert.show(
                            context: context,
                            title: "Success!",
                            confirmBtnColor: Color.fromARGB(255, 201, 166, 216),
                            type: CoolAlertType.success,
                            backgroundColor: Color.fromARGB(255, 222, 201, 231),
                            text: "Project posted successfuly");
                        //Show the projects screen

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

//location search widget
class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static final TextEditingController _startSearchFieldController =
      TextEditingController();

  DetailsResult? startPosition;

  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  Timer? _debounce;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String apiKey = 'AIzaSyCkRaPfvVejBlQIAWEjc9klnkqk6olnhuc';
    googlePlace = GooglePlace(apiKey);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      print(result.predictions!.first.description);
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _startSearchFieldController,
          style: TextStyle(fontSize: 14),
          decoration: InputDecoration(
              labelText: 'Project location',
              hintStyle:
                  const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black87, width: 2.0),
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
                  : null),
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
        ),
        SizedBox(height: 10),
        ListView.builder(
            shrinkWrap: true,
            itemCount: predictions.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 202, 186, 232),
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
                  final details = await googlePlace.details.get(placeId);
                  if (details != null && details.result != null && mounted) {
                    setState(() {
                      startPosition = details.result;
                      _startSearchFieldController.text = details.result!.name!;
                      predictions = [];
                    });
                  }
                },
              );
            })
      ],
    );
  }
}
