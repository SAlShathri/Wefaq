// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';
import 'package:get/get.dart';
import 'package:google_place/google_place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                hintText: "Project name",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black87,
                    width: 2.0,
                  ),
                ),
              ),
              controller: _nameEditingController,
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(0),
              child: SearchScreen(),
            ),
            TextFormField(
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black87, width: 2.0),
                ),
                hintText: "Project description",
              ),
              controller: _descriptionEditingController,
            ),
            SizedBox(height: 20.0),
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
            SizedBox(height: 20.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Looking for',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 5.0,
                  runSpacing: 3.0,
                  children: const <Widget>[
                    filterChipWidget(chipName: 'Developers'),
                    filterChipWidget(chipName: 'Testers'),
                    filterChipWidget(chipName: 'Designers'),
                    filterChipWidget(chipName: 'Managers'),
                  ],
                ),
              ),
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
                  onPressed: () {
                    _firestore.collection('projects').add({
                      'name': _nameEditingController.text,
                      'description': _descriptionEditingController.text,
                    });
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

//Catogray ChipWidget
class filterChipWidget extends StatefulWidget {
  final String chipName;

  const filterChipWidget({Key? key, required this.chipName}) : super(key: key);

  @override
  _filterChipWidgetState createState() => _filterChipWidgetState();
}

class _filterChipWidgetState extends State<filterChipWidget> {
  var _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.chipName),
      labelStyle: TextStyle(
          color: Color(0xff6200ee),
          fontSize: 14.0,
          fontWeight: FontWeight.normal),
      selected: _isSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: Color(0xffededed),
      onSelected: (isSelected) {
        setState(() {
          _isSelected = isSelected;
        });
      },
      selectedColor: Color(0xffeadffd),
    );
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
              hintText: 'Project location',
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
