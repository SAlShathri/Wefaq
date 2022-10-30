import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wefaq/HomePage.dart';
import 'package:wefaq/UserLogin.dart';
import 'package:wefaq/chatDetails.dart';
import 'package:wefaq/chatRoom.dart';
import 'package:wefaq/viewProfileTeamMembers.dart';

class rateTeammates extends StatefulWidget {
  String projectName;
  rateTeammates({
    required this.projectName,
  });
  @override
  _rateTeammates createState() => _rateTeammates(projectName);
}

class _rateTeammates extends State<rateTeammates> {
  String projectName;
  _rateTeammates(this.projectName);
  final auth = FirebaseAuth.instance;
  late User signedInUser;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String? Email;
  var usersNames = [];
  var usersEmails = [];
  var userWhoRated = [];
  var ratings = [];
  var currentUserEmail = FirebaseAuth.instance.currentUser!.email;
  @override
  void initState() {
    getCurrentUser();
    getUsersNames();

    super.initState();
  }

  Future getUsersNames() async {
    if (Email != null) {
      var fillterd = _firestore
          .collection('AllJoinRequests')
          .where('project_title', isEqualTo: projectName)
          .where('Status', isEqualTo: 'Accepted')
          .snapshots();
      await for (var snapshot in fillterd)
        for (var Request in snapshot.docs) {
          setState(() {
            usersNames.add(Request['participant_name'].toString());
            usersEmails.add(Request['participant_email'].toString());
          });
        }
    }
  }

  void getCurrentUser() {
    try {
      final user = auth.currentUser;
      if (user != null) {
        signedInUser = user;
        Email = signedInUser.uid;
        print(signedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_sharp,
              color: Color.fromARGB(255, 85, 85, 85),
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Color.fromARGB(255, 182, 168, 203),
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 70),
            SizedBox(width: 10),
            Text(
              "Rate Teammeate",
              style: TextStyle(color: Colors.grey[800]),
            ),
          ],
        ),
      ),
      body: Scrollbar(
        thumbVisibility: true,
        child: ListView.builder(
          itemBuilder: (context, index) {
            // Card Which Holds Layout Of ListView Item

            return SizedBox(
              height: 100,
              child: Card(
                color: const Color.fromARGB(255, 255, 255, 255),
                //shadowColor: Color.fromARGB(255, 255, 255, 255),
                //  elevation: 7,

                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          Row(children: <Widget>[
                            IconButton(
                                icon: Icon(
                                  Icons.account_circle,
                                  color: Color.fromARGB(255, 85, 85, 85),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                            Text(
                              usersNames[index],
                              style: const TextStyle(
                                fontSize: 19,
                                color: Color.fromARGB(212, 82, 10, 111),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              width: 120,
                            ),
                            Expanded(
                              child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Color.fromARGB(255, 85, 85, 85),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                viewProfileTeamMembers(
                                                    userEmail:
                                                        usersEmails[index],
                                                    projectName: projectName)));
                                  }),
                            ),
                          ]),
                        ],
                      ),
                      Expanded(
                        child: Row(
                          children: <Widget>[],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          itemCount: usersNames.length,
        ),
      ),
    );
  }
}
