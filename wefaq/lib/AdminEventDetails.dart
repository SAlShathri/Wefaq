import 'dart:convert';
//import 'dart:js_util';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/link.dart';
import 'package:wefaq/AdminEventList.dart';
import 'package:wefaq/config/colors.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:wefaq/eventsScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:wefaq/eventsTabs.dart';
import 'package:wefaq/screens/detail_screens/widgets/event_detail_appbar.dart';
import 'package:wefaq/service/local_push_notification.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wefaq/AdminNavBar.dart';

import '../../Report.dart';

class AdmineventDetailScreen extends StatefulWidget {
  String eventName;

  AdmineventDetailScreen({required this.eventName});

  @override
  State<AdmineventDetailScreen> createState() =>
      _eventDetailScreenState(eventName);
}

class _eventDetailScreenState extends State<AdmineventDetailScreen> {
  String? Email;
  @override
  void initState() {
    // TODO: implement initState
    getCurrentUser();
    getProjects();
    isLiked();
    super.initState();
  }

  void getCurrentUser() {
    try {
      final user = auth.currentUser;
      if (user != null) {
        signedInUser = user;
        Email = signedInUser?.email;
        print(signedInUser?.email);
      }
    } catch (e) {
      print(e);
    }
  }

  String eventName;
  _eventDetailScreenState(this.eventName);

  // Title list
  String nameList = "";

  // Description list
  String descList = "";

  // location list
  String locList = "";

  //url list
  String urlList = "";

  //category list
  String categoryList = "";
  String favoriteEmail = "";

  //category list
  String dateTimeList = "";

  String TimeList = "";
/////////////////////////////////////////////////////////////////////////////////////////
  //String favoriteEmail = "";

  String ownerEmail = "";

  String EventName = "";

  int count = 0;

  String fnameList = "";
  String fdescList = "";
  String flocList = "";
  String furlList = "";
  String fcat = "";
  String fdateTimeList = "";
  String fTimeList = "";
  String status = "";
  //category list

  // Description list

  //var latList = [];

  //var lngList = [];
  //List<String> creatDate = [];

  // String reasons = "";
  // String notes = "";
  List<String> reasons = [];
  List<String> notes = [];

  bool _isSelected1 = false;
  bool _isSelected2 = false;
  bool _isSelected3 = false;
  bool isPressed = false;

  Future isLiked() async {
    var collectionRef = FirebaseFirestore.instance.collection('FavoriteEvents');

    var docu = await collectionRef
        .doc(Email! + '-' + EventName + '-' + ownerEmail)
        .get();

    if (docu.exists) {
      print("exist");
      setState(() {
        isPressed = true;
      });
    } else {
      print("doesnt exist");
      setState(() {
        isPressed = false;
      });
    }
  }

  var ProjectTitleList = [];

  var ParticipantEmailList = [];

  var ParticipantNameList = [];
  Status() => EventsTabs();

  List DisplayProjectOnce() {
    final removeDuplicates = [
      ...{...ProjectTitleList}
    ];
    return removeDuplicates;
  }

  //project lan
  var creatDate = [];

  final _firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  late User? signedInUser = auth.currentUser;

  //get all projects
  Future getProjects() async {
    //clear first
    setState(() {
      nameList = "";
      descList = "";
      locList = "";
      urlList = "";
      categoryList = "";
      dateTimeList = "";
      TimeList = "";
      //favoriteEmail = "";
      ownerEmail = "";
      EventName = "";
      count = 0;
    });
    await for (var snapshot in _firestore
        .collection('AllEvent')
        .orderBy('created', descending: true)
        .where('name', isEqualTo: eventName)
        .snapshots())
      for (var events in snapshot.docs) {
        setState(() {
          nameList = events['name'].toString();
          descList = events['description'].toString();
          locList = events['location'].toString();
          urlList = events['regstretion url '].toString();
          categoryList = events['category'].toString();
          dateTimeList = events['date'].toString();
          TimeList = events['time'].toString();
          EventName = events['name'].toString();
          ownerEmail = events['email'].toString();
          count = events['count'];

          //  dateTimeList.add(project['dateTime ']);
        });
      }
  }

