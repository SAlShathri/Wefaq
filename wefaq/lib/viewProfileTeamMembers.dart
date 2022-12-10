import 'dart:async';

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_icons/line_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wefaq/UserLogin.dart';
import 'package:wefaq/userPeojectsTap.dart';
import 'package:wefaq/userReport.dart';
import 'bottom_bar_custom.dart';

class viewProfileTeamMembers extends StatefulWidget {
  String userEmail;
  String projectName;

  viewProfileTeamMembers({required this.userEmail, required this.projectName});

  @override
  State<viewProfileTeamMembers> createState() =>
      _viewprofileState(this.userEmail, this.projectName);
}

class _viewprofileState extends State<viewProfileTeamMembers> {
  String userEmail;
  String projectName;
  _viewprofileState(this.userEmail, this.projectName);

  @override
  void initState() {
    getUser();

    super.initState();
  }

  final auth = FirebaseAuth.instance;
  late User signedInUser;
  var currentUserEmail = FirebaseAuth.instance.currentUser!.email;
  final _firestore = FirebaseFirestore.instance;

  String fname = "";
  String lname = "";
  String about = "";
  String experince = "";
  String cerifi = "";
  String skills = "";
  String role = "";
  String gitHub = "";
  String photo = '';
  double rating = 0.0;
  List<String> selectedOptionList = [];
  var userWhoRated = [];

  Future getUser() async {
    var fillterd = _firestore
        .collection('users')
        .where("Email", isEqualTo: userEmail)
        .snapshots();
    await for (var snapshot in fillterd)
      for (var user in snapshot.docs) {
        setState(() {
          photo = user["Profile"].toString();
          fname = user["FirstName"].toString();
          lname = user["LastName"].toString();
          about = user["about"].toString();
          experince = user["experince"].toString();
          cerifi = user["cerifi"].toString();
          role = user["role"].toString();
          gitHub = user["gitHub"].toString();
          rating = user["rating"];

          for (var user in user["userWhoRated"]) {
            userWhoRated.add(user.toString());
          }

          for (var skill in user["skills"]) {
            if (!selectedOptionList.contains(skill.toString()))
              selectedOptionList.add(skill.toString());
          }
        });
      }
  }

