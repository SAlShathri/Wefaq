import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wefaq/UserLogin.dart';
import 'package:wefaq/projectsScreen.dart';
import 'bottom_bar_custom.dart';
import 'package:cool_alert/cool_alert.dart';

class RequestListViewPage extends StatefulWidget {
  @override
  _RequestListState createState() => _RequestListState();
}

class _RequestListState extends State<RequestListViewPage> {
  final auth = FirebaseAuth.instance;
  late User signedInUser;
  final _firestore = FirebaseFirestore.instance;

  var ProjectTitleList = [];

  var ParticipantEmailList = [];

  var ParticipantNameList = [];
  var tokens = [];

  Status() => ProjectsListViewPage();

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
            ParticipantNameList.add(Request['participant_name']);
            tokens.add(Request['participant_token']);
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
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 145, 124, 178),
        title: Text('"Project name"',
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
          itemCount: ProjectTitleList.length,
          itemBuilder: (context, index) {
            return SizedBox(
              height: 100,
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
                            flex: 3,
                            child: IconButton(
                              icon: const Icon(
                                Icons.account_circle,
                                color: Color.fromARGB(255, 112, 82, 149),
                                size: 52,
                              ),
                              onPressed: () {
                                // go to participant's profile
                              },
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: GestureDetector(
                              child: Text(
                                " " + ParticipantNameList[index] + " ",
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(159, 64, 7, 87),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onTap: () {
                                // go to participant's profile
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 140),
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_forward,
                                color: Color.fromARGB(255, 112, 82, 149),
                                size: 35,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RequestListViewPage()));
                              },
                            ),
                          )
                        ]),

                        ////////////// accept/decline ------------------------------------------
                        /* Row(
                          children: <Widget>[
                            Text("   "),
                            Container(
                              margin: EdgeInsets.only(left: 120),
                              child: ElevatedButton(
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('joinRequests')
                                      .doc(ProjectTitleList[index] +
                                          '-' +
                                          ParticipantEmailList[index])
                                      .update({'Status': 'Accepted'});
              
                                  CoolAlert.show(
                                    context: context,
                                    title: "Success!",
                                    confirmBtnColor:
                                        Color.fromARGB(144, 64, 6, 87),
                                    type: CoolAlertType.success,
                                    backgroundColor:
                                        Color.fromARGB(221, 212, 189, 227),
                                    text: "You have accepted " +
                                        ParticipantNameList[index] +
                                        " to be part of your team.",
                                    confirmBtnText: 'Done',
                                    onConfirmBtnTap: () {
                                      //send join requist
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RequestListViewPage()));
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  surfaceTintColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(80.0)),
                                  padding: const EdgeInsets.all(0),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 40.0,
                                  width: 100,
                                  decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.circular(9.0),
                                      gradient: new LinearGradient(colors: [
                                        Color.fromARGB(144, 7, 133, 57),
                                        Color.fromARGB(144, 7, 133, 57),
                                      ])),
                                  padding: const EdgeInsets.all(0),
                                  child: Text(
                                    "Accept",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255)),
                                  ),
                                ),
                              ),
                            ),
                            Text("     "),
                            ElevatedButton(
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('joinRequests')
                                    .doc(ProjectTitleList[index] +
                                        '-' +
                                        ParticipantEmailList[index])
                                    .update({'Status': 'Declined'});
                                CoolAlert.show(
                                  context: context,
                                  title: "Success!",
                                  confirmBtnColor: Color.fromARGB(144, 64, 6, 87),
                                  type: CoolAlertType.success,
                                  backgroundColor:
                                      Color.fromARGB(221, 212, 189, 227),
                                  text: "You have rejected " +
                                      ParticipantNameList[index] +
                                      ", hope you find a better match.",
                                  confirmBtnText: 'Done',
                                  onConfirmBtnTap: () async {
                                    //saving the request in join request collection
              
                                    //send join requist
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RequestListViewPage()));
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                surfaceTintColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(80.0)),
                                padding: const EdgeInsets.all(0),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                height: 40.0,
                                width: 100,
                                decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.circular(9.0),
                                    gradient: new LinearGradient(colors: [
                                      Color.fromARGB(144, 210, 2, 2),
                                      Color.fromARGB(144, 210, 2, 2)
                                    ])),
                                padding: const EdgeInsets.all(0),
                                child: Text(
                                  "Decline",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromARGB(255, 255, 255, 255)),
                                ),
                              ),
                            ),
                          ],
                        )*/
                      ],
                    ),
                  ),
                ),
                onTap: () {},
              ),
            );
          },
        ),
      ),
    );
  }
}
