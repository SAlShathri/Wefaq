import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wefaq/AdminNavBar.dart';
import 'package:wefaq/UserLogin.dart';
import 'package:http/http.dart' as http;

import 'AdminEventList.dart';

// Main Stateful Widget Start
class AdminReportedEvent extends StatefulWidget {
  @override
//  AdminReportedEventState createState() => AdminReportedEventState();
  String eventName;

  AdminReportedEvent({required this.eventName});

  @override
  State<AdminReportedEvent> createState() => AdminReportedEventState(eventName);
}

class AdminReportedEventState extends State<AdminReportedEvent> {
  @override
  void initState() {
    getCurrentUser();
    getReportedEvents();
    getFav();
    getProjects();
    super.initState();
  }

  String eventName;

  AdminReportedEventState(this.eventName);

  @override
  void dispose() {
    super.dispose();
  }

  final auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late User signedInUser;

  List<String> Reason = [];
  List<String> Note = [];

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

  var userEmail = [];
  int count = 0;
  String ownerEmail = "";

  Future getProjects() async {
    //clear first
    setState(() {
      ownerEmail = "";
      count = 0;
    });
    await for (var snapshot in _firestore
        .collection('AllEvent')
        .orderBy('created', descending: true)
        .where('name', isEqualTo: eventName)
        .snapshots())
      for (var events in snapshot.docs) {
        setState(() {
          ownerEmail = events['email'].toString();
          count = events['count'];
        });
      }
  }

  Future getFav() async {
    //clear first
    setState(() {
      userEmail = [];
    });
    await for (var snapshot in _firestore
        .collection('FavoriteEvents')
        .where('eventName', isEqualTo: eventName)
        .snapshots())
      for (var events in snapshot.docs) {
        setState(() {
          userEmail.add(events['favoriteEmail']);
        });
      }
  }

  showDialogFunc() {
     CoolAlert.show(
                          context: context,
                          title: "",
                          confirmBtnColor: Color.fromARGB(144, 210, 2, 2),
                          confirmBtnText: 'Delete ',
                             onConfirmBtnTap: () {
                     
                              if (count >= 1) {
                                    for (var i = 0; i < userEmail.length; i++)
                                      FirebaseFirestore.instance
                                          .collection('FavoriteEvents')
                                          .doc(userEmail[i]! +
                                              '-' +
                                              eventName +
                                              '-' +
                                              ownerEmail)
                                          .update({'status': 'inactive'});
                                    FirebaseFirestore.instance
                                        .collection('AllEvent')
                                        .doc(eventName)
                                        .delete();

                                    CoolAlert.show(
                                      context: context,
                                      title:
                                          "the event was deleted successfully ",
                                      confirmBtnColor:
                                          Color.fromARGB(144, 64, 7, 87),
                                      onConfirmBtnTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    adminEventsListViewPage()));
                                      },
                                      type: CoolAlertType.success,
                                      backgroundColor:
                                          Color.fromARGB(221, 212, 189, 227),
                                    );
                                  }
                                  else
                                    CoolAlert.show(
                                      context: context,
                                      title:
                                          "You cannot delete the event because there is no reports on it ",
                                      confirmBtnColor:
                                          Color.fromARGB(144, 64, 7, 87),
                                      onConfirmBtnTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AdminReportedEvent(
                                                        eventName: eventName)));
                                      },
                                      type: CoolAlertType.error,
                                      backgroundColor:
                                          Color.fromARGB(221, 212, 189, 227),
                                    );
                              
                          },
                    
                          type: CoolAlertType.confirm,
                          backgroundColor: Color.fromARGB(221, 212, 189, 227),
                          text:
                              "Are you sure you want to delete event?",
                        );

  }

  Future getReportedEvents() async {
    //clear first
    setState(() {
      Reason = [];
      Note = [];
    });

    await for (var snapshot in _firestore
        .collection('reportedevents')
        .where('reported event name', isEqualTo: eventName)
        .snapshots()) {
      for (var report in snapshot.docs) {
        setState(() {
          Reason.add(report['reason']);
          Note.add(report['note']);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery to get Device Width

    return Column(children: [
      Expanded(
          child: Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  showDialogFunc();
                },
                backgroundColor: Color.fromARGB(255, 206, 53, 53),
                child: const Icon(
                  Icons.delete_outlined,
                  color: Colors.white,
                  size: 35,
                ),
              ),
              bottomNavigationBar: AdminCustomNavigationBar(
                currentHomeScreen: 1,
                updatePage: () {},
              ),
              appBar: AppBar(
                backgroundColor: Color.fromARGB(255, 145, 124, 178),
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
                title: Text('Reports',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    )),
              ),
              //Main List View With Builder
              body: Scrollbar(
                  thumbVisibility: true,
                  child: ListView.builder(
                      //itemCount: tokens.length,
                      itemCount: Reason.length,
                      itemBuilder: (context, index) {
                        // Card Which Holds Layout Of ListView Item

                        return SizedBox(
                          height: 180,
                          child: GestureDetector(
                              child: Card(
                                  color: Color.fromARGB(235, 255, 255, 255),
                                  child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            const SizedBox(height: 16.0),
                                            const Divider(
                                                color: Colors.transparent,
                                                height: 1.0),
                                            const SizedBox(height: 16.0),
                                            Row(children: <Widget>[
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
                                              Text(
                                                Reason[index],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Color.fromARGB(
                                                      212, 82, 10, 111),
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ]),
                                            const SizedBox(height: 16.0),
                                            const Divider(
                                                color: Color.fromARGB(
                                                    255, 156, 185, 182),
                                                height: 1.0),
                                            Expanded(
                                              child: Row(children: <Widget>[
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Icon(
                                                  Icons.event_note_outlined,
                                                  color: Color.fromARGB(
                                                      255, 156, 185, 182),
                                                ),
                                                SizedBox(
                                                  width: 10,
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
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                )
                                              ]),
                                            ),
                                          ]))),
                              ),
                        );
                      }))))
    ]);
  }
}

// This is a block of Model Dialog

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
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
