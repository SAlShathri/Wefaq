import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wefaq/UserLogin.dart';
import 'package:wefaq/userProjects.dart';
import 'bottom_bar_custom.dart';

class viewotherprofile extends StatefulWidget {
  String userEmail;
  viewotherprofile({required this.userEmail});

  @override
  State<viewotherprofile> createState() => _viewprofileState(this.userEmail);
}

class _viewprofileState extends State<viewotherprofile> {
  String userEmail;
  _viewprofileState(this.userEmail);
  final auth = FirebaseAuth.instance;
  late User signedInUser;
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
  List<String> selectedOptionList = [];

  @override
  void initState() {
    getUser();
    super.initState();
  }

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
          for (var skill in user["skills"])
            selectedOptionList.add(skill.toString());
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 238, 237, 240),
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.logout,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserLogin()));
              }),
        ],
        backgroundColor: Color.fromARGB(255, 162, 148, 183),
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
            Container(
              margin: EdgeInsets.fromLTRB(15, 200, 15, 15),
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(15),
                        margin: EdgeInsets.only(top: 0),
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
                                    Expanded(
                                        child: Column(children: [
                                      Text("      " + "$fname" + " $lname",
                                          style: TextStyle(fontSize: 18)),
                                    ])),
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
                                                        userProjects(
                                                            userEmail:
                                                                userEmail)),
                                              );
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: 30,
                                              width: 100,
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
                        margin: EdgeInsets.only(left: 15, top: 10),
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
                        ListTile(
                          title: Text("General Information"),
                        ),
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
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                    width: 80,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
