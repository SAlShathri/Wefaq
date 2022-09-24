import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wefaq/ReceivedJoinRequest.dart';
import 'package:wefaq/backgroundHome.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';
import 'package:wefaq/myProjects.dart';
import 'package:wefaq/userLogin.dart';
import 'package:intl/intl.dart';
import 'package:wefaq/TabScreen.dart';
import 'package:wefaq/userLogin.dart';
import 'package:wefaq/bottom_bar_custom.dart';
import 'dart:async';
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
            child: Column(children: [
          SizedBox(
            height: 33,
          ),
          Container(
            margin: EdgeInsets.only(left: 330, top: 15),
            child: IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                onPressed: () {
                  _signOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserLogin()));
                }),
          ),
          SizedBox(
            height: 30,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text("   Hello $FName!",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 35),
                textAlign: TextAlign.left),
          ),
          SizedBox(
            height: 200,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text("    Swipe left to view more <--",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 93, 76, 134),
                    fontSize: 20),
                textAlign: TextAlign.left),
          ),
          Container(
              margin: EdgeInsets.only(top: 40),
              height: 240,
              child: ListView(scrollDirection: Axis.horizontal, children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => myProjects()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(255, 246, 244, 248),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(20, 17),
                            blurRadius: 30,
                            spreadRadius: -23,
                            color: Color.fromARGB(255, 176, 146, 189),
                          ),
                        ],
                        image: new DecorationImage(
                          image: new AssetImage("assets/images/2.png"),
                        ),
                      ),
                      child: Text("   My Projects   ",
                          style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(221, 73, 105, 119),
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RequestListViewPage()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(255, 246, 244, 248),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(20, 17),
                            blurRadius: 30,
                            spreadRadius: -23,
                            color: Color.fromARGB(255, 176, 146, 189),
                          ),
                        ],
                        image: new DecorationImage(
                          image: new AssetImage("assets/images/1.png"),
                        ),
                      ),
                      child: Text("   My Requests   ",
                          style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(221, 73, 105, 119),
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(255, 246, 244, 248),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(20, 17),
                            blurRadius: 30,
                            spreadRadius: -23,
                            color: Color.fromARGB(255, 176, 146, 189),
                          ),
                        ],
                        image: new DecorationImage(
                            image: new AssetImage("assets/images/3.png")),
                      ),
                      child: Text("   My favourites   ",
                          style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(221, 73, 105, 119),
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ]))
        ])

            // This trailing comma makes auto-formatting nicer for build methods.
            ));
  }
}
