import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wefaq/RJRprojects.dart';
import 'package:wefaq/UserLogin.dart';
import 'bottom_bar_custom.dart';

class chatScreen extends StatefulWidget {
  @override
  _chatScreenState createState() => _chatScreenState();
}

class _chatScreenState extends State<chatScreen> {
  final auth = FirebaseAuth.instance;
  late User signedInUser;
  final _firestore = FirebaseFirestore.instance;

  var ProjectTitleList = [];

  String? Email;
  @override
  void initState() {
    getCurrentUser();
    getProjectTitle();
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

  Future getProjectTitle() async {
    if (Email != null) {
      var fillterd = _firestore
          .collection('AllJoinRequests')
          .where('owner_email', isEqualTo: Email)
          .where('Status', isEqualTo: 'Accepted')
          .snapshots();
      await for (var snapshot in fillterd)
        for (var Request in snapshot.docs) {
          setState(() {
            ProjectTitleList.add(Request['project_title']);
          });
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RequestListViewPageProject()));
            }),
        backgroundColor: Color.fromARGB(255, 145, 124, 178),
        title: Text(ProjectTitleList.first,
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
                            IconButton(
                              icon: const Icon(
                                Icons.account_circle,
                                color: Color.fromARGB(255, 112, 82, 149),
                                size: 52,
                              ),
                              onPressed: () {
                                // go to participant's profile
                              },
                            ),
                            Text(
                              " " + ProjectTitleList[index] + " Project",
                              style: const TextStyle(
                                fontSize: 24,
                                color: Color.fromARGB(159, 35, 86, 84),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 140),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Color.fromARGB(255, 112, 82, 149),
                                    size: 28,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            )
                          ]),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {}),
            );
          },
        ),
      ),
    );
  }
}
