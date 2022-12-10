import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:wefaq/AcceptedSentJoinRequest.dart';
import 'package:wefaq/AdminNavBar.dart';
import 'package:wefaq/DeclinedSentJoinRequest.dart';
import 'package:wefaq/PendingSentJoinRequest.dart';
import 'package:wefaq/ReportedEvents.dart';
import 'package:wefaq/ResolvedEvents.dart';
import 'package:wefaq/bottom_bar_custom.dart';
import 'package:wefaq/userLogin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'HomePage.dart';

// Main Stateful Widget Start
class AdminTabs extends StatefulWidget {
  @override
  _ListViewTabsState createState() => _ListViewTabsState();
}

class _ListViewTabsState extends State<AdminTabs> {
  @override
  void initState() {
    // TODO: implement initState
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
            title: Text(
              'Reported Events',
              style: TextStyle(
                  color: Color.fromARGB(159, 0, 0, 0),
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            bottom: const TabBar(
              indicatorColor: Color.fromARGB(144, 64, 7, 87),
              indicatorWeight: 6,
              labelStyle: TextStyle(
                  fontSize: 18.0, fontFamily: 'Family Name'), //For Selected tab
              unselectedLabelStyle: TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'Family Name'), //For Un-selected Tabs
              tabs: [
                Tab(
                  text: 'New Reports',
                ),
                Tab(text: 'Resolved Reports'),
              ],
              labelColor: Color.fromARGB(144, 64, 7, 87),
            ),
          ),
          body: TabBarView(physics: NeverScrollableScrollPhysics(), children: [
            ReportedEventsList(),
            ResolvedEventsList(),
          ]),
          bottomNavigationBar: AdminCustomNavigationBar(
            currentHomeScreen: 1,
            updatePage: () {},
          ),
        ));
  }
}

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}
