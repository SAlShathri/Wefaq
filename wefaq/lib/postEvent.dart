// ignore_for_file: prefer_const_constructors

import 'package:intl/intl.dart';
import 'package:wefaq/TabScreen.dart';
import 'package:wefaq/bottom_bar_custom.dart';
import 'dart:async';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:multiselect/multiselect.dart';
import 'package:get/get.dart';
import 'package:google_place/google_place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wefaq/projectsScreen.dart';

class PostEvent extends StatefulWidget {
  const PostEvent({Key? key}) : super(key: key);

  @override
  State<PostEvent> createState() => _PostEventState();
}

class _PostEventState extends State<PostEvent> {
  final _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _descriptionEditingController =
      TextEditingController();
  final TextEditingController _lookingForEditingController =
      TextEditingController();
  static final TextEditingController _startSearchFieldController =
      TextEditingController();
  DateTime dateTime = DateTime.now();

  final TextEditingController _urlEditingController = TextEditingController();

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
                    // Log out
                  }),
            ],
            backgroundColor: Color.fromARGB(255, 182, 168, 203),
            title: Text('Post Event',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ))),
        bottomNavigationBar: CustomNavigationBar(
          currentHomeScreen: 2,
          updatePage: () {},
        ),
        body: Scrollbar(
          child: Stack(
            children: [
              Form(
                key: _formKey,
                child: ListView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
                  children: <Widget>[
                    TextFormField(
                        maxLength: 20,
                        decoration: InputDecoration(
                          labelText: "Event Name",
                          labelStyle: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(144, 64, 7, 87)),
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
                            return 'Please enter the Event Name';
                          }
                        }),
                    SizedBox(height: 20.0),
                    TextFormField(
                        controller: _startSearchFieldController,
                        decoration: InputDecoration(
                            labelText: 'Search Event Location',
                            labelStyle: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(144, 64, 7, 87)),
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
                            suffixIcon: _startSearchFieldController
                                    .text.isNotEmpty
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
                          _debounce =
                              Timer(const Duration(milliseconds: 1000), () {
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
                            return 'Please enter the Event location.';
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
                                backgroundColor:
                                    Color.fromARGB(221, 137, 171, 187),
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

                    SizedBox(height: 20.0),

                    DropdownButtonFormField(
                      hint: Text(
                        "Select event catogory",
                        style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(167, 73, 1, 102)),
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
                          return 'Please select the event catogory.';
                        }
                      },
                    ),
                    const SizedBox(height: 15.0),

                    Text(
                      '${dateTime.day}/${dateTime.month}/${dateTime.year} - ${dateTime.hour}:${dateTime.minute}',
                      style: const TextStyle(
                          fontSize: 18, color: Color.fromARGB(255, 58, 86, 96)),
                    ),
                    //Date and Time8
                    //Date and Time
                    const SizedBox(height: 10.0),
                    ElevatedButton(
                      child: const Text('Select Date and Time',
                          style: TextStyle(fontSize: 16)),
                      onPressed: () async {
                        DateTime? newDate = await showDatePicker(
                            context: context,
                            initialDate: dateTime,
                            firstDate: DateTime(2022),
                            lastDate: DateTime(2100));
                        if (newDate == null) return;

                        TimeOfDay? newTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(
                              hour: dateTime.hour, minute: dateTime.minute),
                        );
                        if (newTime == null) return;

                        setState(() {
                          dateTime = newDate;
                        });
                      },
                    ), //URL
                    const SizedBox(height: 20.0),
                    TextFormField(
                        decoration: InputDecoration(
                          labelText: "Regstrition URL",
                          labelStyle: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(144, 64, 7, 87)),
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
                        controller: _urlEditingController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the Regstrition URL';
                          }
                        }),

                    SizedBox(height: 25.0),
                    Scrollbar(
                      thumbVisibility: true,
                      child: TextFormField(
                          maxLength: 500,
                          maxLines: 3,
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
                            labelText: "Event description",
                            labelStyle: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(144, 64, 7, 87)),
                          ),
                          controller: _descriptionEditingController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the Event description.';
                            }

                            return null;
                          }),
                    ),

                    SizedBox(
                      width: 50,
                      height: 50.0,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(144, 64, 7, 87),
                          ),
                          child: Text('Post',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0)),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                              // for sorting purpose
                              var now = new DateTime.now();
                              var formatter = new DateFormat('yyyy-MM-dd');
                              String formattedDate = formatter.format(now);

                              _firestore.collection('events').add({
                                'name': _nameEditingController.text,
                                'location': _startSearchFieldController.text,
                                'description':
                                    _descriptionEditingController.text,
                                'category': selectedCat,
                                'regstretion url ': _urlEditingController.text,
                                'date and time': dateTime.toString(),
                                'created': formattedDate,
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
                                backgroundColor:
                                    Color.fromARGB(221, 137, 171, 187),
                                text: "Event posted successfuly",
                              );
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
