import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:wefaq/HomePage.dart';
import 'package:wefaq/UserLogin.dart';
import 'package:wefaq/projectsScreen.dart';
import 'bottom_bar_custom.dart';
import 'package:cool_alert/cool_alert.dart';
import 'RJRusers.dart';

class RequestListViewPageProject extends StatefulWidget {
  @override
  _RequestListProject createState() => _RequestListProject();
}

class _RequestListProject extends State<RequestListViewPageProject> {
  final auth = FirebaseAuth.instance;
  late User signedInUser;
  final _firestore = FirebaseFirestore.instance;

  var ProjectTitleList = [];

  var ParticipantEmailList = [];

  var ParticipantNameList = [];
  var tokens = [];
  Status() => ProjectsListViewPage();

  List DisplayProjectOnce() {
    final removeDuplicates = [
      ...{...ProjectTitleList}
    ];
    return removeDuplicates;
  }

  String? Email;
  @override
  void initState() {
    getCurrentUser();
    getRequests();
    super.initState();
  }

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

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

//          .where('participant_email', isNotEqualTo: Email)
  //get all projects
  Future getRequests() async {
    if (Email != null) {
      var fillterd = _firestore
          .collection('joinRequests')
          .where('owner_email', isEqualTo: Email)
          .where('Status', isEqualTo: 'Pending')
          .snapshots();
      await for (var snapshot in fillterd)
        for (var Request in snapshot.docs) {
          setState(() {
            ProjectTitleList.add(Request['project_title']);
            ParticipantEmailList.add(Request['participant_email']);
            //ParticipantNameList.add(Request['participant_name']);
            //tokens.add(Request['participant_token']);
          });
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(tokens);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            }),
        backgroundColor: Color.fromARGB(255, 145, 124, 178),
        title: Text('Received Join Requests',
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
        currentHomeScreen: 1,
        updatePage: () {},
      ),
      body: Scrollbar(
        thumbVisibility: true,
        child: ListView.builder(
          itemCount: DisplayProjectOnce().length,
          itemBuilder: (context, index) {
            return SizedBox(
              height: 90,
              child: GestureDetector(
                child: Card(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 15,
                        ),
                        Row(children: <Widget>[
                          Expanded(
                            flex: 5,
                            child: Text(
                              "   " + DisplayProjectOnce()[index],
                              style: const TextStyle(
                                fontSize: 22,
                                color: Color.fromARGB(159, 32, 3, 43),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 250),
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_forward_ios,
                                color: Color.fromARGB(255, 112, 82, 149),
                                size: 28,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => RequestListViewPage(
                                          projectName: ProjectTitleList[index]
                                              .toString(),
                                        )));
                              },
                            ),
                          )
                        ]),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RequestListViewPage(
                            projectName: ProjectTitleList[index].toString(),
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