  Future getFav() async {
    //clear first
    setState(() {
      nameList = "";
      descList = "";
      locList = "";
      urlList = "";
      categoryList = "";
      dateTimeList = "";
      TimeList = "";
      //favoriteEmail = "";
      ownerEmail = "";
      EventName = "";
      count = 0;
    });
    await for (var snapshot in _firestore
        .collection('FavoriteEvents')
        .orderBy('created', descending: true)
        .where('name', isEqualTo: eventName)
        .snapshots())
      for (var fav in snapshot.docs) {
        setState(() {
          fnameList = fav['eventName'].toString();
          descList = fav['description'].toString();
          locList = fav['location'].toString();
          urlList = fav['URL'].toString();
          categoryList = fav['category'].toString();
          dateTimeList = fav['date'].toString();
          TimeList = fav['time'].toString();
          EventName = fav['name'].toString();
          ownerEmail = fav['ownerEmail'].toString();
          favoriteEmail = fav['favoriteEmail'].toString();
          status = fav['status'].toString();

          //  dateTimeList.add(project['dateTime ']);
        });
      }
  }

  Future getReports() async {
    setState(() {
      reasons = [];
      notes = [];
    });

    await for (var snapshot in _firestore
        .collection('reportedevents')
        .where('reported event name', isEqualTo: eventName)
        .snapshots()) {
      for (var report in snapshot.docs) {
        setState(() {
          reasons.add(report['reason']);
          notes.add(report['note']);
        });
      }
    }
  }

/*
  final auth = FirebaseAuth.instance;
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
  } */
  showDialogFunc(context) {
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
                    height: 190,
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // Code for acceptance role

                        Row(children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              child: Text(
                                "Are you sure you want to delete event?",
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(159, 64, 7, 87),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: () {
                                // go to participant's profile
                              },
                            ),
                          ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                        ]),
                        SizedBox(
                          height: 35,
                        ),
                        //----------------------------------------------------------------------------
                        Row(
                          children: <Widget>[
                            Text(""),
                            Text("        "),
                            ElevatedButton(
                              onPressed: () async {
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
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 40),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (count >= 3) {
                                    FirebaseFirestore.instance
                                        .collection('AllEvent')
                                        .doc(eventName)
                                        .delete();
                                    FirebaseFirestore.instance
                                        .collection('FavoriteEvents')
                                        .doc(favoriteEmail +
                                            '-' +
                                            EventName +
                                            '-' +
                                            ownerEmail)
                                        .update({
                                      'status': "unactive",
                                    });
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
                                                    adminEventsListViewPage()));
                                      },
                                      type: CoolAlertType.error,
                                      backgroundColor:
                                          Color.fromARGB(221, 212, 189, 227),
                                    );
                                  // deleteprofile();
                                  // Navigator.push(context,
                                  // MaterialPageRoute(builder: (context) => UserLogin()));
                                },
                                style: ElevatedButton.styleFrom(
                                  surfaceTintColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(80.0)),
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
                                    "Delete",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: AdminCustomNavigationBar(
          currentHomeScreen: 0,
          updatePage: () {},
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            const eventDetailAppBar(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          nameList,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8.0),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
//                           Container(
//                             margin: EdgeInsets.only(right: 0),
//                             height: 56.0,
//                             width: 56.0,
//                             child: IconButton(
//                                 icon: Icon(
//                                   Icons.error_outline,
//                                   color: Color.fromARGB(255, 186, 48, 48),
//                                   size: 30,
//                                 ),
//                                 onPressed: () {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) => reportEvent(
//                                               eventName: nameList,
//                                               eventOwner: ownerEmail)));
// //showDialogFunc(context);
//                                 }),
//                           ),
                            // Container(
                            //   height: 50.0,
                            //   width: 50.0,
                            //   alignment: Alignment.center,
                            //   margin: const EdgeInsets.only(right: 8.0),
                            //   decoration: const BoxDecoration(
                            //     shape: BoxShape.circle,
                            //   ),
                            //   child: IconButton(
                            //     icon: (isPressed)
                            //         ? const Icon(Icons.favorite,
                            //             color: Color.fromARGB(172, 136, 98, 146))
                            //         : const Icon(Icons.favorite_border,
                            //             color: Color.fromARGB(172, 136, 98, 146)),
                            //     onPressed: () {
                            //       setState(() {
                            //         print(isPressed);
                            //         if (isPressed) {
                            //           isPressed = false;
                            //           print(isPressed);
                            //           ShowToastRemove();

                            //           FirebaseFirestore.instance
                            //               .collection('FavoriteEvents')
                            //               .doc(Email! +
                            //                   '-' +
                            //                   EventName +
                            //                   '-' +
                            //                   ownerEmail)
                            //               .delete();
                            //         } else {
                            //           isPressed = true;
                            //           print(isPressed);
                            //           ShowToastAdd();

                            //           _firestore
                            //               .collection('FavoriteEvents')
                            //               .doc(Email! +
                            //                   '-' +
                            //                   EventName +
                            //                   '-' +
                            //                   ownerEmail)
                            //               .set({
                            //             'favoriteEmail': Email,
                            //             'ownerEmail': ownerEmail,
                            //             'eventName': EventName,
                            //             'description': descList,
                            //             'location': locList,
                            //             'URL': urlList,
                            //             'category': categoryList,
                            //             'date': dateTimeList,
                            //             'time': TimeList,
                            //           });
                            //         }
                            //       });
                            //     },
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 32.0,
                              width: 32.0,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(right: 8.0),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.location_pin,
                                  color: Color.fromARGB(172, 136, 98, 146)),
                            ),
                            Text(
                              locList,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    const Divider(color: kOutlineColor, height: 1.0),
                    const SizedBox(height: 16.0),
                    Text(
                      'Description',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Color.fromARGB(246, 83, 82, 82)),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      descList,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: kSecondaryTextColor),
                    ),
                    const SizedBox(height: 16.0),
                    const Divider(color: kOutlineColor, height: 1.0),
                    const SizedBox(height: 16.0),
                    Text(
                      'Category',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16.0),
                    _buildIngredientItem(context, categoryList),
                    const Divider(color: kOutlineColor, height: 1.0),
                    const SizedBox(height: 16.0),
                    Text(
                      'Date and time',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8.0),
                    Row(children: <Widget>[
                      const Icon(
                        Icons.calendar_today,
                        color: Color.fromARGB(172, 136, 98, 146),
                        size: 21,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        dateTimeList,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Color.fromARGB(246, 83, 82, 82)),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        TimeList,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Color.fromARGB(246, 83, 82, 82)),
                      ),
                    ]),
                    const SizedBox(height: 16.0),
                    const Divider(color: kOutlineColor, height: 1.0),
                    const SizedBox(height: 16.0),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 56,
                      margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom,
                        left: 24,
                        right: 24,
                      ),
                      child: Link(
                          target: LinkTarget.blank,
                          uri: Uri.parse(urlList),
                          builder: (context, followLink) => ElevatedButton(
                                onPressed: followLink,
                                child: Text(
                                  'Registration link',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: 17),
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(204, 109, 46, 154),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    )),
                              )),
                    ),
                    Container(
                        //   child: ListView.builder(

                        //     itemCount: reasons.length,
                        //     itemBuilder: (context, index) {
                        child: SizedBox(
                      height: 180,
                      child: GestureDetector(
                        child: Card(
                            color: Color.fromARGB(235, 255, 255, 255),
                            //shadowColor: Color.fromARGB(255, 255, 255, 255),
                            //  elevation: 7,

                            child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(children: <Widget>[
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(
                                          Icons.report_gmailerrorred,
                                          color:
                                              Color.fromARGB(255, 202, 51, 41),
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
                                          "test",
                                          // reasons[index]
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
                                            // notes[index]
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Color.fromARGB(
                                                  212, 82, 10, 111),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ]),
                                      ),
                                    ]))),
                      ),
                    )
                        //  }
                        //  )
                        ),
                    SizedBox(height: 20),
                    Container(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () async {
                          showDialogFunc(context);
                          // deleteprofile();
                          //   Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) => UserLogin()));
                        },
                        style: ElevatedButton.styleFrom(
                          surfaceTintColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80.0)),
                          padding: const EdgeInsets.all(0),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          width: 150,
                          // width: size.width * 0.5,
                          decoration: new BoxDecoration(
                            borderRadius: BorderRadius.circular(80.0),
                            color: Color.fromARGB(204, 109, 46, 154),
                          ),
                          padding: const EdgeInsets.all(0),
                          child: Text(
                            "Delete Event",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildIngredientItem(
    BuildContext context,
    String title,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            height: 24.0,
            width: 24.0,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(right: 8.0),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 229, 214, 237),
            ),
            child: const Icon(
              Icons.check,
              color: Color.fromARGB(172, 113, 60, 127),
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}

// void ShowToastRemove() => Fluttertoast.showToast(
//       msg: "Project is removed form favorite",
//       fontSize: 18,
//       gravity: ToastGravity.CENTER,
//       toastLength: Toast.LENGTH_SHORT,
//       backgroundColor: Color.fromARGB(172, 136, 98, 146),
//     );

// void ShowToastAdd() => Fluttertoast.showToast(
//       msg: "Project is added to favorite",
//       fontSize: 18,
//       gravity: ToastGravity.CENTER,
//       toastLength: Toast.LENGTH_SHORT,
//       backgroundColor: Color.fromARGB(172, 136, 98, 146),
//     );
