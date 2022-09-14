import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wefaq/backgroundHome.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';
import 'package:wefaq/myProjects.dart';

import 'bottom_bar_custom.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;
  late User signedInUser;
  @override
  void initState() {
    super.initState();
    getUser();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = auth.currentUser;
      if (user != null) {
        signedInUser = user;
        print(signedInUser.uid);
        print(signedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  var FName;
  Future getUser() async {
    await for (var snapshot
        in FirebaseFirestore.instance.collection('users').snapshots())
      for (var user in snapshot.docs) {
        if (user.data()['Email'] == signedInUser.email) {
          setState(() {
            FName = (user.data()['FirstName']);
          });
        }
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   title: Text(
        //     'Home',
        //     style: TextStyle(
        //         color: Color.fromARGB(255, 138, 123, 161),
        //         fontWeight: FontWeight.bold),
        //   ),
        // ),
        bottomNavigationBar: CustomNavigationBar(
          currentHomeScreen: 0,
          updatePage: () {},
        ),
        body: BackgroundHome(
            child: Column(children: [
          SizedBox(
            height: 100,
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
          Container(
              margin: EdgeInsets.only(top: 350),
              height: 200,
              child: ListView(scrollDirection: Axis.horizontal, children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(255, 255, 255, 255),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 17),
                            blurRadius: 17,
                            spreadRadius: -23,
                            color: Color.fromARGB(255, 186, 160, 190),
                          ),
                        ],
                        image: new DecorationImage(
                            image: new AssetImage(
                                "assets/images/MyFavorites.png")),
                      ),
                      child: Text("   My favourites   ",
                          style: TextStyle(
                              fontSize: 24,
                              color: Color.fromARGB(221, 81, 122, 140),
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      //next sprint :)
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(255, 255, 255, 255),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 17),
                            blurRadius: 17,
                            spreadRadius: -23,
                            color: Color.fromARGB(255, 186, 160, 190),
                          ),
                        ],
                        image: new DecorationImage(
                          image: new AssetImage("assets/images/MyRequest.png"),
                        ),
                      ),
                      child: Text("   My Requests   ",
                          style: TextStyle(
                              fontSize: 24,
                              color: Color.fromARGB(221, 81, 122, 140),
                              fontWeight: FontWeight.bold)),
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
                              builder: (context) => myProjects()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(255, 255, 255, 255),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 17),
                            blurRadius: 17,
                            spreadRadius: -23,
                            color: Color.fromARGB(255, 186, 160, 190),
                          ),
                        ],
                        image: new DecorationImage(
                          image: new AssetImage("assets/images/MyP.png"),
                        ),
                      ),
                      child: Text("   My Projects   ",
                          style: TextStyle(
                              fontSize: 24,
                              color: Color.fromARGB(221, 81, 122, 140),
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ]))
        ])

            // This trailing comma makes auto-formatting nicer for build methods.
            ));
  }
}
