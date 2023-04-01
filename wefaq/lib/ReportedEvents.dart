import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wefaq/AdminEventDetails.dart';
import 'package:wefaq/UserLogin.dart';
import 'package:http/http.dart' as http;

// Main Stateful Widget Start
class ReportedEventsList extends StatefulWidget {
  @override
  ReportedEventsState createState() => ReportedEventsState();
}

class ReportedEventsState extends State<ReportedEventsList> {
  @override
  void initState() {
    getCurrentUser();
    getReportedEvents();
    super.initState();
  }

  final auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late User signedInUser;

  List<String> EventnameList = [];
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

  Future getReportedEvents() async {
    setState(() {
      EventnameList = [];
      Reason = [];
      Note = [];
    });

    await for (var snapshot in _firestore
        .collection('reportedevents')
        .orderBy('reported event name')
        .where('status', isEqualTo: "new")
        .snapshots()) {
      for (var report in snapshot.docs) {
        setState(() {
          EventnameList.add(report['reported event name']);
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

              //Main List View With Builder
              body: Scrollbar(
                  thumbVisibility: true,
                  child: ListView.builder(
                      //itemCount: tokens.length,
                      itemCount: EventnameList.length,
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
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(width: 10),
                                                Container(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      EventnameList[index],
                                                      style: const TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                                  AdmineventDetailScreen(
                                                                      eventName:
                                                                          EventnameList[
                                                                              index])));
                                                    }),
                                              ],
                                            ),
                                            const Divider(
                                                color: Color.fromARGB(
                                                    255, 156, 185, 182),
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
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AdmineventDetailScreen(
                                              eventName: EventnameList[index],
                                            )));
                              }),
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
