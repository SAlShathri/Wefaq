
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wefaq/UserLogin.dart';
import 'package:http/http.dart' as http;

class ResolvedEventsList extends StatefulWidget {
  @override
  ResolvedEventsState createState() => ResolvedEventsState();
}

class ResolvedEventsState extends State<ResolvedEventsList> {
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
        .where('status', isEqualTo: "resolved")
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

    return Column(children: [
      Expanded(
          child: Scaffold(

              //Main List View With Builder
              body: Scrollbar(
                  thumbVisibility: true,
                  child: ListView.builder(
                      itemCount: EventnameList.length,
                      itemBuilder: (context, index) {
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
                                              SizedBox(
                                                width: 10,
                                                height: 50,
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                child:
                                                    Text(EventnameList[index],
                                                        style: const TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color.fromARGB(
                                                              212, 82, 10, 111),
                                                        )),
                                              ),
                                              SizedBox(
                                                //width: 100,
                                                height: 30,
                                              )
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
                  height: 150,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // Code for acceptance role
                      Row(children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            child: Text(
                              " Are you sure you want to log out? ",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(159, 64, 7, 87),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                            
                            },
                          ),
                        ),                    
                      ]),
                      SizedBox(
                        height: 35,
                      ),
                      
                      Row(
                        children: <Widget>[
                          Text("   "),
                          Text("     "),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
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
                                    Color.fromARGB(144, 176, 175, 175),
                                    Color.fromARGB(144, 176, 175, 175),
                                  ])),
                              padding: const EdgeInsets.all(0),
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 40),
                            child: ElevatedButton(
                              onPressed: () {
                                _signOut();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserLogin()));                          
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
                                  "Log out",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )));
      });
}
