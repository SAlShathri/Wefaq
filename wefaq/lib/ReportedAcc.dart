import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wefaq/AdminNavBar.dart';
import 'dart:async';
import 'package:wefaq/UserLogin.dart';

import 'adminViewOtherProfile.dart';


class ReportedAccList extends StatefulWidget {
  @override
  ReportedAccState createState() => ReportedAccState();
}

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}

class ReportedAccState extends State<ReportedAccList> {
  void initState() {
    getCurrentUser();
    getReportedEvents();
    super.initState();
  }

  final auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late User signedInUser;

  List<String> user_who_reporting_List = [];
  List<String> Reason = [];
  List<String> Note = [];
  List<String> status = [];
  List<String> name = [];

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

  Future getReportedEvents() async {
    setState(() {
      user_who_reporting_List = [];
      Reason = [];
      Note = [];
    });

    await for (var snapshot in _firestore
        .collection('reportedUsers')
        .orderBy('created', descending: true)
        .snapshots()) {
      for (var report in snapshot.docs) {
        setState(() {
          user_who_reporting_List.add(report['user_who_reported']);
          Reason.add(report['reason']);
          Note.add(report['note']);
          name.add(report['name']);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: AdminCustomNavigationBar(
          currentHomeScreen: 2,
          updatePage: () {},
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 145, 124, 178),
          title: Text('Reported Accounts',
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
                  showDialogFunc2(context);
                }),
          ],
        ),
        body: Scrollbar(
            thumbVisibility: true,
            child: ListView.builder(
                //itemCount: tokens.length,
                itemCount: user_who_reporting_List.length,
                itemBuilder: (context, index) {
                  // Card Which Holds Layout Of ListView Item

                  return SizedBox(
                    height: 180,
                    child: GestureDetector(
                        child: Card(
                            color: Color.fromARGB(235, 255, 255, 255),
                            child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(width: 10),
                                          Container(
                                            alignment: Alignment.center,
                                            child: Text(name[index],
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      212, 82, 10, 111),
                                                )),
                                          ),
                                          Expanded(
                                              child: SizedBox(
                                            width: 100,
                                          )),
                                          IconButton(
                                              icon: Icon(
                                                Icons.arrow_forward_ios,
                                                color: Color.fromARGB(
                                                    255, 170, 169, 179),
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            adminviewotherprofile(
                                                              userEmail:
                                                                  user_who_reporting_List[
                                                                      index],
                                                            )));
                                              }),
                                        ],
                                      ),
                                      const SizedBox(height: 16.0),
                                      const Divider(
                                          color: Color.fromARGB(
                                              255, 156, 185, 182),
                                          height: 1.0),
                                      const SizedBox(height: 16.0),
                                      Expanded(
                                        child: Row(children: <Widget>[
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Icon(
                                            Icons.report_gmailerrorred,
                                            color: Color.fromARGB(
                                                255, 202, 51, 41),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Report Reason: ",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Color.fromARGB(
                                                  212, 82, 10, 111),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              Reason[index],
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Color.fromARGB(
                                                    212, 82, 10, 111),
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          )
                                        ]),
                                      ),
                                      const SizedBox(height: 16.0),
                                      const Divider(
                                          color: Color.fromARGB(
                                              255, 156, 185, 182),
                                          height: 1.0),
                                      Row(children: <Widget>[
                                        SizedBox(
                                          width: 10,
                                          height: 40,
                                        ),
                                        Icon(
                                          Icons.event_note_outlined,
                                          color: Color.fromARGB(
                                              255, 156, 185, 182),
                                        ),
                                        SizedBox(
                                          width: 10,
                                          height: 40,
                                        ),
                                        Text(
                                          "Report Note: ",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Color.fromARGB(
                                                212, 82, 10, 111),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            Note[index] == ''
                                                ? "No note"
                                                : Note[index],
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Color.fromARGB(
                                                  212, 82, 10, 111),
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        )
                                      ]),
                                    ]))),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => adminviewotherprofile(
                                        userEmail:
                                            user_who_reporting_List[index],
                                      )));
                        }),
                  );
                })));
  }
}

showDialogFunc2(context) {
   CoolAlert.show(
                          context: context,
                          title: "",
                          confirmBtnColor: Color.fromARGB(144, 210, 2, 2),
                          confirmBtnText: 'log out ',
                          //cancelBtnText: 'Delete' ,
                             onConfirmBtnTap: () {                 
                           _signOut();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserLogin()));                            
                          },                    
                          type: CoolAlertType.confirm,
                          backgroundColor: Color.fromARGB(221, 212, 189, 227),
                          text:
                              "Are you sure you want to log out?",
                        );
  
}
