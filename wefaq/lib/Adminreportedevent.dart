import 'dart:convert';
import 'dart:math';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/route_manager.dart';
import 'package:wefaq/AdminEventDetails.dart';
import 'package:wefaq/AdminHomePage.dart';
import 'package:wefaq/AdminNavBar.dart';
import 'package:wefaq/AdminProjectDetails.dart';
import 'package:wefaq/ProjectsTapScreen.dart';
import 'package:wefaq/UserLogin.dart';
import 'package:wefaq/screens/detail_screens/project_detail_screen.dart';
import 'package:wefaq/service/local_push_notification.dart';
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
      //favoriteEmail = "";
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

          //  dateTimeList.add(project['dateTime ']);
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
                        //  cancelBtnColor: Colors.black,
                        //  cancelBtnTextStyle: TextStyle(color: Color.fromARGB(255, 237, 7, 7), fontWeight:FontWeight.w600,fontSize: 18.0),
                          confirmBtnText: 'Delete ',
                          //cancelBtnText: 'Delete' ,
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

                                  /*FirebaseFirestore.instance
                                      .collection('FavoriteEvents')
                                      .doc(favoriteEmail +
                                          "-" +
                                          eventName +
                                          "-" +
                                          ownerEmail)
                                      .delete();*/
                                  else
                                    CoolAlert.show(
                                      context: context,
                                      title:
                                          "You cannot delete the event because the number of reports is less than 3",
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
    // return showDialog(
    //     context: context,
    //     builder: (context) {
    //       return Center(
    //           child: Material(
    //               type: MaterialType.transparency,
    //               child: Container(
    //                 decoration: BoxDecoration(
    //                   borderRadius: BorderRadius.circular(10),
    //                   color: const Color.fromARGB(255, 255, 255, 255),
    //                 ),
    //                 padding: const EdgeInsets.all(15),
    //                 height: 190,
    //                 width: MediaQuery.of(context).size.width * 0.85,
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.center,
    //                   children: <Widget>[
    //                     // Code for acceptance role

    //                     Row(children: <Widget>[
    //                       Expanded(
    //                         flex: 2,
    //                         child: GestureDetector(
    //                           child: Text(
    //                             "Are you sure you want to delete event?",
    //                             style: const TextStyle(
    //                               fontSize: 18,
    //                               color: Color.fromARGB(159, 64, 7, 87),
    //                               fontWeight: FontWeight.bold,
    //                             ),
    //                           ),
    //                           onTap: () {
    //                             // go to participant's profile
    //                           },
    //                         ),
    //                       ),
    //                       // const SizedBox(
    //                       //   height: 10,
    //                       // ),
    //                     ]),
    //                     SizedBox(
    //                       height: 35,
    //                     ),
    //                     //----------------------------------------------------------------------------
    //                     Row(
    //                       children: <Widget>[
    //                         Text(""),
    //                         Text("        "),
    //                         ElevatedButton(
    //                           onPressed: () async {
    //                             Navigator.pop(context);
    //                           },
    //                           style: ElevatedButton.styleFrom(
    //                             surfaceTintColor: Colors.white,
    //                             shape: RoundedRectangleBorder(
    //                                 borderRadius: BorderRadius.circular(80.0)),
    //                             padding: const EdgeInsets.all(0),
    //                           ),
    //                           child: Container(
    //                             alignment: Alignment.center,
    //                             height: 40.0,
    //                             width: 100,
    //                             decoration: new BoxDecoration(
    //                                 borderRadius: BorderRadius.circular(9.0),
    //                                 gradient: new LinearGradient(colors: [
    //                                   Color.fromARGB(144, 176, 175, 175),
    //                                   Color.fromARGB(144, 176, 175, 175),
    //                                 ])),
    //                             padding: const EdgeInsets.all(0),
    //                             child: Text(
    //                               "Cancel",
    //                               style: TextStyle(
    //                                   fontSize: 16,
    //                                   fontWeight: FontWeight.w600,
    //                                   color:
    //                                       Color.fromARGB(255, 255, 255, 255)),
    //                             ),
    //                           ),
    //                         ),
    //                         Container(
    //                           margin: EdgeInsets.only(left: 40),
    //                           child: ElevatedButton(
    //                             onPressed: () {
    //                               if (count >= 1) {
    //                                 for (var i = 0; i < userEmail.length; i++)
    //                                   FirebaseFirestore.instance
    //                                       .collection('FavoriteEvents')
    //                                       .doc(userEmail[i]! +
    //                                           '-' +
    //                                           eventName +
    //                                           '-' +
    //                                           ownerEmail)
    //                                       .update({'status': 'inactive'});
    //                                 FirebaseFirestore.instance
    //                                     .collection('AllEvent')
    //                                     .doc(eventName)
    //                                     .delete();

    //                                 CoolAlert.show(
    //                                   context: context,
    //                                   title:
    //                                       "the event was deleted successfully ",
    //                                   confirmBtnColor:
    //                                       Color.fromARGB(144, 64, 7, 87),
    //                                   onConfirmBtnTap: () {
    //                                     Navigator.push(
    //                                         context,
    //                                         MaterialPageRoute(
    //                                             builder: (context) =>
    //                                                 adminEventsListViewPage()));
    //                                   },
    //                                   type: CoolAlertType.success,
    //                                   backgroundColor:
    //                                       Color.fromARGB(221, 212, 189, 227),
    //                                 );
    //                               }

    //                               /*FirebaseFirestore.instance
    //                                   .collection('FavoriteEvents')
    //                                   .doc(favoriteEmail +
    //                                       "-" +
    //                                       eventName +
    //                                       "-" +
    //                                       ownerEmail)
    //                                   .delete();*/
    //                               else
    //                                 CoolAlert.show(
    //                                   context: context,
    //                                   title:
    //                                       "You cannot delete the event because the number of reports is less than 3",
    //                                   confirmBtnColor:
    //                                       Color.fromARGB(144, 64, 7, 87),
    //                                   onConfirmBtnTap: () {
    //                                     Navigator.push(
    //                                         context,
    //                                         MaterialPageRoute(
    //                                             builder: (context) =>
    //                                                 AdminReportedEvent(
    //                                                     eventName: eventName)));
    //                                   },
    //                                   type: CoolAlertType.error,
    //                                   backgroundColor:
    //                                       Color.fromARGB(221, 212, 189, 227),
    //                                 );
    //                               // deleteprofile();
    //                               // Navigator.push(context,
    //                               // MaterialPageRoute(builder: (context) => UserLogin()));
    //                             },
    //                             style: ElevatedButton.styleFrom(
    //                               surfaceTintColor: Colors.white,
    //                               shape: RoundedRectangleBorder(
    //                                   borderRadius:
    //                                       BorderRadius.circular(80.0)),
    //                               padding: const EdgeInsets.all(0),
    //                             ),
    //                             child: Container(
    //                               alignment: Alignment.center,
    //                               height: 40.0,
    //                               width: 100,
    //                               decoration: new BoxDecoration(
    //                                   borderRadius: BorderRadius.circular(9.0),
    //                                   gradient: new LinearGradient(colors: [
    //                                     Color.fromARGB(144, 210, 2, 2),
    //                                     Color.fromARGB(144, 210, 2, 2)
    //                                   ])),
    //                               padding: const EdgeInsets.all(0),
    //                               child: Text(
    //                                 "Delete",
    //                                 style: TextStyle(
    //                                     fontSize: 16,
    //                                     fontWeight: FontWeight.w600,
    //                                     color:
    //                                         Color.fromARGB(255, 255, 255, 255)),
    //                               ),
    //                             ),
    //                           ),
    //                         ),
    //                       ],
    //                     )
    //                   ],
    //                 ),
    //               )));
    //     });
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
                  // Add your onPressed code here!
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
                title: Text('Reported Event',
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
                                  //shadowColor: Color.fromARGB(255, 255, 255, 255),
                                  //  elevation: 7,

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
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             AdmineventDetailScreen(
                                //               eventName: EventnameList[index],
                                //             ))
                                //             );
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
                        //  cancelBtnColor: Colors.black,
                        //  cancelBtnTextStyle: TextStyle(color: Color.fromARGB(255, 237, 7, 7), fontWeight:FontWeight.w600,fontSize: 18.0),
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
  // return showDialog(
  //     context: context,
  //     builder: (context) {
  //       return Center(
  //           child: Material(
  //               type: MaterialType.transparency,
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(10),
  //                   color: const Color.fromARGB(255, 255, 255, 255),
  //                 ),
  //                 padding: const EdgeInsets.all(15),
  //                 height: 150,
  //                 width: MediaQuery.of(context).size.width * 0.9,
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: <Widget>[
  //                     // Code for acceptance role
  //                     Row(children: <Widget>[
  //                       Expanded(
  //                         flex: 2,
  //                         child: GestureDetector(
  //                           child: Text(
  //                             " Are you sure you want to log out? ",
  //                             style: const TextStyle(
  //                               fontSize: 14,
  //                               color: Color.fromARGB(159, 64, 7, 87),
  //                               fontWeight: FontWeight.bold,
  //                             ),
  //                           ),
  //                           onTap: () {
  //                             // go to participant's profile
  //                           },
  //                         ),
  //                       ),
  //                       // const SizedBox(
  //                       //   height: 10,
  //                       // ),
  //                     ]),
  //                     SizedBox(
  //                       height: 35,
  //                     ),
  //                     //----------------------------------------------------------------------------
  //                     Row(
  //                       children: <Widget>[
  //                         Text("   "),
  //                         Text("     "),
  //                         ElevatedButton(
  //                           onPressed: () {
  //                             Navigator.pop(context);
  //                           },
  //                           style: ElevatedButton.styleFrom(
  //                             surfaceTintColor: Colors.white,
  //                             shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(80.0)),
  //                             padding: const EdgeInsets.all(0),
  //                           ),
  //                           child: Container(
  //                             alignment: Alignment.center,
  //                             height: 40.0,
  //                             width: 100,
  //                             decoration: new BoxDecoration(
  //                                 borderRadius: BorderRadius.circular(9.0),
  //                                 gradient: new LinearGradient(colors: [
  //                                   Color.fromARGB(144, 176, 175, 175),
  //                                   Color.fromARGB(144, 176, 175, 175),
  //                                 ])),
  //                             padding: const EdgeInsets.all(0),
  //                             child: Text(
  //                               "Cancel",
  //                               style: TextStyle(
  //                                   fontSize: 16,
  //                                   fontWeight: FontWeight.w600,
  //                                   color: Color.fromARGB(255, 255, 255, 255)),
  //                             ),
  //                           ),
  //                         ),
  //                         Container(
  //                           margin: EdgeInsets.only(left: 40),
  //                           child: ElevatedButton(
  //                             onPressed: () {
  //                               _signOut();
  //                               Navigator.push(
  //                                   context,
  //                                   MaterialPageRoute(
  //                                       builder: (context) => UserLogin()));
  //                               // CoolAlert.show(
  //                               //   context: context,
  //                               //   title: "Success!",
  //                               //   confirmBtnColor:
  //                               //       Color.fromARGB(144, 64, 6, 87),
  //                               //   type: CoolAlertType.success,
  //                               //   backgroundColor:
  //                               //       Color.fromARGB(221, 212, 189, 227),
  //                               //   text: "You have logged out successfully",
  //                               //   confirmBtnText: 'Done',
  //                               //   onConfirmBtnTap: () {
  //                               //     //send join requist
  //                               //     _signOut();
  //                               //     Navigator.push(
  //                               //         context,
  //                               //         MaterialPageRoute(
  //                               //             builder: (context) => UserLogin()));
  //                               //   },
  //                               // );
  //                             },
  //                             style: ElevatedButton.styleFrom(
  //                               surfaceTintColor: Colors.white,
  //                               shape: RoundedRectangleBorder(
  //                                   borderRadius: BorderRadius.circular(80.0)),
  //                               padding: const EdgeInsets.all(0),
  //                             ),
  //                             child: Container(
  //                               alignment: Alignment.center,
  //                               height: 40.0,
  //                               width: 100,
  //                               decoration: new BoxDecoration(
  //                                   borderRadius: BorderRadius.circular(9.0),
  //                                   gradient: new LinearGradient(colors: [
  //                                     Color.fromARGB(144, 210, 2, 2),
  //                                     Color.fromARGB(144, 210, 2, 2)
  //                                   ])),
  //                               padding: const EdgeInsets.all(0),
  //                               child: Text(
  //                                 "Log out",
  //                                 style: TextStyle(
  //                                     fontSize: 16,
  //                                     fontWeight: FontWeight.w600,
  //                                     color:
  //                                         Color.fromARGB(255, 255, 255, 255)),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     )
  //                   ],
  //                 ),
  //               )));
  //     });
}
