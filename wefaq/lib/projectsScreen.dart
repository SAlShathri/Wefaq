import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wefaq/TabScreen.dart';
import 'package:wefaq/bottom_bar_custom.dart';
import 'package:wefaq/models/project.dart';
import 'package:wefaq/models/user.dart';
import 'package:wefaq/service/local_push_notification.dart';
import 'package:http/http.dart' as http;

// Main Stateful Widget Start
class ProjectsListViewPage extends StatefulWidget {
  @override
  _ListViewPageState createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ProjectsListViewPage> {
  @override
  void initState() {
    // TODO: implement initState

    getCurrentUser();
    getProjects();

    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.display(event);
    });

    super.initState();
  }

  final auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late User signedInUser;

  // Title list
  var nameList = [];

  // Description list
  var descList = [];

  // location list
  var locList = [];

  //Looking for list
  var lookingForList = [];

  var Duration = [];

  //category list
  var categoryList = [];

  //notification tokens
  var tokens = [];

  //project owners emails
  var ownerEmail = [];

  String? Email;
  void getCurrentUser() {
    try {
      final user = auth.currentUser;
      if (user != null) {
        signedInUser = user;
        Email = signedInUser.email;
        print(signedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  //get all projects
  Future getProjects() async {
    if (Email != null) {
      var fillterd = _firestore
          .collection('projects')
          .orderBy('created', descending: true)
          .snapshots();
      await for (var snapshot in fillterd)
        for (var project in snapshot.docs) {
          setState(() {
            nameList.add(project['name']);
            descList.add(project['description']);
            locList.add(project['location']);
            lookingForList.add(project['lookingFor']);
            categoryList.add(project['category']);
            tokens.add(project['token']);
            ownerEmail.add(project['email']);
          });
        }
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
              // Card Which Holds Layout Of ListView Item
              return SizedBox(
                height: 195,
                child: Card(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  //shadowColor: Color.fromARGB(255, 255, 255, 255),
                  //  elevation: 7,

                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(children: <Widget>[
                          IconButton(
                            icon: const Icon(
                              Icons.account_circle,
                              color: Color.fromARGB(255, 112, 82, 149),
                              size: 52,
                            ),
                            onPressed: () {
                              // do something
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Text(
                              '',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 126, 134, 135)),
                            ),
                          )
                        ]),
                        Row(children: <Widget>[
                          Text(
                            "      " + nameList[index] + " ",
                            style: const TextStyle(
                              fontSize: 17,
                              color: Color.fromARGB(159, 64, 7, 87),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ]),
                        Row(
                          children: <Widget>[
                            const Text("     "),
                            const Icon(Icons.location_pin,
                                color: Color.fromARGB(173, 64, 7, 87)),
                            Text(locList[index],
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(221, 81, 122, 140),
                                ))
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            const Text("     "),
                            const Icon(
                              Icons.search,
                              color: Color.fromARGB(248, 170, 167, 8),
                              size: 28,
                            ),
                            Text(lookingForList[index],
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(221, 79, 128, 151),
                                    fontWeight: FontWeight.normal),
                                maxLines: 2,
                                overflow: TextOverflow.clip),
                          ],
                        ),
                        Expanded(
                            child: //Text("                              "),
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
                                lookingForList[index],
                                tokens[index],
                                ownerEmail[index],
                                signedInUser);
                          },
                        ))
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// This is a block of Model Dialog
showDialogFunc(context, title, desc, category, loc, lookingFor, token,
    ownerEmail, signedInUser) {
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
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              padding: const EdgeInsets.all(15),
              height: 500,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(230, 64, 7, 87),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    color: Color.fromARGB(255, 74, 74, 74),
                  ),
                  Row(
                    children: <Widget>[
                      const Icon(Icons.location_pin,
                          color: Color.fromARGB(173, 64, 7, 87)),
                      Text(loc,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(230, 64, 7, 87),
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(
                    color: Color.fromARGB(255, 102, 102, 102),
                  ),
                  Row(
                    children: <Widget>[
                      const Icon(
                        Icons.search,
                        color: Color.fromARGB(248, 170, 167, 8),
                        size: 25,
                      ),
                      Text(lookingFor,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(230, 64, 7, 87),
                              fontWeight: FontWeight.normal),
                          maxLines: 2,
                          overflow: TextOverflow.clip),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(
                    color: Color.fromARGB(255, 102, 102, 102),
                  ),
                  Container(
                    // width: 200,
                    child: const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "About Project",
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
                        style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(144, 64, 7, 87)),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(
                    color: Color.fromARGB(255, 102, 102, 102),
                  ),
                  Container(
                    // width: 200,
                    child: const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Project Duration",
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
                        "",
                        style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(144, 64, 7, 87)),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(
                    color: Color.fromARGB(255, 102, 102, 102),
                  ),
                  Container(
                    // width: 200,
                    child: const Align(
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
                        style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(144, 64, 7, 87)),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 40.0,
                    width: 100,
                    margin: const EdgeInsets.only(top: 10),

                    // width: size.width * 0.5,
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(80.0),
                        gradient: new LinearGradient(colors: [
                          const Color.fromARGB(197, 67, 7, 87),
                          const Color.fromARGB(195, 117, 45, 141),
                        ])),
                    padding: const EdgeInsets.all(0),
                    child: TextButton(
                      child: const Text(
                        "Join",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 255, 255)),
                        //     textAlign: TextAlign.center,
                        //     style: TextStyle(fontWeight: FontWeight.bold ),
                      ),
                      onPressed: () async {
                        //send a notification to the one who posted the project
                        sendNotification(
                            "You received a join request on your project!",
                            token);
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
                          backgroundColor: Color.fromARGB(221, 212, 189, 227),
                          text: "Your join request is sent successfuly",
                        );

                        //saving the request in join request collection
                        String? token_Participant =
                            await FirebaseMessaging.instance.getToken();
                        FirebaseFirestore.instance
                            .collection('joinRequests')
                            .add({
                          'project_title': title,
                          'participant_email': signedInUser.email,
                          'owner_email': ownerEmail,
                          'participant_token': token_Participant,
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

//Notification

void sendNotification(String title, String token) async {
  final data = {
    'click_action': 'FLUTTER_NOTIFICATION_CLICK',
    'id': '1',
    'status': 'done',
    'message': title,
  };

  try {
    http.Response response =
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization':
                  'key=AAAAshcbmas:APA91bGwyZZKhGUguFmek5aalqcySgs3oKgJmra4oloSpk715ijWkf4itCOuGZbeWbPBmHWKBpMkddsr1KyEq6uOzZqIubl2eDs7lB815xPnQmXIEErtyG9wpR9Q4rXdzvk4w6BvGQdJ'
            },
            body: jsonEncode(<String, dynamic>{
              'notification': <String, dynamic>{
                'title': title,
                'body': 'You received a join request on your project!'
              },
              'priority': 'high',
              'data': data,
              'to': '$token'
            }));

    if (response.statusCode == 200) {
      print("Yeh notificatin is sended");
    } else {
      print("Error");
    }
  } catch (e) {}
}
