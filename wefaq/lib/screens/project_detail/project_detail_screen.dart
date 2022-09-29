import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wefaq/ProjectsTapScreen.dart';
import 'package:wefaq/config/colors.dart';
import 'package:wefaq/screens/project_detail/widgets/project_detail_appbar.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:wefaq/projectsScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:wefaq/service/local_push_notification.dart';

class projectDetailScreen extends StatefulWidget {
  String projecName;

  projectDetailScreen({required this.projecName});

  @override
  State<projectDetailScreen> createState() =>
      _projectDetailScreenState(projecName);
}

class _projectDetailScreenState extends State<projectDetailScreen> {
  @override
  void initState() {
    // TODO: implement initState
    getCurrentUser();
    getProjects();
    super.initState();
  }

  String projecName;
  _projectDetailScreenState(this.projecName);

  final TextEditingController _JoiningASController = TextEditingController();
  final TextEditingController _ParticipantNoteController =
      TextEditingController();
  // Title list
  String nameList = "";

  // Description list
  String descList = "";

  // location list
  String locList = "";

  //Looking for list
  String lookingForList = "";

  String Duration = "";

  //category list
  String categoryList = "";

  //project owners emails
  String ownerEmail = "";

  String token = " ";

  var ProjectTitleList = [];

  var ParticipantEmailList = [];

  var ParticipantNameList = [];
  Status() => ProjectsListViewPage();

  List DisplayProjectOnce() {
    final removeDuplicates = [
      ...{...ProjectTitleList}
    ];
    return removeDuplicates;
  }

  final _firestore = FirebaseFirestore.instance;
  late User signedInUser;

  //get all projects
  Future getProjects() async {
    await for (var snapshot in _firestore
        .collection('projects2')
        .where('name', isEqualTo: projecName)
        .snapshots())
      for (var project in snapshot.docs) {
        setState(() {
          nameList = project['name'].toString();
          descList = project['description'].toString();
          locList = project['location'].toString();
          lookingForList = project['lookingFor'].toString();
          categoryList = project['category'].toString();
          token = project['token'].toString();
          ownerEmail = project['email'].toString();
        });
      }
  }

  Future getRequests() async {
    if (signedInUser.email != null) {
      var fillterd = _firestore
          .collection('joinRequests')
          .where('owner_email', isEqualTo: signedInUser.email)
          .where('Status', isEqualTo: 'Pending')
          .snapshots();
      await for (var snapshot in fillterd)
        for (var Request in snapshot.docs) {
          setState(() {
            ProjectTitleList.add(Request['project_title']);
            ParticipantEmailList.add(Request['participant_email']);
            ParticipantNameList.add(Request['participant_name']);
            //tokens.add(Request['participant_token']);
          });
        }
    }
  }