  String getUserRating() {
    List<String> splited = [];
    for (var i = 0; i < userWhoRated.length; i++) {
      splited = userWhoRated[i].toString().split("-");

      if (splited[1].toString() == currentUserEmail &&
          splited[2].toString() == projectName &&
          splited[3].toString() == userEmail) return splited[0].toString();
    }

    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 238, 237, 240),
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_sharp,
              color: Color.fromARGB(159, 56, 6, 75),
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          'Profile',
          style: TextStyle(
              color: Color.fromARGB(159, 0, 0, 0), fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentHomeScreen: 0,
        updatePage: () {},
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            SizedBox(
              height: 220,
              width: double.infinity,
              child: Image(
                image: AssetImage(
                  "assets/images/header_profile.png",
                ),
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.only(top: 120),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(children: <Widget>[
                                  SizedBox(
                                    width: 60,
                                  ),
                                  Text("      " + "$fname" + " $lname",
                                      style: TextStyle(fontSize: 18)),
                                  Expanded(
                                    child: SizedBox(
                                      width: 20,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 0),
                                    height: 56.0,
                                    width: 56.0,
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.error_outline,
                                          color:
                                              Color.fromARGB(255, 186, 48, 48),
                                          size: 30,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      reportUser(
                                                        userEmail: userEmail,
                                                        userName: fname,
                                                      )));
                                        }),
                                  ),
                                ]),
                                Row(children: <Widget>[
                                  Expanded(
                                      child: Column(children: <Widget>[
                                    ListTile(
                                      contentPadding: EdgeInsets.all(0),

                                      //You can add Subtitle here
                                    ),
                                  ])),
                                  Column(
                                    children: <Widget>[
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      userProjectsTabs(
                                                          userEmail:
                                                              userEmail)),
                                            );
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 30,
                                            width: 120,
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  201, 231, 229, 229),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              "View projects",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 96, 51, 104),
                                                fontSize: 14,
                                              ),
                                            ),
                                          ))
                                    ],
                                  ),
                                ])
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 80,
                      margin: EdgeInsets.only(left: 15, top: 140),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 0),
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.15),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage("$photo"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    children: <Widget>[
                      //add to userWhoRated
                      if (!userWhoRated.contains(getUserRating() +
                          "-$currentUserEmail-$projectName-$userEmail"))
                        ListTile(
                          title: Text(
                            "     Rate your work experience with $fname ! ",
                            style: TextStyle(
                                color: Color.fromARGB(255, 144, 120, 155)),
                          ),
                        ),
                      //add to userWhoRated
                      if (userWhoRated.contains(getUserRating() +
                          "-$currentUserEmail-$projectName-$userEmail"))
                        ListTile(
                          title: Text(
                            "     You already rated $fname " +
                                getUserRating() +
                                " out of 5",
                            style: TextStyle(
                                color: Color.fromARGB(255, 144, 120, 155)),
                          ),
                        ),

                      if (!userWhoRated.contains(getUserRating() +
                          "-$currentUserEmail-$projectName-$userEmail"))
                        RatingBar.builder(
                          initialRating: 0,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Color.fromARGB(255, 255, 214, 11),
                          ),
                          onRatingUpdate: (newRating) {
                            setState(() {
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userEmail)
                                  .update({
                                'rating': (((rating * userWhoRated.length +
                                            newRating)) /
                                        (userWhoRated.length + 1))
                                    .roundToDouble()
                              });

                              Timer(Duration(seconds: 3), () {
                                Fluttertoast.showToast(
                                  msg:
                                      "Thank you! your rating has been submitted successfully",
                                  fontSize: 18,
                                  gravity: ToastGravity.CENTER,
                                  toastLength: Toast.LENGTH_LONG,
                                  backgroundColor:
                                      Color.fromARGB(172, 136, 98, 146),
                                );
                                if (!userWhoRated.contains(getUserRating() +
                                    "-$currentUserEmail-$projectName-$userEmail")) {
                                  userWhoRated.add(
                                      "$newRating-$currentUserEmail-$projectName-$userEmail");
                                  //update on the db

                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(userEmail)
                                      .update({'userWhoRated': userWhoRated});
                                }
                              });

                              //add to userWhoRated
                            });
                          },
                        ),
                      //add to userWhoRated
                      if (!userWhoRated.contains(getUserRating() +
                          "-$currentUserEmail-$projectName-$userEmail"))
                        Divider(),
                      ListTile(
                        title: Text("About"),
                        subtitle: Text("$about"),
                        leading: Icon(Icons.format_align_center),
                      ),
                      ListTile(
                        title: Text("GitHub"),
                        onTap: () => launch("$gitHub"),
                        leading: Icon(
                          LineIcons.github,
                          size: 35,
                          color: Color.fromARGB(255, 93, 18, 107),
                        ),
                      ),
                      ListTile(
                        title: Text("Experience"),
                        subtitle: Text("$experince"),
                        leading: Icon(Icons.calendar_view_day),
                      ),
                      ListTile(
                        title: Text("Skills"),
                        subtitle: Text(selectedOptionList.join(",")),
                        leading: Icon(Icons.schema_rounded),
                      ),
                      ListTile(
                        title: Text("Licenses & certifications"),
                        subtitle: Text("$cerifi"),
                        leading: Icon(
                          Icons.workspace_premium,
                          size: 33,
                        ),
                      ),
                      ListTile(
                          title: Text("Rating"),
                          subtitle: Text("$rating/5.0"),
                          leading: Icon(
                            Icons.star,
                            size: 33,
                          )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                  width: 80,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}
