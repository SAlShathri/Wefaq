import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wefaq/AdminBackground.dart';
import 'package:wefaq/AdminEventList.dart';
import 'package:wefaq/AdminNavBar.dart';
import 'package:wefaq/AdminProjectList.dart';
import 'package:flutter/material.dart';
import 'package:wefaq/userLogin.dart';
import 'dart:async';

class adminHomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}

//,,,
class HomeScreenState extends State<adminHomeScreen> {
  final auth = FirebaseAuth.instance;
  late User signedInUser;
  @override
  void initState() {
    getCurrentUser();
    getProjectTitle();
    getProjectTitleOwner();
    super.initState();
  }

  static List<String> ProjectTitleList = [];
  String? Email;
  final _firestore = FirebaseFirestore.instance;
  var name = '${FirebaseAuth.instance.currentUser!.displayName}'.split(' ');
  get FName => name.first;
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

  Future getProjectTitleOwner() async {
    if (Email != null) {
      var fillterd = _firestore
          .collection('AllJoinRequests')
          .where('owner_email', isEqualTo: Email)
          .snapshots();
      await for (var snapshot in fillterd)
        for (var Request in snapshot.docs) {
          setState(() {
            if (!ProjectTitleList.contains(Request['project_title'].toString()))
              ProjectTitleList.add(Request['project_title'].toString());
          });
        }
    }
  }

  Future getProjectTitle() async {
    if (Email != null) {
      var fillterd = _firestore
          .collection('AllJoinRequests')
          .where('participant_email', isEqualTo: Email)
          .where('Status', isEqualTo: 'Accepted')
          .snapshots();
      await for (var snapshot in fillterd)
        for (var Request in snapshot.docs) {
          setState(() {
            if (!ProjectTitleList.contains(Request['project_title'].toString()))
              ProjectTitleList.add(Request['project_title'].toString());
          });
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: AdminCustomNavigationBar(
          currentHomeScreen: 0,
          updatePage: () {},
        ),
        backgroundColor: Color.fromARGB(255, 245, 244, 255),
        body: adminBackgroundHome(
            child: Stack(
          children: <Widget>[
            SizedBox(
              height: 33,
            ),
            Container(
              margin: EdgeInsets.only(left: 310, top: 40),
              child: IconButton(
                  icon: Icon(
                    Icons.logout,
                    size: 30,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  onPressed: () {
                    showDialogFunc(context);
                  }),
            ),
            SizedBox(
              height: 130,
            ),
            Container(
              margin: EdgeInsets.only(left: 10, top: 125),
              alignment: Alignment.topCenter,
            ),
            SizedBox(
              height: 200,
            ),
            Padding(
              padding: EdgeInsets.only(top: 290),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 70,
                      ),
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 1,
                          childAspectRatio: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 50,
                          children: <Widget>[
                            CategoryCard(
                                title: "Upcoming Projects",
                                imgSrc: "01.png",
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              adminProjectsListViewPage()));
                                }),
                            CategoryCard(
                                title: "Upcoming Events",
                                imgSrc: "02.png",
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              adminEventsListViewPage()));
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        )));
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String imgSrc;

  final Function() onTap;

  const CategoryCard({
    required this.title,
    required this.imgSrc,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        // padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              offset: Offset(40, 20),
              blurRadius: 30,
              spreadRadius: -23,
              color: Color.fromARGB(218, 161, 158, 162),
            ),
          ],
          image: new DecorationImage(
            image: new AssetImage("assets/images/$imgSrc"),
          ),
        ),
        child: Material(
          color: Color.fromARGB(0, 167, 22, 22),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: <Widget>[
                  Spacer(),
                  Spacer(),
                  Text("$title",
                      style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 61, 132, 163),
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

showDialogFunc(context) {
  CoolAlert.show(
    context: context,
    title: "",
    confirmBtnColor: Color.fromARGB(144, 210, 2, 2),
    confirmBtnText: 'log out ',
    onConfirmBtnTap: () {
      _signOut();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => UserLogin()));
    },
    type: CoolAlertType.confirm,
    backgroundColor: Color.fromARGB(221, 212, 189, 227),
    text: "Are you sure you want to log out?",
  );
}