  final auth = FirebaseAuth.instance;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const DetailAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nameList,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8.0),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 35.0,
                            width: 35.0,
                            margin: const EdgeInsets.only(right: 8.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: const DecorationImage(
                                image: AssetImage(
                                    'assets/images/profile_image.jpg'),
                                fit: BoxFit.cover,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0, 4),
                                  blurRadius: 4.0,
                                  color: Colors.black.withOpacity(0.25),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Sara Alshathri',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            height: 32.0,
                            width: 32.0,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(right: 8.0),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.location_pin,
                                color: Color.fromARGB(172, 136, 98, 146)),
                          ),
                          Text(
                            locList,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  const Divider(color: kOutlineColor, height: 1.0),
                  const SizedBox(height: 16.0),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    descList,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: kSecondaryTextColor),
                  ),
                  const SizedBox(height: 16.0),
                  const Divider(color: kOutlineColor, height: 1.0),
                  const SizedBox(height: 16.0),
                  Text(
                    'Category',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16.0),
                  _buildIngredientItem(context, categoryList),
                  const Divider(color: kOutlineColor, height: 1.0),
                  const SizedBox(height: 16.0),
                  Text(
                    'Looking For',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    lookingForList,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: kSecondaryTextColor),
                  ),
                  const SizedBox(height: 16.0),
                  const Divider(color: kOutlineColor, height: 1.0),
                  const SizedBox(height: 16.0),
                  Text(
                    'Duration',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8.0),
                  Row(children: <Widget>[
                    const Icon(
                      Icons.timelapse_outlined,
                      color: Color.fromARGB(172, 136, 98, 146),
                      size: 21,
                    ),
                    Text(
                      ' Two Weeks',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: kSecondaryTextColor),
                    ),
                  ]),
                  const SizedBox(height: 16.0),
                  const Divider(color: kOutlineColor, height: 1.0),
                  const SizedBox(height: 16.0),
                  Text(
                    'Team Members',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10.0),
                  Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 35.0,
                            width: 35.0,
                            margin: const EdgeInsets.only(right: 8.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: const DecorationImage(
                                image:
                                    AssetImage('assets/images/PlaceHolder.png'),
                                fit: BoxFit.cover,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0, 4),
                                  blurRadius: 4.0,
                                  color: Colors.black.withOpacity(0.25),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Raseel',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          SizedBox(
                            width: 130,
                          ),
                          Container(
                            height: 35.0,
                            width: 35.0,
                            margin: const EdgeInsets.only(right: 8.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: const DecorationImage(
                                image:
                                    AssetImage('assets/images/PlaceHolder.png'),
                                fit: BoxFit.cover,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0, 4),
                                  blurRadius: 4.0,
                                  color: Colors.black.withOpacity(0.25),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Nada',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 37.0),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 56,
                    margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom,
                      left: 24,
                      right: 24,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        showDialogFunc(
                          token,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(174, 111, 78, 161),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          )),
                      child: const Text(
                        "JOIN NOW",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  showDialogFunc(
    token,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              padding: const EdgeInsets.all(15),
              height: 350,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      maxLength: 60,
                      decoration: InputDecoration(
                          hintText: "Developer,Designer",
                          hintStyle: TextStyle(
                              color: Color.fromARGB(255, 202, 198, 198)),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          label: RichText(
                            text: TextSpan(
                                text: 'Joining As',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(230, 64, 7, 87)),
                                children: [
                                  TextSpan(
                                      text: ' *',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 20,
                                      ))
                                ]),
                          )),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "required";
                        } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value!) &&
                            !RegExp(r'^[أ-ي]+$').hasMatch(value!)) {
                          return "Only English or Arabic letters";
                        }
                      },
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      maxLength: 150,
                      decoration: InputDecoration(
                          hintText: "Notes are visibale with your request",
                          hintStyle: TextStyle(
                              color: Color.fromARGB(255, 202, 198, 198)),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          label: RichText(
                            text: TextSpan(
                              text: 'Note',
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(230, 64, 7, 87)),
                            ),
                          )),
                      validator: (value) {
                        if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value!) &&
                            !RegExp(r'^[أ-ي]+$').hasMatch(value!)) {
                          return "Only English or Arabic letters";
                        }
                      },
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
                          const Color.fromARGB(174, 111, 78, 161),
                          const Color.fromARGB(174, 111, 78, 161),
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
                        // CoolAlert.show(
                        //   context: context,
                        //   title: "Success!",
                        //   confirmBtnColor: Color.fromARGB(144, 64, 7, 87),
                        //   onConfirmBtnTap: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => projectDetailScreen(
                        //                   projecName: this.projecName,
                        //                 )));
                        //   },
                        //   type: CoolAlertType.success,
                        //   backgroundColor: Color.fromARGB(221, 212, 189, 227),
                        //   text: "Your join request is sent successfuly",
                        // );
                        CoolAlert.show(
                          context: context,
                          title: "Success!",
                          confirmBtnColor: Color.fromARGB(174, 111, 78, 161),
                          onConfirmBtnTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProjectsTabs()));
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
                            .doc(nameList + '-' + signedInUser.email!)
                            .set({
                          'project_title': nameList,
                          'participant_email': signedInUser.email,
                          'owner_email': ownerEmail,
                          'participant_name':
                              FirebaseAuth.instance.currentUser!.displayName,
                          'participant_token': token_Participant,
                          'Status': 'Pending',
                          'Participant_note': _ParticipantNoteController.text,
                          'joiningAs': _JoiningASController.text
                        });
                        _JoiningASController.clear();
                        _ParticipantNoteController.clear();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIngredientItem(
    BuildContext context,
    String title,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            height: 24.0,
            width: 24.0,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(right: 8.0),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 237, 227, 255),
            ),
            child: const Icon(
              Icons.check,
              color: Color.fromARGB(172, 136, 98, 146),
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

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

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}
