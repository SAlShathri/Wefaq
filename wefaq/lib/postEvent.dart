// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:multiselect/multiselect.dart';
import 'package:get/get.dart';
import 'package:wefaq/bottom_bar_custom.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';

class PostEvent extends StatefulWidget {
  const PostEvent({Key? key}) : super(key: key);

  @override
  State<PostEvent> createState() => _PostEventState();
}

class _PostEventState extends State<PostEvent> {
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _descriptionEditingController =
      TextEditingController();
  List<String> options = [
    "AI",
    "Web",
    "iOS",
    "Android",
    "Flutter",
    "React Native",
    "UI/UX"
  ];
  Rx<List<String>> selectedOptionList = Rx<List<String>>([]);
  var selectedOption = ''.obs;

  late String _chosenValue;
  DateTime dateTime = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Color.fromARGB(221, 137, 171, 187),
            title: Text('Post event',
                style: TextStyle(
                    color: Color.fromARGB(144, 64, 7, 87),
                    fontWeight: FontWeight.bold))),
        bottomNavigationBar: CustomNavigationBar(
          currentHomeScreen: 2,
          updatePage: () {},
        ),
        body: Container(
          // decoration: BoxDecoration(
          //     image: DecorationImage(
          //         image: AssetImage('images/backgroundPost.png'),
          //         fit: BoxFit.cover)),
          child: Stack(
            children: [
              Form(
                key: _formKey,
                child: ListView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
                  children: <Widget>[
                    SizedBox(height: 50.0),

                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Event Name",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(221, 87, 170, 194),
                                width: 2.0)),
                      ),
                      controller: _nameEditingController,
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(221, 163, 20, 20),
                                width: 2.0)),
                        labelText: "Event Description",
                      ),
                      controller: _descriptionEditingController,
                    ),
                    /*
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: SearchScreen(),
                ),*/

                    SizedBox(height: 20.0),

                    DropDownMultiSelect(
                      options: options,
                      whenEmpty: 'Select project catogery',
                      onChanged: (Value) {
                        selectedOptionList.value = Value;
                        selectedOption.value = '';
                        selectedOptionList.value.forEach((element) {
                          selectedOption.value =
                              selectedOption.value + " " + element;
                        });
                      },
                      selectedValues: selectedOptionList.value,
                    ),
                    const SizedBox(height: 15.0),
                    /* Text(
                  '${dateTime.day}/${dateTime.month}/${dateTime.year}-${dateTime.hour}:${dateTime.minute}',
                  style: const TextStyle(fontSize: 20),
                ), //Date and Time8*/
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
                        labelText: "Registration url",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(221, 87, 170, 194),
                                width: 2.0)),
                      ),
                      controller: _nameEditingController,
                    ),
                    SizedBox(height: 20.0),
                    SizedBox(
                      width: double.infinity,
                      height: 50.0,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 113, 43, 143)),
                          child: Text('Post',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 20.0)),
                          onPressed: () {}),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

//location search widget
class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _startSearchFieldController = TextEditingController();

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
          style: TextStyle(fontSize: 16),
          decoration: InputDecoration(
              hintText: 'Project location',
              hintStyle:
                  const TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
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
                  backgroundColor: Color.fromARGB(255, 215, 189, 226),
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
