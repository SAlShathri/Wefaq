import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wefaq/FavoritePage.dart';
//import 'package:wefaq/favoriteProject.dart';
import 'package:wefaq/profile.dart';
import 'RJRprojects.dart';
import 'package:wefaq/backgroundHome.dart';
import 'package:flutter/material.dart';
import 'package:wefaq/myProjects.dart';
import 'package:wefaq/userLogin.dart';
import 'package:wefaq/TabScreen.dart';
import 'package:wefaq/bottom_bar_custom.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'ProjectsTapScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

//,,,
class HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;
  late User signedInUser;
  @override
  void initState() {
    getCurrentUser();
    getProjectTitle();
    getProjectTitleOwner();
    super.initState();
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
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
        bottomNavigationBar: CustomNavigationBar(
          currentHomeScreen: 0,
          updatePage: () {},
        ),
        body: BackgroundHome(
          child: Stack(
            children: <Widget>[
              SizedBox(
                height: 33,
              ),
              Container(
                  margin: EdgeInsets.only(top: 40),
                  child: IconButton(
                      icon: Icon(
                        CupertinoIcons.profile_circled,
                        size: 55,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      })),
              Container(
                margin: EdgeInsets.only(left: 340, top: 40),
                child: IconButton(
                    icon: Icon(
                      Icons.logout,
                      size: 30,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                    onPressed: () {
                      _signOut();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => UserLogin()));
                    }),
              ),
              SizedBox(
                height: 130,
              ),
              Container(
                margin: EdgeInsets.only(left: 10, top: 125),
                alignment: Alignment.topLeft,
                child: Text("Hello $FName!",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 32),
                    textAlign: TextAlign.left),
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
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: .85,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            children: <Widget>[
                              CategoryCard(
                                  title: "My Projects",
                                  imgSrc: "2.png",
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                myProjects()));
                                  }),
                              CategoryCard(
                                  title: "Sent Request",
                                  imgSrc: "4.png",
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Tabs()));
                                  }),
                              CategoryCard(
                                  title: "Received Request",
                                  imgSrc: "1.png",
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RequestListViewPageProject()));
                                  }),
                              CategoryCard(
                                  title: "My Favorites",
                                  imgSrc: "3.png",
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                favoritePage()));
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
          ),
        ));
  }
}

class CategoryCard extends StatelessWidget {
  final String imgSrc;
  final String title;
  final Function() onTap;

  const CategoryCard({
    required this.imgSrc,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: Container(
        // padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              offset: Offset(20, 17),
              blurRadius: 30,
              spreadRadius: -23,
              color: Color.fromARGB(255, 46, 36, 50),
            ),
          ],
          image: new DecorationImage(
            image: new AssetImage("assets/images/$imgSrc"),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Spacer(),
                  Spacer(),
                  Text("$title",
                      style: TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(221, 73, 105, 119),
                          fontWeight: FontWeight.normal)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
