import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wefaq/bottom_bar_custom.dart';
import 'package:wefaq/models/project.dart';
import 'package:wefaq/profile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/link.dart';

// Main Stateful Widget Start
class EventsListViewPage extends StatefulWidget {
  @override
  _ListViewPageState createState() => _ListViewPageState();
}

class _ListViewPageState extends State<EventsListViewPage> {
  @override
  void initState() {
    // TODO: implement initState
    getProjects();
    super.initState();
  }

  final _firestore = FirebaseFirestore.instance;
  @override

  // Title list
  var nameList = [];

  // Description list
  var descList = [];

  // location list
  var locList = [];

  //url list
  var urlList = [];

  //category list
  var categoryList = [];

  //category list
  var dateTimeList = [];

  var TimeList = [];
//get all projects
  Future getProjects() async {
    await for (var snapshot in _firestore
        .collection('events')
        .orderBy('created', descending: true)
        .snapshots())
      for (var events in snapshot.docs) {
        setState(() {
          nameList.add(events['name']);
          descList.add(events['description']);
          locList.add(events['location']);
          urlList.add(events['regstretion url ']);
          categoryList.add(events['category']);
          dateTimeList.add(events['date']);
          TimeList.add(events['time']);

          //  dateTimeList.add(project['dateTime ']);
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery to get Device Width
    double width = MediaQuery.of(context).size.width * 0.6;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // Main List View With Builder
        body: Scrollbar(
          thumbVisibility: true,
          child: ListView.builder(
            itemCount: nameList.length,
            itemBuilder: (context, index) {
              return SizedBox(
                height: 160,
                child: Card(
                  color: Color.fromARGB(255, 255, 255, 255),
                  //shadowColor: Color.fromARGB(255, 255, 255, 255),
                  //  elevation: 7,

                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(children: <Widget>[
                          Text(
                            "      " + nameList[index] + " ",
                            style: TextStyle(
                              fontSize: 17,
                              color: Color.fromARGB(159, 64, 7, 87),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ]),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: <Widget>[
                            Text("     "),
                            const Icon(Icons.location_pin,
                                color: Color.fromARGB(173, 64, 7, 87)),
                            Text(locList[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(221, 81, 122, 140),
                                ))
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text("     "),
                            const Icon(
                              Icons.timelapse_outlined,
                              color: Color.fromARGB(248, 170, 167, 8),
                              size: 21,
                            ),
                            Text(dateTimeList[index] + ' ' + TimeList[index],
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(221, 79, 128, 151),
                                    fontWeight: FontWeight.normal),
                                maxLines: 2,
                                overflow: TextOverflow.clip),
                          ],
                        ),
                        Row(children: <Widget>[
                          SizedBox(
                            width: 160,
                          ),
                          /*const Icon(
                                    Icons.arrow_downward,
                                    color: Color.fromARGB(255, 58, 44, 130),
                                    size: 28,
                                  ),*/
                          TextButton(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'View More',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 90, 46, 144),
                                ),
                              ),
                            ),
                            onPressed: () {
                              showDialogFunc(
                                  context,
                                  nameList[index],
                                  descList[index],
                                  categoryList[index],
                                  locList[index],
                                  dateTimeList[index],
                                  TimeList[index],
                                  urlList[index]);
                            },
                          ),
                          SizedBox(
                            width: 80,
                          ),
                          IconButton(
                              onPressed: () {}, icon: Icon(Icons.star_border))
                        ])
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ), // sc
      ),
    );
  }
}

// This is a block of Model Dialog
showDialogFunc(context, title, desc, category, loc, date, time, urlregstrtion) {
  return showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: Material(
          type: MaterialType.transparency,
          child: Scrollbar(
            thumbVisibility: true,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              padding: EdgeInsets.all(15),
              height: 500,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(230, 64, 7, 87),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    color: Color.fromARGB(255, 74, 74, 74),
                  ),
                  Row(
                    children: <Widget>[
                      const Icon(Icons.location_pin,
                          color: Color.fromARGB(173, 64, 7, 87)),
                      Text(loc,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(230, 64, 7, 87),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    color: Color.fromARGB(255, 102, 102, 102),
                  ),
                  Row(
                    children: <Widget>[
                      const Icon(
                        Icons.timelapse_outlined,
                        color: Color.fromARGB(248, 170, 167, 8),
                        size: 28,
                      ),
                      Text(date,
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(221, 79, 128, 151),
                              fontWeight: FontWeight.normal),
                          maxLines: 2,
                          overflow: TextOverflow.clip),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    color: Color.fromARGB(255, 102, 102, 102),
                  ),
                  Container(
                    // width: 200,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "About Event ",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(230, 64, 7, 87),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    // width: 200,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        desc,
                        style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(144, 64, 7, 87)),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    color: Color.fromARGB(255, 102, 102, 102),
                  ),
                  Container(
                    // width: 200,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Category",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(230, 64, 7, 87),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    // width: 200,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        category,
                        maxLines: 3,
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(144, 64, 7, 87)),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  Center(
                    child: Link(
                        target: LinkTarget.blank,
                        uri: Uri.parse(urlregstrtion),
                        builder: (context, followLink) => ElevatedButton(
                            onPressed: followLink,
                            child: Text(
                              'Registration link',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255)),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(195, 117, 45, 141),
                            ))),
                  ),

                  /* Container(
                    alignment: Alignment.center,
                    height: 40.0,
                    width: 200,
                    margin: EdgeInsets.only(top: 20),
          
                    // width: size.width * 0.5,
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(80.0),
                        gradient: new LinearGradient(colors: [
                          Color.fromARGB(197, 67, 7, 87),
                          Color.fromARGB(195, 117, 45, 141),
                        ])),
                    padding: const EdgeInsets.all(0),
                    child: Text(
                      "Regstrition Link",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 255, 255)),
                      //     textAlign: TextAlign.center,
                      //     style: TextStyle(fontWeight: FontWeight.bold ),
                    ),
                  ),*/
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
