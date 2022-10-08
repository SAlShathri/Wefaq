import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wefaq/profile.dart';
import 'RJRprojects.dart';
import 'package:wefaq/backgroundHome.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';
import 'package:wefaq/myProjects.dart';
import 'package:wefaq/AcceptedSentJoinRequest.dart';
import 'package:wefaq/userLogin.dart';
import 'package:intl/intl.dart';
import 'package:wefaq/TabScreen.dart';
import 'package:wefaq/userLogin.dart';
import 'package:wefaq/bottom_bar_custom.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:multiselect/multiselect.dart';
import 'package:get/get.dart';
import 'package:google_place/google_place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wefaq/projectsScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'bottom_bar_custom.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

//,,,
class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;
  late User signedInUser;
  @override
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  var name = '${FirebaseAuth.instance.currentUser!.displayName}'.split(' ');
  get FName => name.first;

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
                        size: 40,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      })),
              Container(
                margin: EdgeInsets.only(left: 380, top: 40),
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
                                    // next sprint :)
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
