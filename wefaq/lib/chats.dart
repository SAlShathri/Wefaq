import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:wefaq/HomePage.dart';
import 'package:wefaq/UserLogin.dart';
import 'package:wefaq/chatDetails.dart';
import 'package:wefaq/chatRoom.dart';
import 'bottom_bar_custom.dart';
import 'package:flutter/cupertino.dart';

class chatScreen extends StatefulWidget {
  @override
  _chatScreenState createState() => _chatScreenState();
}

class _chatScreenState extends State<chatScreen> {
  final auth = FirebaseAuth.instance;
  late User signedInUser;
  final _firestore = FirebaseFirestore.instance;

  var ProjectTitleList = HomeScreenState.ProjectTitleList;
  var Last = [];
  var lastMessage = [];
  var senders = [];
  String? Email;
  @override
  void initState() {
    getLastMessage();
    super.initState();
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  var fillterd;
  Future getLastMessage() async {
    for (var i = 0; i < ProjectTitleList.length; i++)
      setState(() {
        add(ProjectTitleList[i].toString());
      });
  }

  add(String projectName) async {
    fillterd = _firestore
        .collection(projectName + " project")
        .orderBy("time", descending: true)
        .limit(1)
        .snapshots();
    bool enterTheLoop = false;
    await for (var snapshot in fillterd) {
      for (var message in snapshot.docs) {
        setState(() {
          lastMessage.add(message['message']);
          senders.add(message['senderName']);
          enterTheLoop = true;
        });
      }
      if (!enterTheLoop) {
        lastMessage.add(" ");
        senders.add(" ");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 145, 124, 178),
        title: Text("Group chat",
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.white,
            )),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.logout,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              onPressed: () {
                _signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserLogin()));
              }),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentHomeScreen: 4,
        updatePage: () {},
      ),
      body: Scrollbar(
        thumbVisibility: true,
        child: ListView.builder(
          itemCount: ProjectTitleList.length,
          itemBuilder: (context, index) {
            return SizedBox(
              height: 85,
              child: GestureDetector(
                child: Card(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10.0),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color.fromARGB(255, 143, 132, 159),
                                  width: 0),
                              shape: BoxShape.circle,
                              color: Color.fromARGB(255, 255, 255, 255),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('assets/images/g.png'),
                              ),
                            ),
                          ),
                          Text(
                            " " + ProjectTitleList[index] + " Project",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(159, 35, 86, 84),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Expanded(child: SizedBox()),
                          SizedBox(
                            height: 20,
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_forward_ios,
                                color: Color.fromARGB(255, 112, 82, 149),
                                size: 20,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                              projectName:
                                                  ProjectTitleList[index],
                                            )));
                              },
                            ),
                          ),
                        ]),
                        Row(children: [
                          SizedBox(
                            width: 40,
                          ),
                          Expanded(
                            child: Text(
                              senders[index] + ": " + lastMessage[index],
                              style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatScreen(
                                projectName: ProjectTitleList[index],
                              )));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
