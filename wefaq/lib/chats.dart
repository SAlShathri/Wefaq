import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
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

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
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
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        title: Text(
          "Group chat",
          style: TextStyle(
              color: Color.fromARGB(159, 0, 0, 0), fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
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
                            width: 50,
                            height: 50,
                            margin: const EdgeInsets.only(right: 8.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(255, 255, 255, 255),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('assets/images/teamg.png'),
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
                        if (ProjectTitleList.length != 0)
                          if (index < senders.length)
                            if (lastMessage[index]!.contains(
                                'https://firebasestorage.googleapis.com/v0/b/wefaq-5f47b.appspot.com/o/images'))
                              Row(children: [
                                SizedBox(
                                  width: 40,
                                ),
                                if (ProjectTitleList.length != 0)
                                  if (index < senders.length)
                                    if (senders[index] != " ")
                                      Expanded(
                                        child: Text(
                                          "       " +
                                              senders[index] +
                                              ": " +
                                              "Photo",
                                          style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                              ]),
                        if (ProjectTitleList.length != 0)
                          if (index < senders.length)
                            if (lastMessage[index]!.contains(
                                'https://firebasestorage.googleapis.com/v0/b/wefaq-5f47b.appspot.com/o/Recordings'))
                              Row(children: [
                                SizedBox(
                                  width: 40,
                                ),
                                if (ProjectTitleList.length != 0)
                                  if (index < senders.length)
                                    if (senders[index] != " ")
                                      Expanded(
                                        child: Text(
                                          "       " +
                                              senders[index] +
                                              ": " +
                                              "VoiceNote",
                                          style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                              ]),
                        if (ProjectTitleList.length != 0)
                          if (index < senders.length)
                            if (lastMessage[index]!.contains(
                                'https://firebasestorage.googleapis.com/v0/b/wefaq-5f47b.appspot.com/o/files'))
                              Row(children: [
                                SizedBox(
                                  width: 40,
                                ),
                                if (ProjectTitleList.length != 0)
                                  if (index < senders.length)
                                    if (senders[index] != " ")
                                      Expanded(
                                        child: Text(
                                          "       " +
                                              senders[index] +
                                              ": " +
                                              "File",
                                          style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                              ]),
                        if (ProjectTitleList.length != 0)
                          if (index < senders.length)
                            if (senders[index] != " ")
                              if (!lastMessage[index]!.contains('https:'))
                                Row(children: [
                                  SizedBox(
                                    width: 40,
                                  ),
                                  if (ProjectTitleList.length != 0)
                                    if (index < senders.length)
                                      if (senders[index] != " ")
                                        Expanded(
                                          child: Text(
                                            "       " +
                                                senders[index] +
                                                ": " +
                                                lastMessage[index],
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
