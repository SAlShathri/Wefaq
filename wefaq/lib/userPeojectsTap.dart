import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:wefaq/HomePage.dart';
import 'package:wefaq/bottom_bar_custom.dart';
import 'package:wefaq/chatRoom.dart';
import 'package:wefaq/mapView.dart';
import 'package:wefaq/userProjects.dart';
import 'package:wefaq/userLogin.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'ownerProjects.dart';

// Main Stateful Widget Start
class userProjectsTabs extends StatefulWidget {
  String userEmail;
  userProjectsTabs({required this.userEmail});

  @override
  _ListViewTabsState createState() => _ListViewTabsState(this.userEmail);
}

class _ListViewTabsState extends State<userProjectsTabs> {
  @override
  String userEmail;
  _ListViewTabsState(this.userEmail);

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery to get Device Width
    double width = MediaQuery.of(context).size.width * 0.6;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Color.fromARGB(159, 56, 6, 75),
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            title: Text(
              'Projects',
              style: TextStyle(
                  color: Color.fromARGB(159, 0, 0, 0),
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            bottom: const TabBar(
              indicatorColor: Color.fromARGB(159, 56, 6, 75),

              indicatorWeight: 6,
              labelStyle: TextStyle(
                  fontSize: 17.0, fontFamily: 'Family Name'), //For Selected tab
              unselectedLabelStyle:
                  TextStyle(fontSize: 15.0, fontFamily: 'Family Name'),
              //For Un-selected Tabs
              tabs: [
                Tab(text: 'participated Projects'),
                Tab(
                  text: 'Owned projects',
                ),
              ],
              labelColor: Color.fromARGB(159, 56, 6, 75),
            ),
          ),
          body: TabBarView(children: [
            userProjects(
              userEmail: userEmail,
            ),
            owneruserProjects(
              userEmail: userEmail,
            )
          ]),
          bottomNavigationBar: CustomNavigationBar(
            currentHomeScreen: 1,
            updatePage: () {},
          ),
        ));
  }
}

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}
